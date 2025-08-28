# Path functions are helpers
# To standardize R projects regardless of installation

#' Ensure some paths ends with an ending slash
#' @param x path to check for ending slash
#' @noRd
ending_slash <- function (x)
{
  ifelse(endsWith(x, "/"), x, paste0(x, "/"))
}

single_string <- function(x) {
  name = deparse(substitute(x))
  x = as.character(x)
  if(is.na(x)) {
    rlang::abort(paste0(sQuote(name), " must be a character value, NA given "))
  }
  if(!rlang::is_character(x, 1L)) {
    rlang::abort(paste0(sQuote(name), " must be a single value"))
  }
  x
}

#' Path Builder allow to build path from components
#' @details
#' Components are : a root path, some optional prefixes and a suffix (path inside the root)
#' It manages the path creation for the global out path
#' Path can be created from several components with the general form
#' root / [prefixes] / suffix
#' prefixes are optional
#' The Builder can also use an absolute mode, using directly a full path, in this mode the components are not used
#'
#' @export
PathBuilder = R6::R6Class("PathBuilder",
  private=list(

    # #' @field root Root of the path. Can be a single string or a function returning a single string
    root=NULL,

    # #' @field prefixes List of path prefixes
    prefixes=list(),

    # #' @field suffix Current suffix to add to the root
    suffix=NULL,

    # #' @field path Actual real path, used as cache.
    current_path=NULL,

    # #' @field absolute Is current path in absolute mode
    absolute=FALSE
  ),
  public=list(
    #' @description
    #' Create the path builder instance for the given root path
    #' @param root character root path
    initialize=function(root) {
      self$set_root(root, FALSE) # Do not update current path on init, will be done on first use
    },
    #' @description
    #' Set the root path of the builder
    #' @param root the root path to set
    set_root = function(root, update=TRUE) {
      if(!is.function(root)) {
        root = single_string(root)
      }
      private$root = root
      if(update) {
        self$update()
      }
    },

    #' @description
    #' Get the root path value.
    #' @returns returns the actual value of root path, even if it's a function. To get the root value use `resolve_root()` instead
    get_root = function() {
      private$root
    },

    #' @description
    #' Get the root path as string
    resolve_root = function() {
      if(is.function(private$root)) {
        path = private$root()
        if(!rlang::is_character(path, 1L)) {
          rlang::warn("value returned by function set as `root` path is not a single character value")
          path = path[1]
        }
      } else {
        path = private$root
      }
      as.character(path)
    },

    #' @description
    #' Rebuilt current path from the path components
    #' If absolute mode is on, the full path will be returned, otherwise the path will be rebuild from components
    update=function() {
      if(private$absolute) {
        return(invisible(private$path))
      }
      # Create prefixes
      path = self$resolve_root()
      path = ending_slash(path)
      pp = c()
      if(length(private$prefixes) > 0) {
        for(n in names(private$prefixes)) {
          pp[[n]] = private$prefixes[[n]]
        }
      }
      if(length(pp) > 0) {
        path = paste0(path, paste0(pp, collapse='/'))
      }
      path = ending_slash(path)
      # Add suffix
      if(length(private$suffix) > 0) {
        path = paste0(path, private$suffix)
      }
      path = ending_slash(path)
      private$current_path = path
      invisible(private$current_path)
    },

    #' @description
    #' Define the current suffix component of the path
    #' @param path character
    set_suffix = function(path) {
      path = single_string(path)
      private$suffix = path
      self$update()
    },

    #' @description
    #' Get the suffix component of the path
    get_suffix = function() {
      self$suffix
    },

    #' @description
    #' Define the full path
    #'
    #' If path is not null, the full path is defined by the provided one, ignoring other paths components (root, prefixes, suffix)
    #' If provided path is null, then absolute mode is disabled and the path is rebuild from components
    #' @param path full path to used
    set_full_path = function(path) {
      if(is.null(path)) {
        private$absolute = FALSE
        self$update()
      } else {
        path = single_string(path)
        private$current_path = path
        private$absolute = TRUE
      }
    },

    #' @description
    #' Get a path inside the current path
    #' @param ... character arguments to concat as sub path
    path = function(...) {
      if(is.null(private$current_path)) {
        self$update()
      }
      p = private$current_path
      sep = ifelse(endsWith(p, "/"), "", "/")
      paste0(p, sep, ...)
    },

    #' @description
    #' Set the list of the prefixes
    #'
    #' Prefixes are named components. Each prefix entry is added when the path is created between the root and the suffix
    #' root / prefixes... / suffix
    #' This can be used to add subpath before suffix without changing the root (to create the same tree layout in different root's subpath for example)
    #' Prefixes are used in order of the list
    #' @param prefixes list()
    set_prefixes = function(prefixes) {
      if(!is.list(prefixes)) {
        rlang::abort("prefixes must be a list")
      }
      private$prefixes = prefixes
      self$update()
    },

    #' @description
    #' Set a prefix with a given name
    #' @param name character name of the prefix
    #' @param value value to use for the named prefix
    set_prefix = function(name, value) {
      private$prefixes[[name]] = value
      self$update()
    },

    #' @description
    #' Get prefixes
    get_prefixes = function() {
      private$prefixes
    },

    #' @description
    #' Is the current path using absolute mode
    #' If absolute mode is set, the path is set directly as a full path, and other path components are not used
    is_absolute = function() {
      private$absolute
    },

    #' @description
    #' Export components as a static list
    components = function() {
      r = list(
        root   = private$root,
        suffix = private$suffix,
        prefixes = private$prefixes,
        path    = private$current_path,
        absolute = private$absolute
      )
      class(r) <- "path_components"
      r
    }
  )
)

option_out_path = function() {
  getOption(OPTION_OUTPATH, getwd())
}

#' Global out path
#' @noRd
.out_path = PathBuilder$new(option_out_path)

# Register the common out path in the paths list
.State$paths$out_path = .out_path

#' Access the global out path instance
#' @export
global_out_path <- function() {
  .out_path
}

#' Define the global base output path
#'
#' This function should be called before any use of \code{\link{init_path}()} or \code{\link{my_path}()}
#' It only defines the global output path. It's intented to be defined on startup and not changed during the script execution.
#' If it's has to be changed, then \code{\link{init_path}()} should be called after to initialize the current output path.
#'
#' @param root path where the output path should be defined
#' @family path-functions
#' @export
set_root_out_path <- function(root) {
  args = list()
  args[[OPTION_OUTPATH]] = root
  do.call(options, args)
  .out_path$update()
}

#' Get the global base output path
#
#' @family path-functions
#' @export
get_root_out_path <- function() {
  .out_path$get_root()
}

#' Define subpath (suffix) of global out path, usable by \code{\link{my_path}()}
#'
#' \code{init_path()} and \code{\link{my_path}()} are dedicated to manage path to files used by scripts to make them independent from the
#' actual physical location of the files, which depends on where (on which machine, account) the script is running. This path is called `global out path`
#' (where all output should be placed).
#'
#' By default the path is added as a suffix after the root path and the other components (if any),
#' unless the parameter full.path is TRUE. If TRUE the passed path is used as the full output path (the output path is switched in absolute path mode).
#' @param p character path
#' @param full.path logical if TRUE p is considered as an absolute path, replace all the current path
#' @param create logical, if TRUE create the subpath if not exists
#' @family path-functions
#' @export
init_path <- function(p, full.path=FALSE, create=TRUE) {
  if(full.path || is.null(p)) {
    .out_path$set_full_path(p)
  } else {
    .out_path$set_suffix(p)
  }
  update_out_path()
}

#' @noRd
update_out_path = function(create=TRUE) {
  path = .out_path$update()
  if( create && !file.exists(path) ) {
    dir.create(path, recursive=T)
  }
  invisible(path)
}

#' Register a path prefix for the global out path
#'
#' Each path prefix will be added to the root path separated by '/' to create a full path before the suffix.
#'
#' Prefix mechanism allows to define constant path at several levels.
#' For example :
#' output path for global out path
#' output path for a project (that will complete base.out.path)
#' output path in a script of the project
#'
#' @examples
#' \dontrun{
#' set_root_out_path('/my/path') # root of the out path is /my/path
#' add_path_prefix('project', 'my_project')
#' init_path('output') # Add output to the current path as suffix
#' }
#' my_path() # => '/my/path/my_project/output'
#' @export
#'
#' @family path-functions
#'
#' @param name name of the prefix
#' @param prefix path to add to the prefix
add_out_path_prefix = function(name, prefix) {
  .out_path$set_prefix(name, prefix)
  if(.out_path$is_absolute()) {
    rlang::warn("Current out path is using absolute path, wont override it.")
  }
  update_out_path()
}

#' Generate a path with path components without updating the builder
#'
#' This function build a path but do not change the current path components of the session
#'
#' @param base character, base output path, use .builder will be used if NULL
#' @param prefixes list() replace some prefixes, only works if prefixes is already defined by \code{\link{add_out_path_prefix}()}
#' @param suffix character suffix to use, if NULL use default
#' @param .builder builder to use for default components values, if NULL use global out path builder
#' @family path-functions
#' @export
create_path = function(base=NULL, prefixes=list(), suffix=NULL, .builder=NULL) {
  builder = .builder
  if(is.null(base)) {
    if(is.null(.builder)) {
      builder = .out_path$clone()
    }
  } else {
    builder = PathBuilder$new(base)
  }
  # Create prefixes
  pp = builder$get_prefixes()
  if(length(pp) > 0) {
    for(n in names(pp)) {
      if(hasName(prefixes, n)) {
        builder$set_prefix(n, prefixes[[n]])
      }
    }
  }
  if(!is.null(suffix)) {
    builder$set_suffix(suffix)
  }
  builder$update()
}

#' Print path components
#'
#' Print the path components returns by the components method of a path builder
#'
#' @family path-functions
#' @param x paths_definitions object
#' @param ... extra params (print interface)
#' @exportS3Method
print.path_components = function(x, ...) {
  cat("Registred paths\n")
  cat(" - root = ")
  if(is.function(x$root)) {
    cat(" (function) ",sQuote(x$root()))
  } else {
    cat(sQuote(x$root))
  }
  cat("\n")
  r = 'root'
  if( length(x$prefixes) > 0) {
    Map(function(name, p) {
      cat(" -", name, "=", sQuote(p),"\n")
    }, names(x$prefixes), x$prefixes)
    r = c(r, names(x$prefixes))
  }
  if(!is.null(x$suffix)) {
    cat(" - suffix = ", sQuote(x$suffix), " (last value passed to init_path())\n")
    r = c(r, 'suffix')
  }
  if(x$absolute) {
    cat("(!) Full path has been used at last init.path() call, paths config is ignored\n")
  } else {
    cat("Resolved by : ", paste(paste0("[",r,"]"), collapse=' / '), "\n"  )
  }
  cat("Current : ", sQuote(x$path),"\n")
  cat("\n")
}

#' Return the path of a file in the global out path
#'
#' my_path is the common function to create path inside the global out path.
#'
#' @examples
#' \dontrun{
#'   set_root_out_path("/my/path")
#'   init_path("foo") # Suffix is foo, current output path is /my/path/foo
#'   my_path("bar") # get "bar" inside the current out path -> /my/path/foo/bar
#' }
#' @family path-functions
#' @param ... characters string to used (will be concatenated with no space)
#' @export
my_path <- function(...) {
 .out_path$path(...)
}

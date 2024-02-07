# Path functions are helpers
# To standardize R projects regardless of installation

#' Define the global base output path
#'
#' This function should be called before any use of \code{\link{init_path}()} or \code{\link{my_path}()}
#' It only defines the global output path. It's intented to be defined on startup and not changed during the script execution.
#' If it's has to be changed, then \code{\link{init_path}()} should be called after to initialize the current output path.
#'
#' @param path path where the output path should be defined
#' @family path-functions
#' @export
set_base_out_path <- function(path) {
  workspace_options("base.out.path"=path)
}

#' Get the global base output path
#
#' @family path-functions
get_base_out_path <- function() {
  get_option("base.out.path")
}

#' Define an path for files, usable by \code{\link{my_path}()}
#'
#' \code{init_path()} and \code{\link{my_path}()} are dedicated to manage path to files used by scripts to make them independant from the
#' actual physical location of the files, which depends on where (on which machine, account) the script is running.
#'
#' by default, the path is added to the global output path (see \code{\link{set_base_out_path}} ),
#' unless the parameter full.path is TRUE
#' @param p chr path
#' @param full.path logical if TRUE p is considered as an absolute path, replace all the current path
#' @family path-functions
#' @export
init_path <- function(p, full.path=F) {
  if(isTRUE(full.path)) {
    path = p
    attr(path, "full") <- TRUE
    workspace_options(path.suffix = NULL)
  } else {
    # get output path
    workspace_options(path.suffix = p)
    path = NULL
  }
  update_out_path(path)
  return(path)
}

#' @noRd
update_out_path = function(path=NULL) {
  if(is.null(path)) {
    path = create_path()
  }
  workspace_options(
    out.path=path, # update current output path
    out.path.sep= ifelse( any(grep("/$", path) == 1) , "", "/")# check for directory separator
  )
  if( !file.exists(path) ) {
    dir.create(path, recursive=T)
  }
  return(path)
}

#' Test if the current output path is defined using an absolute path or has been created using internal paths segments
is_out_full_path = function() {
  o = get_option("out.path")
  isTRUE(attr(o, "full"))
}

#' Register a path prefix
#'
#' Each path prefix will be added to `base.out.path` separated by '/' to create a full path for output
#'
#' Prefix mechanism allows to define constant path at several levels.
#' For example :
#' output path for global workspace (base.out.path)
#' output path for a project (that will complete base.out.path)
#' output path in a script of the project
#'
#' @examples
#' # base.out.path = '/my/path/'
#' add_path_prefix('project', 'my_project') # A project prefix to the path
#' \dontrun{
#' init_path('output') # Add output to the current path
#' }
#' my_path() # => '/my/path/my_project/output'
#' @export
#'
#' @family path-functions
#'
#' @param name name of the prefix
#' @param prefix path to add to the prefix
add_path_prefix = function(name, prefix) {
  p = get_option("path.prefix", default=list())
  p[[name]] <- prefix
  workspace_options(path.prefix=p)
  if(is_out_full_path()) {
    rlang::warn("Current path has been defind by full path, wont override it.")
  } else {
    update_out_path()
  }
}

#' Generate a path with path components.
#'
#' This function build a path but do not change the current path components of the session
#'
#' @param base chr base output path, use session default if NULL
#' @param prefixes list() replace some prefixes, only works if prefixes is already defined by \code{\link{add_path_prefix}()}
#' @param suffix chr suffix to use, if NULL use default
#' @family path-functions
#' @export
create_path = function(base=NULL, prefixes=list(), suffix=NULL) {
  if(is.null(base)) {
    path = get_base_out_path()
  } else {
    path = base
  }
  # Create prefixes
  pp = get_option("path.prefix", default=list())
  if(length(pp) > 0) {
    for(n in names(pp)) {
      if(hasName(prefixes, n)) {
        pp[[n]] = prefixes[[n]]
      }
    }
  }

  if(length(pp) > 0) {
    path = paste0(path, paste0(pp, collapse='/'))
  }
  path = ending_slash(path)
  ps = get_option("path.suffix", default=NULL)
  if(!is.null(suffix)) {
    ps = suffix
  }
  if(length(ps) > 0) {
    path = paste0(path, ps)
  }
  path = ending_slash(path)
  path
}

#' Get the current paths defined by \code{\link{init_path}()} or \code{\link{add_path_prefix}()}
#' @family path-functions
#' @export
get_current_paths = function() {
  paths = list(
    base = get_base_out_path(),
    prefixes = get_option("path.prefix"),
    suffix = get_option("path.suffix", default=NULL),
    resolved = my_path()
  )
  structure(paths, class="paths_definition")
}

#' Print path definition
#'
#' Print the path definitions return by \code{\link{get_current_paths}}
#'
#' @family path-functions
#' @param x paths_definitions object
#' @param ... extra params (print interface)
#' @exportS3Method
print.paths_definition = function(x, ...) {
  cat("Registred paths\n")
  cat(" - base = ", x$base ,"\n")
  r = 'base'
  if( length(x$prefixes) > 0) {
    Map(function(name, p) {
      cat(" -", name, "=", p,"\n")
    }, names(x$prefixes), x$prefixes)
    r = c(r, names(x$prefixes))
  }
  suffix = get_option("path.suffix", default=NULL)
  if(!is.null(suffix)) {
    cat(" - suffix = ", suffix, " (last value passed to init_path())\n")
    r = c(r, 'suffix')
  }
  if(is_out_full_path()) {
    cat("(!) Full path has been used at last init.path() call, paths config is ignored\n")
  } else {
    cat("Resolved by : ", paste(paste0("[",r,"]"), collapse=' / '), "\n"  )
  }
  cat("Current : ", x$resolved,"\n")
  cat("\n")
}

#' Return the path of a file in the current ouput path
#' @family path-functions
#' @param ... characters string to used (will be concatenated with no space)
#' @export
my_path <- function(...) {
  out.path = get_option("out.path")
  sep = get_option("out.path.sep")
  paste0(out.path, sep, ...)
}

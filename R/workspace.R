#' Define state of the package
#' @param ... named list of values to set in the state
#' @returns environment the current state
#' @export
workspace_state = function(...) {
  opts = list(...)
  for(n in names(opts)) {
    .State[[n]] = opts[[n]]
  }
  invisible(.State)
}


#' Find workspace root
#'
#' The root of the workspace is done by finding location of the .Rworkspace file
#' This function can be called in subdirectories of a project to find the workspace root and be able to load
#' The workspace configuration.
#' @param max.depth maximum number of upper directory to scan. Default is reasonable but it can be changed using option workspace.maxdepth
#' @export
find_workspace = function(max.depth=NULL) {

  dir = get_state("workspace", default=NULL)
  if(!is.null(dir)) {
    return(dir)
  }

  # Try to find the workspace marker file

  if(is.null(max.depth)) {
    max.depth = base::getOption(OPTION_MAXDEPTH, NULL)
  }

  if(is.null(max.depth)) {
    max.depth = 100L
  }

  max.depth = as.integer(max.depth)
  if(!is.integer(max.depth)) {
    rlang::abort(paste("max.depth must be an integer given", sQuote(max.depth)))
  }

  mark.file = WORKSPACE_FILE
  depth = 0
  dir = getwd()
  found = FALSE
  while(!found && depth < max.depth) {
    found = file.exists(file.path(dir, mark.file))
    if(!found) {
      dir = normalizePath(file.path(dir, ".."))
      depth = depth + 1
    }
  }
  if(found) {
    workspace_state("workspace"=dir)
    return(dir)
  }
  rlang::abort(paste0("Unable to find workspace after scanning directory up from ", sQuote(getwd())," to ", sQuote(dir), "no file named ", sQuote(mark.file)," found"))
}

#' Launch the workspace
#'
#' Find the workspace location and load files listed in .Rworkspace in the passed environment
#' @param envir Environment to load the bootstrap files into, by default the caller env
#' @export
launch <- function(envir=rlang::caller_env()) {
  booted = is_workspace_booted()
  verbose = base::getOption(OPTION_VERBOSE, default=FALSE)
  if(booted) {
    if(verbose) {
      rlang::inform(paste("Workspace already booted"), class="workspace_msg")
    }
    return(invisible(NULL))
  }
  # Avoid reentry if load_workspace() is called at several levels
  workspace_state(ws.booted=TRUE)
  workspace = find_workspace()
  ws_file = file.path(workspace, WORKSPACE_FILE)
  if(verbose) {
    rlang::inform(paste("Workspace found in ", sQuote(workspace)), class="workspace_msg")
  }
  bootstraps = readLines(ws_file, warn=FALSE)
  for(file in bootstraps) {
    if(grepl("^#", file )) {
      next()
    }
    f = trimws(file)
    if(nchar(f) == 0) {
      next()
    }
    p = file.path(workspace, f)
    if(!file.exists(p)) {
      rlang::abort(paste0("File listed in ", ws_file, " does not exists", sQuote(file), " from ", workspace))
    }
    if(verbose) {
      rlang::inform(paste("loading workspace file ", sQuote(p)), class="workspace_msg")
    }
    source(p, local=envir)
  }
}

#' Get the booted state of the workspace
#' @description
#' This function returns TRUE when workspace::launch() is called, but before the bootstrap files are loaded.
#' Do not use this function inside bootstrap files, because it will be always TRUE
#' @export
is_workspace_booted = function() {
  get_state("ws.booted", default=FALSE)
}

#' Initialize a workspace
#'
#' Create the root file .Rworkspace with list of file to load on startup
#'
#' @param path character vector, path where to init the workspace (if NULL (default), will use current directory)
#' @param bootstraps character vector list of file to be loaded when workspace is loaded, by default add a workpace.R file. (path must be relative to `path` argument)
#' @export
init_workspace <- function(path=NULL, bootstraps=c('workspace.R')) {
  if(is.null(path)) {
    path = getwd()
  }
  mark.file = file.path(path, WORKSPACE_FILE)
  writeLines(bootstraps, mark.file)
}



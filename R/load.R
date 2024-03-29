# Loading workspace

#' Load Workspace bootstrap files
#'
#' Find the workspace location and load files listed in .Rworkspace in the passed environment
#' @param envir Environment to load the bootstrap files into, by default the caller env
#' @export
load_workspace <- function(envir=rlang::caller_env()) {
  booted = workspace_booted()
  verbose = base::getOption(OPTION_VERBOSE, default=FALSE)
  if(booted) {
    if(verbose) {
      rlang::inform(paste("Workspace already booted"), class="workspace_msg")
    }
    return(invisible(NULL))
  }
  # Avoid reentry if load_workspace() is called at several levels
  workspace_options(ws.booted=TRUE)
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
      rlang::abort(paste0("File listed in ",ws_file, " does not exists", sQuote(file), " from ", workspace))
    }
    if(verbose) {
      rlang::inform(paste("loading workspace file ", sQuote(p)), class="workspace_msg")
    }
    source(p, local=envir)
  }
}

#' Get the booted state of the workspace
#' @export
workspace_booted = function() {
  get_option("ws.booted", default=FALSE)
}

find_R_file <- function(path) {
  for(ext in c('.R','.r')) {
    p = paste0(path, ext)
    if(file.exists(p)) {
      return(p)
    }
  }
  NULL
}

#' Load a R file by search for .R and .r version, the first found is loaded (if .R exists, the .r version is ignored)
#' @param path file path (without extension) to find
#' @param must.exists if TRUE, raise an error if the file is not find with .R or .r extension
#' @param envir environment where to load the file, by default the caller environment
#' @export
load_R_file = function(path, must.exists=FALSE, envir=rlang::caller_env()) {
  file = find_R_file(path)
  if(is.null(file) && must.exists) {
    rlang::abort(paste0("File ", file, ".[R|r] not found (with .R or .r extension)"))
  }
  source(file, local=envir)
}

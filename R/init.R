
#' Initialize a workspace
#'
#' Create the root file .Rworkspace with list of file to load on startup
#'
#' @param path character vector, path where to init the workspace (if NULL (default), will use current directory)
#' @param bootstraps character vector list of file to be loaded when workspace is loaded, by default add a workpace.R file. (path must be relative to `path` argument)
init_workspace <- function(path=NULL, bootstraps=c('workspace.R')) {
  if(is.null(path)) {
    path = getwd()
  }
  mark.file = file.path(path, WORKSPACE_FILE)
  writeLines(bootstraps, mark.file)
}

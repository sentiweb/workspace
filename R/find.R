
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

  max.depth = as.integer(max.depth)
  if(!is.integer(max.depth) || is.null(max.depth) || is.na(max.depth)) {
    max.depth = 100
  }

  mark.file = ".Rworkspace"
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
  rlang::abort("Unable to find workspace")
}


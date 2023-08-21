
#' Find workspace root
#'
#' The root of the workspace is done by finding location of the .Rworkspace file
#' This function can be called in subdirectories of a project to find the workspace root and be able to load
#' The workspace configuration.
#' @param max.depth maximum number of upper directory to scan. Default is reasonable but it can be changed.
#' @export
find_workspace = function(max.depth=20) {
  dir = get0("workspace", envir = .Share, ifnotfound = NULL)
  if(!is.null(dir)) {
    return(dir)
  }
  mark.file=".Rworkspace"
  depth = 0
  dir = getwd()
  found = FALSE
  while(!found && depth < max.depth) {
    found = file.exists(file.path(dir, mark.file))
    if(!found) {
      dir = normalizePath(file.path(dir,".."))
      depth = depth + 1
    }
  }
  if(found) {
    .Share[["workspace"]] = dir
    return(dir)
  }
  rlang::abort("Unable to find workspace")
}


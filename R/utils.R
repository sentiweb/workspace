
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

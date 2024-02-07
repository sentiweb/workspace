#' Get the workspace state map
#' @return fastmap object
#' @export
workspace_state = function() {
  .State
}

#' Define state of the package
#' @param ... list of named argument with options to defined
#'
#' @details
#' Accepted options
#' \describe{
#'  \itemize{base.out.path}{}
#' }
#' @export
workspace_options = function(...) {
  opts = list(...)
  for(n in names(opts)) {
    .State$set(n, opts[[n]])
  }
}

#' @noRd
get_option = function(name, default=NULL) {
  .State$get(name, missing=default)
}

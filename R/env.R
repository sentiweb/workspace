#' Define state of the package
#' @param ... list of named argument with options to defined
#'
#' @details
#' Accepted options
#' \describe{
#'  \itemize{base.out.path}{}
#' }
#'
#' @returns environment
#' @export
#'
workspace_state = function(...) {
  opts = list(...)
  for(n in names(opts)) {
    .State$set(n, opts[[n]])
  }
  invisible(.State)
}

#' Helper to get a given element in the state
#' @noRd
get_state = function(name, default=NULL) {
  get0(name, envir = .State, ifnotfound = default)
}

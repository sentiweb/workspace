#' Get the workspace environment
#' @export
workspace_env = function() {
  .Share
}

#' Define options for the package
#' @param ... list of named argument with options to defined
#'
#' @details
#' Accepted options
#' \describe{
#'  \itemize{base.out.path}{}
#' }
#' @export
workspace_options = function(...) {
  known = c('base.out.path')

  opts = list(...)
  for(n in names(opts)) {
    if(!n %in% known) {
      rlang::abort("")
    }
    .Share[[n]] = opts[[n]]
  }
}

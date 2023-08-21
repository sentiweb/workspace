
#' Ensure some paths ends with an ending slash
#' @param x path to check for ending slash
ending_slash <- function (x)
{
  paste0(x, ifelse(grepl("/$", x), "", "/"))
}

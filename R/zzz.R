# Default behaviour when attaching workspace (using library(workspace))
.onAttach <- function(libname, pkgname) {
  if(pkgname == "workspace") {
    autoload = base::getOption(OPTION_AUTOLOAD, default=FALSE)
    envir = base::getOption(OPTION_ENV, default=.GlobalEnv)
    if(is.logical(autoload)) {
      if( isTRUE(autoload) ) {
        launch(envir=envir)
      }
    } else {
      rlang::warn(paste("option ", sQuote(OPTION_AUTOLOAD)," must be logical, value ignored"))
    }
  }
}


.onLoad <- function(libname, pkgname) {
  # Get environment to store configurations
  # If not defined create a new empty environment
  if(pkgname == "workspace") {
    out.path = base::getOption(OPTION_OUTPATH, default = NULL)
    if(!is.null(out.path)) {
      set_root_out_path(out.path)
    }
  }
}

# Default behaviour when attaching workspace (using library(workspace)) is to load the current workspace.
.onAttach <- function(libname, pkgname) {
  if(pkgname == "workspace") {
    autoload = base::getOption(OPTION_AUTOLOAD, default=FALSE)
    envir = base::getOption(OPTION_ENV, default=.GlobalEnv)
    if(is.logical(autoload)) {
      if( isTRUE(autoload) ) {
        load_workspace(envir=envir)
      }
    } else {
      rlang::warning(paste("option ", sQuote(OPTION_AUTOLOAD)," must be logical, value ignored"))
    }
  }
}

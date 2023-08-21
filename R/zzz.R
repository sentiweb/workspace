
.onLoad <- function(libname, pkgname) {
  # Default is running directory
  options("pkg_workspace_env"=.Share)
}

# Default behaviour when attaching workspace (using library(workspace)) is to load the current workspace.
.onAttach <- function(libname, pkgname) {
  autoload = options("pkg_workspace_autoload")$`pkg_workspace_autoload`
  if(is.null(autoload)) {
    autoload = FALSE
  } else {
    if(!is.logical(autoload)) {
      rlang::abort("pkg_workspace_autoload option must be logical")
    }
  }

  if(autoload) {
    load_workspace(envir=.GlobalEnv)
  }
}

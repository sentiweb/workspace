#' Workspace Package
#'
#' This package provides a set of functions to manage a group of R scripts sharing a common configuration.
#'
#' The workspace is a directory, each project lives in a subdirectory. What we call project is just a set of R scripts sharing a common purpose/target, or whatever you
#' consider relevant to put scripts in the same directory. A workspace regroup several projects, it's up to you to decide why (this package enable the sharing of common config but do not force to use it).
#'
#' Idea behind workspace is to be able to run scripts on several environments/machines/locations without any code change (except in config)
#' This is achieved using several simple rules:
#' \itemize{
#' \item{Using only relative path in the workspace. The scripts in the workspace must NOT use absolute path (they dont know where they are running)}
#' \item{Real path of things outside the workspace are provided using configuration variable in the workspace bootstrap files}
#' \item{All scripts in a workspace can share a common configuration}
#' \item{Scripts in the workspace are run in their own directory. A sub-directory only knows about the upper directory}
#' }
#'
#' Configuration o R script can be machine-wide and user-wire (using .Rprofile) but the missing part is for a group of projects
#' (and the same group of project can exists several times with different configuration in the same user-space)
#' This can be achieved by using workspace.
#'
#' A workspace is just a directory layout to group some projects (in subdirectories). The set of functions are not called automatically.
#' To be identified as the workspace root directory it MUST contains a file `.Rworkspace`.
#'
#' The file `.Rworkspace` is not working like `.Rprofile` and do not contains R code but can contain the list of files to load
#' when \code{\link{launch}()} is called (file path are relative to the root, i.e. where `.Rworkspace` lives).
#'
#' To share a configuration, you can define one or several bootstrap files to be loaded by \code{\link{launch}()} in the `.Rworkspace` file.
#'
#' Example (the following is an example of our settings for many projects, to describe how we use this package):
#'
#' In our projects we defined a `.Rworkspace` with the following content (one file by line):
#' ---
#' location.R
#' workspace.R
#' ---
#'
#' The `location.R` is ignored by version control and contains the installation specific for the project (machine-specific and real paths)
#' The `workspace.R` is under version control and contains the config share by all the projects in the workspace and machine/installation independent
#'
#' In our settings all path in our projects are relative to the workspace, external path (outside the workspace dir) are
#' provided by variables in location.R. With this settings, the scripts in workspace can run everywhere without changing the code.
#'
#' This is a convention (the workspace package does not provide list of bootstrap files you can define yours as you want, or none)
#'
#' In each project (in workspace' subdirectory)
#' We can call `workspace::launch()`
#'
#' To simplify, each project contains a `conf.R` which contains the subdirectory's scripts common configuration/functions.
#'
#' A typical `conf.R` is just:
#' ---
#'  `workspace::launch()`
#' ---
#'
#' Then the other script in the subdirectory just has `source('conf.R')` as first line to load the commons.
#' We use relative path only, so each script is run with its own directory as working directory.
#'
#' @section Options:
#'
#' Several options can be defined in options()
#'
#' \describe{
#' \item{workspace.verbose}{Show verbose message during workspace loading}
#' \item{workspace.outpath}{Define base output path (call \code{\link{set_root_out_path}()})}
#' \item{workspace.autoload}{Autoload workspace when library is loaded}
#' \item{workspace.env}{Environment where to load workspace bootstap files when using autoload, default is globalenv}
#' \item{workspace.maxdepth}{Max depth to use to find the workspace accross upper directory of getwd(), default is 100}
#' }
#'
#'
#' @importFrom rlang abort
#' @importFrom R6 R6Class
#' @importFrom utils hasName
"_PACKAGE"

WORKSPACE_FILE='.Rworkspace'

#'
#' Store the current state of the workspace
#'
#' @noRd
.State = rlang::new_environment(list(paths=list()))

#' @noRd
OPTION_VERBOSE = "workspace.verbose"

#' @noRd
OPTION_OUTPATH = "workspace.outpath" # Default Out path

#' @noRd
OPTION_AUTOLOAD = "workspace.autoload" # Autoload workspace when package is attached using library()

#' @noRd
OPTION_ENV = "workspace.env" # env Where to load workspace files when using autoload.

#' @noRd
OPTION_MAXDEPTH = "workspace.maxdepth" # Maximum depth to look up to find a workspace

#' Helper to get a given element in the state
#' @noRd
get_state = function(name, default=NULL) {
  get0(name, envir = .State, ifnotfound = default)
}

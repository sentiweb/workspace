% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/workspace.R
\name{launch}
\alias{launch}
\title{Launch the workspace}
\usage{
launch(envir = rlang::caller_env())
}
\arguments{
\item{envir}{Environment to load the bootstrap files into, by default the caller env}
}
\description{
Find the workspace location and load files listed in .Rworkspace in the passed environment
}

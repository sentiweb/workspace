% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/path.R
\name{create_path}
\alias{create_path}
\title{Generate a path with path components.}
\usage{
create_path(base = NULL, prefixes = list(), suffix = NULL)
}
\arguments{
\item{base}{chr base output path, use session default if NULL}

\item{prefixes}{list() replace some prefixes, only works if prefixes is already defined by \code{\link{add_path_prefix}()}}

\item{suffix}{chr suffix to use, if NULL use default}
}
\description{
This function build a path but do not change the current path components of the session
}
\seealso{
Other path-functions: 
\code{\link{add_path_prefix}()},
\code{\link{get_base_out_path}()},
\code{\link{get_current_paths}()},
\code{\link{init_path}()},
\code{\link{my_path}()},
\code{\link{print.paths_definition}()},
\code{\link{set_base_out_path}()}
}
\concept{path-functions}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/path.R
\name{init_path}
\alias{init_path}
\title{Define subpath (suffix) of global out path, usable by \code{\link{my_path}()}}
\usage{
init_path(p, full.path = FALSE, create = TRUE)
}
\arguments{
\item{p}{character path}

\item{full.path}{logical if TRUE p is considered as an absolute path, replace all the current path}

\item{create}{logical, if TRUE create the subpath if not exists}
}
\description{
\code{init_path()} and \code{\link{my_path}()} are dedicated to manage path to files used by scripts to make them independent from the
actual physical location of the files, which depends on where (on which machine, account) the script is running.
}
\details{
By default the path is added as a suffix to the global output path (see \code{\link{set_root_out_path}} ),
unless the parameter full.path is TRUE
}
\seealso{
Other path-functions: 
\code{\link{add_out_path_prefix}()},
\code{\link{create_path}()},
\code{\link{get_root_out_path}()},
\code{\link{my_path}()},
\code{\link{print.path_components}()},
\code{\link{set_root_out_path}()}
}
\concept{path-functions}

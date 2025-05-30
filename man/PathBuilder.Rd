% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/path.R
\name{PathBuilder}
\alias{PathBuilder}
\title{Path Builder allow to build path from components
A root path, optional prefixes and a suffix (path inside the root)
It manages the path creation for the global out path
Path can be created from several components with the general form
root / [prefixes] / suffix
prefixes are optional
The Builder can also use an absolute mode, using directly a full path, in this mode the components are not used}
\description{
Path Builder allow to build path from components
A root path, optional prefixes and a suffix (path inside the root)
It manages the path creation for the global out path
Path can be created from several components with the general form
root / [prefixes] / suffix
prefixes are optional
The Builder can also use an absolute mode, using directly a full path, in this mode the components are not used

Path Builder allow to build path from components
A root path, optional prefixes and a suffix (path inside the root)
It manages the path creation for the global out path
Path can be created from several components with the general form
root / [prefixes] / suffix
prefixes are optional
The Builder can also use an absolute mode, using directly a full path, in this mode the components are not used
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-PathBuilder-new}{\code{PathBuilder$new()}}
\item \href{#method-PathBuilder-set_root}{\code{PathBuilder$set_root()}}
\item \href{#method-PathBuilder-get_root}{\code{PathBuilder$get_root()}}
\item \href{#method-PathBuilder-update}{\code{PathBuilder$update()}}
\item \href{#method-PathBuilder-set_suffix}{\code{PathBuilder$set_suffix()}}
\item \href{#method-PathBuilder-get_suffix}{\code{PathBuilder$get_suffix()}}
\item \href{#method-PathBuilder-set_full_path}{\code{PathBuilder$set_full_path()}}
\item \href{#method-PathBuilder-path}{\code{PathBuilder$path()}}
\item \href{#method-PathBuilder-set_prefixes}{\code{PathBuilder$set_prefixes()}}
\item \href{#method-PathBuilder-set_prefix}{\code{PathBuilder$set_prefix()}}
\item \href{#method-PathBuilder-get_prefixes}{\code{PathBuilder$get_prefixes()}}
\item \href{#method-PathBuilder-is_absolute}{\code{PathBuilder$is_absolute()}}
\item \href{#method-PathBuilder-components}{\code{PathBuilder$components()}}
\item \href{#method-PathBuilder-clone}{\code{PathBuilder$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-new"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-new}{}}}
\subsection{Method \code{new()}}{
Create the path builder instance for the given root path
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$new(root)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{root}}{character root path}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-set_root"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-set_root}{}}}
\subsection{Method \code{set_root()}}{
Set the root path of the builder
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$set_root(root)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{root}}{the root path to set}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-get_root"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-get_root}{}}}
\subsection{Method \code{get_root()}}{
Get the root pah
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$get_root()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-update"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-update}{}}}
\subsection{Method \code{update()}}{
Rebuilt current path from the path components
If absolute mode is on, the full path will be returned, otherwise the path will be rebuild from components
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$update()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-set_suffix"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-set_suffix}{}}}
\subsection{Method \code{set_suffix()}}{
Define the current suffix component of the path
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$set_suffix(path)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{path}}{character}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-get_suffix"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-get_suffix}{}}}
\subsection{Method \code{get_suffix()}}{
Get the suffix component of the path
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$get_suffix()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-set_full_path"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-set_full_path}{}}}
\subsection{Method \code{set_full_path()}}{
Define the full path

If path is not null, the full path is defined by the provided one, ignoring other paths components (root, prefixes, suffix)
If provided path is null, then absolute mode is disabled and the path is rebuild from components
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$set_full_path(path)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{path}}{full path to used}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-path"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-path}{}}}
\subsection{Method \code{path()}}{
Get a path inside the current path
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$path(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{character arguments to concat as sub path}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-set_prefixes"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-set_prefixes}{}}}
\subsection{Method \code{set_prefixes()}}{
Set the list of the prefixes

Prefixes are named components. Each prefix entry is added when the path is created between the root and the suffix
root / prefixes... / suffix
This can be used to add subpath before suffix without changing the root (to create the same tree layout in different root's subpath for example)
Prefixes are used in order of the list
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$set_prefixes(prefixes)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{prefixes}}{list()}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-set_prefix"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-set_prefix}{}}}
\subsection{Method \code{set_prefix()}}{
Set a prefix with a given name
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$set_prefix(name, value)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{name}}{character name of the prefix}

\item{\code{value}}{value to use for the named prefix}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-get_prefixes"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-get_prefixes}{}}}
\subsection{Method \code{get_prefixes()}}{
Get prefixes
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$get_prefixes()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-is_absolute"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-is_absolute}{}}}
\subsection{Method \code{is_absolute()}}{
Is the current path using absolute mode
If absolute mode is set, the path is set directly as a full path, and other path components are not used
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$is_absolute()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-components"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-components}{}}}
\subsection{Method \code{components()}}{
Export components as a static list
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$components()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-PathBuilder-clone"></a>}}
\if{latex}{\out{\hypertarget{method-PathBuilder-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PathBuilder$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}

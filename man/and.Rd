% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/falsy-package.r
\name{and}
\alias{\%&&\%}
\alias{and}
\title{Robust 'and' operator working with truthy and falsy values.}
\usage{
lhs \%&&\% rhs
}
\arguments{
\item{lhs}{Left hand side, always evaluated.}

\item{rhs}{Right hand side, evaluated only if \code{lhs}
evaluates to TRUTHY.}
}
\description{
Robust 'and' operator working with truthy and falsy values.
}
\examples{
## Shift to zero
v <- 5:10
v \%&&\% { v <- v - min(v) }
v

## It works if the vector is empty
v <- numeric()
v \%&&\% { v <- v - min(v) }
v
}


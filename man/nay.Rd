% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/falsy-package.r
\name{nay}
\alias{nay}
\title{Negate the falsyness of a value.}
\usage{
nay(rhs)
}
\arguments{
\item{rhs}{Value. If it is truthy, a falsy value (\code{FALSY}) is
returned, otherwise a truthy value (\code{TRUTHY}) is returned.}
}
\value{
Logical scalar.
}
\description{
Negate the falsyness of a value.
}
\examples{
nay(FALSY)
nay(TRUTHY)

## Check if directory is empty
tmp <- tempdir()
nay(dir(tmp, all.files = TRUE, no.. = TRUE)) \%||\% message("Not empty")

cat("Hello!", file = tempfile())
nay(dir(tmp, all.files = TRUE, no.. = TRUE)) \%||\% message("Not empty")
}


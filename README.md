


# falsy — warning: this package is experimental

[![Linux Build Status](https://travis-ci.org/gaborcsardi/falsy.png?branch=master)](https://travis-ci.org/gaborcsardi/falsy)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/cn0ooxtcame61mpu)](https://ci.appveyor.com/project/gaborcsardi/falsy)

falsy defines *falsy* and *truthy* values. You might be familiar with them
in other dynamic laguanges with prevalent implicit type conversions,
e.g Python, Ruby, JavaScript and Lisp.

These languages typically define a set of values that are considered as
*false* when used as a condition, and everything else is considered as
*true*. The falsy package does the same for R.

The following R values are considered to be *falsy*:
- `NULL`
- `FALSE`
- `0L`, the integer zero value.
- `0`, the real zero value.
- `0+0i`, the complex zero value.
- `""` empty string character scalar.
- `00` one byte raw vector with zero value.
- Empty vectors: `logical()`, `integer()`, `double()`, `complex()`,
  `character()` and `raw()`.
- Empty lists: `list()`.
- Objects from the `try-error` class.

Note that the value must be completely identical to one of the listed ones
to be falsy. E.g. an empty vector with an attribute is not falsy any more.

Everything else is truthy. In particular, everything with a class attribute
is truthy. So empty vectors are falsy, but empty matrices are truthy.

## Functions

The `is_falsy` and `is_truthy` functions simply decide if a value is falsy
or truthy.


```r
library(falsy)
is_falsy(0)
```

```
## [1] TRUE
```

```r
is_falsy(list())
```

```
## [1] TRUE
```

```r
is_falsy("")
```

```
## [1] TRUE
```

```r
is_truthy(0)
```

```
## [1] FALSE
```

```r
is_truthy("0")
```

```
## [1] TRUE
```

```r
is_truthy(matrix(nrow=0, ncol=0))
```

```
## [1] TRUE
```

## Robust short-circuited logical operators

It is common to use truthy and falsy values with the short-circuited
logical *and* and *or* operators, becuase the code will be short and
(usually) readable. E.g. one can check if a vector has elements or give an
error message:


```r
v <- 1:5
length(v) > 0 || stop("empty v")
```

```
## [1] TRUE
```

```r
v <- c()
length(v) > 0 || stop("empty v")
```

```
## Error: empty v
```

Unfortunately, the `||` and `&&` operators fail on values that cannot be
converted to a logical, using a (non-extendable) set of implicit conversion
rules. The falsy package privides the `%||%` and `%&&%` operators that are
essentially identical to `||` and `&&`, but work with `truthy` and `falsy`
values. This allows writing:


```r
v <- 1:5
v %||% stop("empty v")
```

```
## [1] 1 2 3 4 5
```

```r
v <- c()
v %||% stop("empty v")
```

```
## Error: empty v
```

and more importantly also 


```r
l <- list(a = 1, b = 2)
l$a %||% stop("no a in l")
```

```
## [1] 1
```

```r
l$c %||% stop("no c in l")
```

```
## Error: no c in l
```

This works, because for non-existing keys lists return `NULL`, which is
falsy.

The left or right hand sides of the `%||%` and `%&&%` operators can be
arbitrary R expessions. E.g. to shift a vector to zero, if it is not empty,
one can write


```r
v <- 5:10
v %&&% { v <- v - min(v) }
v
```

```
## [1] 0 1 2 3 4 5
```

```r
v <- numeric()
v %&&% { v <- v - min(v) }
```

```
## numeric(0)
```

which is somewhat simpler than writing


```r
if (length(v) > 0) v <- v - min(v)
```

## Errors and `try`

Errors returned by `try` are also falsy, which helps writing fallback
solutions.


```r
col <- try(colorspace::rainbow_hcl(5)) %||% rainbow(5)
col
```

```
## [1] "#FF0000FF" "#CCFF00FF" "#00FF66FF" "#0066FFFF" "#CC00FFFF"
```

You probably want to suppress the misleading error message, whith is
possible with `try_quietly`:


```r
col2 <- try_quietly(colorspace::rainbow_hcl(5)) %||% rainbow(5)
col2
```

```
## [1] "#FF0000FF" "#CCFF00FF" "#00FF66FF" "#0066FFFF" "#CC00FFFF"
```

## Negation

The `not` function returns a falsy value if its argument is truthy and
vice versa. The following code checks if a directory is empty:


```r
dir.create(tmp <- tempfile())
not(dir(tmp, all.files = TRUE, no.. = TRUE)) %||% message("Not empty")
```

```
## [1] TRUE
```

```r
cat("Hello!", file = file.path(tmp, "foo"))
not(dir(tmp, all.files = TRUE, no.. = TRUE)) %||% message("Not empty")
```

```
## Not empty
```

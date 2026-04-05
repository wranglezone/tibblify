# Overview of supported structures

``` r
library(tibblify)
```

The idea of
[`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md)
is to make it easier and more robust to convert lists of lists into
tibbles. This is a typical task after receiving API responses in JSON
format. The following provides an overview of which kinds of R objects
are supported and the JSON to which they correspond.

## Scalars

There are 4 basic types of scalars in JSON: boolean, integer, float,
string. In R there are not really scalars but only vectors of length 1.

``` json
true
1
1.5
"a"
```

``` r
TRUE
1
1.5
"a"
```

Other R vectors without JSON equivalent are also supported as long as
they:

- are a vector in the vctrs definition and
- have size one, i.e. `vctrs::vec_size(x)` is 1.

Examples are `Date` or `POSIXct`.

In general a scalar can be parsed with
[`tib_scalar()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).
There are some special functions for common types:

- [`tib_lgl()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
- [`tib_int()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
- [`tib_dbl()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
- [`tib_chr()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
- [`tib_date()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
- [`tib_chr_date()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  to parse dates encoded as string.

## Vectors

A homogeneous JSON array is an array of scalars where each scalar has
the same type. In R they correspond to a
[`logical()`](https://rdrr.io/r/base/logical.html),
[`integer()`](https://rdrr.io/r/base/integer.html),
[`double()`](https://rdrr.io/r/base/double.html) or
[`character()`](https://rdrr.io/r/base/character.html) vector.

``` json
[true, null, false]
[1, null, 3]
[1.5, null, 3.5]
["a", null, "c"]
```

``` r
c(TRUE, NA, FALSE)
c(1L, NA, 2L)
c(1.5, NA, 2.5)
c("a", NA, "c")
```

As with scalars, other vector types are also supported as long as they
are a vector in the vctrs definition.

They can be parsed with
[`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).
As with scalars, there are shortcuts for some common types,
e.g. [`tib_lgl_vec()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

### Empty lists

Empty lists [`list()`](https://rdrr.io/r/base/list.html) are a special
case. They might appear when parsing an empty JSON array.

``` r
x_json <- '[
  {"a": [1, 2]},
  {"a": []}
]'

x <- jsonlite::fromJSON(x_json, simplifyDataFrame = FALSE)
str(x)
#> List of 2
#>  $ :List of 1
#>   ..$ a: int [1:2] 1 2
#>  $ :List of 1
#>   ..$ a: list()
```

By default they are not supported but produce an error.

``` r
tibblify(x, tspec_df(tib_int_vec("a")))
#> Error in `tibblify()`:
#> ! Problem while tibblifying `x[[2]]$a`
#> Caused by error:
#> ! Can't convert `<list>` <list> to <integer>.
```

Use `vector_allows_empty_list = TRUE` in `tspec_*()` so that they are
converted to an empty vector instead.

``` r
tibblify(x, tspec_df(tib_int_vec("a"), .vector_allows_empty_list = TRUE))$a
#> <list_of<integer>[2]>
#> [[1]]
#> [1] 1 2
#> 
#> [[2]]
#> integer(0)
```

### Homogeneous R lists of scalars

When using `jsonlite::fromJSON(simplifyVector = FALSE)` to parse JSON to
an R object one does not get R vectors but homogeneous lists of scalars.

``` r
x_json <- '[
  {"a": [1, 2]},
  {"a": [1, 2, 3]}
]'

x <- jsonlite::fromJSON(x_json, simplifyVector = FALSE)
str(x)
#> List of 2
#>  $ :List of 1
#>   ..$ a:List of 2
#>   .. ..$ : int 1
#>   .. ..$ : int 2
#>  $ :List of 1
#>   ..$ a:List of 3
#>   .. ..$ : int 1
#>   .. ..$ : int 2
#>   .. ..$ : int 3
```

By default they cannot be parsed with
[`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

``` r
tibblify(x, tspec_df(tib_int_vec("a")))
#> Error in `tibblify()`:
#> ! Problem while tibblifying `x[[1]]$a`
#> Caused by error:
#> ! Can't convert `<list>` <list> to <integer>.
```

Use `.input_form = "scalar_list"` in
[`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
to parse them:

``` r
tibblify(x, tspec_df(tib_int_vec("a", .input_form = "scalar_list")))$a
#> <list_of<integer>[2]>
#> [[1]]
#> [1] 1 2
#> 
#> [[2]]
#> [1] 1 2 3
```

## Homogeneous JSON objects of scalars

Sometimes vectors are encoded as objects in JSON.

``` r
x_json <- '[
  {"a": {"x": 1, "y": 2}},
  {"a": {"a": 1, "b": 2, "b": 3}}
]'

x <- jsonlite::fromJSON(x_json, simplifyVector = FALSE)
str(x)
#> List of 2
#>  $ :List of 1
#>   ..$ a:List of 2
#>   .. ..$ x: int 1
#>   .. ..$ y: int 2
#>  $ :List of 1
#>   ..$ a:List of 3
#>   .. ..$ a: int 1
#>   .. ..$ b: int 2
#>   .. ..$ b: int 3
```

Use `.input_form = "object"` in
[`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
to parse them. To store the names use the `.names_to` and `.values_to`
arguments.

``` r
spec <- tspec_df(
  tib_int_vec(
    "a",
    .input_form = "object",
    .names_to = "name",
    .values_to = "value"
  )
)

tibblify(x, spec)$a[[1]]
#> # A tibble: 2 × 2
#>   name  value
#>   <chr> <int>
#> 1 x         1
#> 2 y         2
tibblify(x, spec)$a[[2]]
#> # A tibble: 3 × 2
#>   name  value
#>   <chr> <int>
#> 1 a         1
#> 2 b         2
#> 3 b         3
```

## Varying

JSON also has lists where elements do not have a common type, but
instead vary. For example:

``` json
[1, "a", true]
```

``` r
list(1, "a", TRUE)
```

Such lists can be parsed with
[`tib_variant()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

## Object

The R equivalent to a JSON object is a named list where the names
fulfill the requirements of
`vctrs::vec_as_names(repair = "check_unique")`.

``` json
{
  "a": 1,
  "b": true
}
```

``` r
x <- list(
  a = 1,
  b = TRUE
)
```

They can be parsed with
[`tib_row()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).
For example:

``` r
x <- list(
  list(row = list(a = 1, b = TRUE)),
  list(row = list(a = 2, b = FALSE))
)

spec <- tspec_df(
  tib_row(
    "row",
    tib_int("a"),
    tib_lgl("b")
  )
)

tibblify(x, spec)
#> # A tibble: 2 × 1
#>   row$a $b   
#>   <int> <lgl>
#> 1     1 TRUE 
#> 2     2 FALSE
```

## Data Frames

JSON can also store lists of objects.

``` json
[
  {"a": 1, "b": true},
  {"b": 2, "b": false}
]
```

``` r
x <- list(
  list(a = 1, b = TRUE),
  list(a = 2, b = FALSE)
)
```

They can be parsed with
[`tib_df()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

### Object of objects

JSON can also store named lists of objects. In JSON they are represented
as objects where each element is an object.

``` json
{
  "object1": {"a": 1, "b": true},
  "object2": {"b": 2, "b": false}
}
```

``` r
x <- list(
  object1 = list(a = 1, b = TRUE),
  object2 = list(a = 2, b = FALSE)
)
```

They are also parsed with
[`tib_df()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md),
but you can parse the names into an extra column via the `.names_to`
argument:

``` r
x_json <- '[
{
  "df": {
    "object1": {"a": 1, "b": true},
    "object2": {"a": 2, "b": false}
  }
}]'

x <- jsonlite::fromJSON(x_json, simplifyDataFrame = FALSE)

spec <- tspec_df(
  tib_df(
    "df",
    tib_int("a"),
    tib_lgl("b"),
    .names_to = "name"
  )
)

tibblify(x, spec)$df
#> <list_of<
#>   tbl_df<
#>     name: character
#>     a   : integer
#>     b   : logical
#>   >
#> >[1]>
#> [[1]]
#> # A tibble: 2 × 3
#>   name        a b    
#>   <chr>   <int> <lgl>
#> 1 object1     1 TRUE 
#> 2 object2     2 FALSE
```

### Column-major format

The column-major format is also supported.

``` json
{
  "a": [1, 2],
  "b": [true, false]
}
```

``` r
x <- list(
  a = c(1, 2),
  b = c(TRUE, FALSE)
)
```

Parse this using `.input_form = "colmajor"` in `tspec_*()`.

``` r
df_spec <- tspec_df(
  tib_int("a"),
  tib_lgl("b"),
  .input_form = "colmajor"
)

tibblify(x, df_spec)
#> # A tibble: 2 × 2
#>       a b    
#>   <int> <lgl>
#> 1     1 TRUE 
#> 2     2 FALSE
```

This is roughly equivalent to `tibble::as_tibble(x)`.

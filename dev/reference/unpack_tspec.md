# Unpack a tibblify specification

Unpack a tibblify specification

## Usage

``` r
unpack_tspec(
  spec,
  ...,
  fields = NULL,
  recurse = TRUE,
  names_sep = NULL,
  names_repair = c("unique", "universal", "check_unique", "unique_quiet",
    "universal_quiet"),
  names_clean = NULL
)

camel_case_to_snake_case(names)
```

## Arguments

- spec:

  A tibblify specification.

- ...:

  These dots are for future extensions and must be empty.

- fields:

  A string of the fields to unpack.

- recurse:

  Should unpack recursively?

- names_sep:

  If `NULL`, the default, the inner names of fields are used. If a
  string, the outer and inner names are pasted together, separated by
  `names_sep`.

- names_repair:

  Used to check that output data frame has valid names. Must be one of
  the following options:

  - `"unique"` or `"unique_quiet"`: (the default) make sure names are
    unique and not empty,

  - `"universal" or `"unique_quiet"\`: make the names unique and
    syntactic

  - `"check_unique"`: no name repair, but check they are unique,

  - a function: apply custom name repair.

  See
  [`vctrs::vec_as_names()`](https://vctrs.r-lib.org/reference/vec_as_names.html)
  for more information.

- names_clean:

  A function to clean names after repairing. For example use
  `camel_case_to_snake_case()`.

- names:

  Names to clean

## Value

A tibblify spec.

## Examples

``` r
spec <- tspec_df(
  tib_lgl("a"),
  tib_row("x", tib_int("b"), tib_chr("c")),
  tib_row("y", tib_row("z", tib_chr("d")))
)

unpack_tspec(spec)
#> tspec_df(
#>   tib_lgl("a"),
#>   b = tib_int(c("x", "b")),
#>   c = tib_chr(c("x", "c")),
#>   d = tib_chr(c("y", "z", "d")),
#> )
# only unpack `x`
unpack_tspec(spec, fields = "x")
#> tspec_df(
#>   tib_lgl("a"),
#>   b = tib_int(c("x", "b")),
#>   c = tib_chr(c("x", "c")),
#>   tib_row(
#>     "y",
#>     tib_row(
#>       "z",
#>       tib_chr("d"),
#>     ),
#>   ),
#> )
# do not unpack the fields in `y`
unpack_tspec(spec, recurse = FALSE)
#> tspec_df(
#>   tib_lgl("a"),
#>   b = tib_int(c("x", "b")),
#>   c = tib_chr(c("x", "c")),
#>   z = tib_row(
#>     c("y", "z"),
#>     tib_chr("d"),
#>   ),
#> )
```

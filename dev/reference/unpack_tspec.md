# Unpack a tibblify specification

`tidyr::unpack()` makes data wider by expanding df-columns into
individual columns. Analogously, unpacking a tibblify specification
makes a specification which will result in a wider tibble by expanding
[`tib_row()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
specifications into their individual fields.

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

camel_case_to_snake_case(x)
```

## Arguments

- spec:

  (`tspec`) A tibblify specification.

- ...:

  These dots are for future extensions and must be empty.

- fields:

  (`character` or `NULL`) The fields to unpack. If `fields` is `NULL`
  (default), all fields are unpacked.

- recurse:

  (`logical(1)`) Should fields inside other fields be unpacked?

- names_sep:

  (`character(1)` or `NULL`) If `NULL`, the default, the inner names of
  fields are used. If a string, the outer and inner names are pasted
  together, separated by `names_sep`.

- names_repair:

  (`character(1)` or `function`) Passed to the `repair` argument of
  [`vctrs::vec_as_names()`](https://vctrs.r-lib.org/reference/vec_as_names.html)
  to check that the output data frame has valid names. Must be one of
  the following options:

  - `"unique"` (the default) or `"unique_quiet"`: make sure names are
    unique and not empty,

  - `"universal"` or `"universal_quiet"`: make the names unique and
    syntactic

  - `"check_unique"`: no name repair, but check they are unique,

  - a function: apply custom name repair.

- names_clean:

  (`function`) A one-argument function to clean names after repairing.
  For example use `camel_case_to_snake_case()`.

- x:

  (`character`) CamelCase text to convert to snake_case.

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
camel_case_to_snake_case(c("ExampleText", "otherTextToConvert"))
#> [1] "_example_text"         "other_text_to_convert"
```

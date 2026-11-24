# Combine multiple specifications

Combine specifications created by
[`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
[`tspec_row()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
or
[`tspec_object()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md).
The resulting specification includes all fields from the input
specifications.

## Usage

``` r
tspec_combine(..., .duplicate_keys = c("error", "warn", "allow"))
```

## Arguments

- ...:

  (`tspec`) Specifications to combine.

- .duplicate_keys:

  (`character(1)`) What to do if more than one field uses the same
  `.key`. Can be one of:

  - `"error"`: The default. Throw an error.

  - `"warn"`: Allow the duplicates, but warn.

  - `"allow"`: Allow the duplicates without checking.

  Keys are compared as a whole, so `c("a", "b")` and `c("a", "c")` are
  different keys.

## Value

A tibblify specification.

## Details

If a field is specified in multiple input specifications, the field
specifications will be combined to produce a single field specification,
using the most specific specification for each argument. See the
examples for details.

## Examples

``` r
# union of fields
tspec_combine(
  tspec_df(tib_int("a")),
  tspec_df(tib_chr("b"))
)
#> tspec_df(
#>   tib_int("a", .required = FALSE),
#>   tib_chr("b", .required = FALSE),
#> )

# unspecified + x -> x
tspec_combine(
  tspec_df(tib_unspecified("a")),
  tspec_df(tib_int("a"))
)
#> tspec_df(
#>   tib_int("a"),
#> )

# scalar + vector -> vector
tspec_combine(
  tspec_df(tib_chr("a")),
  tspec_df(tib_chr_vec("a"))
)
#> tspec_df(
#>   tib_chr_vec("a"),
#> )

# scalar/vector + variant -> variant
tspec_combine(
  tspec_df(tib_chr("a")),
  tspec_df(tib_chr_vec("a")),
  tspec_df(tib_variant("a"))
)
#> tspec_df(
#>   tib_variant("a"),
#> )
```

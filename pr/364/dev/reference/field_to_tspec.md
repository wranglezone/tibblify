# Elevate a field to a tspec

Extract a nested field from a `tspec` and convert it to a top-level
`tspec_*()` object. `field_to_tspec()` dispatches to the appropriate
variant based on the type of the field. Use `field_to_tspec_df()`,
`field_to_tspec_row()`, or `field_to_tspec_recursive()` to extract a
field to the specified tspec type.

## Usage

``` r
field_to_tspec(spec, name)

field_to_tspec_df(spec, name)

field_to_tspec_row(spec, name)

field_to_tspec_recursive(spec, name)
```

## Arguments

- spec:

  (`tspec`) A tibblify specification.

- name:

  (`character(1)`) The name of the field.

## Value

A tibblify specification
([`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
[`tspec_row()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
or
[`tspec_recursive()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)).

## Examples

``` r
spec <- tspec_df(
  tib_int("id"),
  tib_df(
    "address",
    tib_chr("street"),
    tib_chr("city")
  )
)

field_to_tspec(spec, "address")
#> tspec_df(
#>   tib_chr("street"),
#>   tib_chr("city"),
#> )
field_to_tspec_row(spec, "address")
#> tspec_row(
#>   tib_chr("street"),
#>   tib_chr("city"),
#> )
```

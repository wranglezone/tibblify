# Convert a vector column to a tib scalar or unspecified specification

Convert a vector column to a tib scalar or unspecified specification

## Usage

``` r
.vector_col_to_spec(col, name)
```

## Arguments

- col:

  (`any`) A column from a data frame, which may be a vector, a list, or
  a nested data frame.

- name:

  (`character(1)`) The name of the field.

## Value

A
[`tib_scalar()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
or
[`tib_unspecified()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
specification.

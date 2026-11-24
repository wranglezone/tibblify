# Convert a nested data frame column to a tib_row specification

Convert a nested data frame column to a tib_row specification

## Usage

``` r
.df_col_to_spec(col, name, empty_list_unspecified)
```

## Arguments

- col:

  (`any`) A column from a data frame, which may be a vector, a list, or
  a nested data frame.

- name:

  (`character(1)`) The name of the field.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

## Value

A [`tib_row()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
specification.

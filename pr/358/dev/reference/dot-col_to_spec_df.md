# Convert a df-typed list column to a tib_df specification

Delegates to
[`.list_of_col_to_spec_df()`](https://tibblify.wrangle.zone/dev/reference/dot-list_of_col_to_spec_df.md)
or
[`.non_list_of_col_to_spec_df()`](https://tibblify.wrangle.zone/dev/reference/dot-non_list_of_col_to_spec_df.md)
based on whether `col` is a `list_of()` column.

## Usage

``` r
.col_to_spec_df(
  ptype,
  col,
  name,
  list_of_col,
  empty_list_unspecified,
  local_env
)
```

## Arguments

- ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

- col:

  (`any`) A column from a data frame, which may be a vector, a list, or
  a nested data frame.

- name:

  (`character(1)`) The name of the field.

- list_of_col:

  (`logical(1)`) Whether `col` is a `list_of()` column.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

A [`tib_df()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
specification.

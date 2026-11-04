# Build field specs from a non-list_of df column

Build field specs from a non-list_of df column

## Usage

``` r
.non_list_of_col_to_spec_df(col, ptype, empty_list_unspecified)
```

## Arguments

- col:

  (`any`) A column from a data frame, which may be a vector, a list, or
  a nested data frame.

- ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

## Value

A named list of tib field specifications with `required` set.

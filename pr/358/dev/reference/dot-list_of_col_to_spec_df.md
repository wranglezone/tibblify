# Build field specs from a list_of df column

Build field specs from a list_of df column

## Usage

``` r
.list_of_col_to_spec_df(col, ptype, empty_list_unspecified, local_env)
```

## Arguments

- col:

  (`any`) A column from a data frame, which may be a vector, a list, or
  a nested data frame.

- ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

A named list of tib field specifications.

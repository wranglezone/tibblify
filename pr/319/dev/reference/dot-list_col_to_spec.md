# Convert a list column to a tib field specification

Inspects the elements of `col` to determine whether they share a common
ptype and dispatches to the appropriate spec builder.

## Usage

``` r
.list_col_to_spec(col, name, empty_list_unspecified, local_env)
```

## Arguments

- col:

  (`any`) A column from a data frame, which may be a vector, a list, or
  a nested data frame.

- name:

  (`character(1)`) The name of the field.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

A tib field specification.

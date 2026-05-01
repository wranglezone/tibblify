# Main implementation of tree nesting

Main implementation of tree nesting

## Usage

``` r
.nest_tree_impl(
  x,
  id_col,
  parent_col,
  children_to,
  id_col_name,
  call = caller_env()
)
```

## Arguments

- x:

  (`any`) The object to check.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- parent_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that identifies
  the parent id of each observation. Each value must either be missing
  (for the root elements) or appear in the `id_col` column.

- children_to:

  (`character(1)`) The column name in which to store the children.

- id_col_name:

  (`character(1)`) The name of the column that uniquely identifies each
  observation.

- call:

  (`environment`) The environment to use for error messages.

## Value

A nested data frame with children column and parent column removed.

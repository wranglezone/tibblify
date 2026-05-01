# Confirm that `children_to` is a single string that is different from `id_col` and `parent_col`

Confirm that `children_to` is a single string that is different from
`id_col` and `parent_col`

## Usage

``` r
.check_children_to(children_to, id_col, parent_col, call = caller_env())
```

## Arguments

- children_to:

  (`character(1)`) The column name in which to store the children.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- parent_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that identifies
  the parent id of each observation. Each value must either be missing
  (for the root elements) or appear in the `id_col` column.

- call:

  (`environment`) The environment to use for error messages.

## Value

The input `children_to` object as a string.

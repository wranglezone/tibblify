# Traverse the tree and collect per-level data

Traverse the tree and collect per-level data

## Usage

``` r
.collect_tree_levels(
  x,
  id_col,
  child_col,
  parent_to,
  ancestors_to,
  call = caller_env()
)
```

## Arguments

- x:

  (`data.frame`) The root-level data frame.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- child_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that contains
  the children of an observation. This column must be a list where each
  element is either `NULL` or a data frame with the same columns as `x`.

- parent_to:

  (`character(1)`) The column name (`"parent"` by default) in which to
  store the parent id of an observation. Use `NULL` if you don't need
  this information.

- ancestors_to:

  (`character(1)`) The column name (`NULL` by default) in which to store
  the ids of the ancestors of a deeply nested child. Use `NULL` if you
  don't need this information.

- call:

  (`environment`) The environment to use for error messages.

## Value

A named list with elements `level_data`, `out_ptype`, `level_sizes`,
`level_parent_ids`, and `level_ancestors`.

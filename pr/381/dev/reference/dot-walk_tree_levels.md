# Walk the tree level by level, collecting a snapshot at each depth

Walk the tree level by level, collecting a snapshot at each depth

## Usage

``` r
.walk_tree_levels(x, id_col, child_col, call)
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

- call:

  (`environment`) The environment to use for error messages.

## Value

A list of per-level snapshots, each with elements `data`, `ns`,
`parent_ids`, and `child_sizes`.

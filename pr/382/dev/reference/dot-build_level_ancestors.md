# Build ancestor chains across levels using accumulate

Build ancestor chains across levels using accumulate

## Usage

``` r
.build_level_ancestors(snapshots, id_col, call)
```

## Arguments

- snapshots:

  (`list`) The object returned by
  [`.walk_tree_levels()`](https://tibblify.wrangle.zone/dev/reference/dot-walk_tree_levels.md).

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- call:

  (`environment`) The environment to use for error messages.

## Value

A list of length `length(snapshots)`, where element `k` is a list of
ancestor vectors (one per row at level `k`).

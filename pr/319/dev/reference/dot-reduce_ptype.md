# Reduce per-level data frames to their combined ptype

Reduce per-level data frames to their combined ptype

## Usage

``` r
.reduce_ptype(snapshots, call)
```

## Arguments

- snapshots:

  (`list`) The object returned by
  [`.walk_tree_levels()`](https://tibblify.wrangle.zone/dev/reference/dot-walk_tree_levels.md).

- call:

  (`environment`) The environment to use for error messages.

## Value

A 0-row data frame representing the combined type of all levels.

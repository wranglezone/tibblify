# Assemble the parent id column for `unnest_tree()` output

Assemble the parent id column for
[`unnest_tree()`](https://tibblify.wrangle.zone/dev/reference/unnest_tree.md)
output

## Usage

``` r
.assemble_parent_col(out, parent_to, tree_levels, id_col, call)
```

## Arguments

- out:

  (`data.frame`) The partially assembled output.

- parent_to:

  (`character(1)`) The column name (`"parent"` by default) in which to
  store the parent id of an observation. Use `NULL` if you don't need
  this information.

- tree_levels:

  (`list`) The object returned by
  [`.collect_tree_levels()`](https://tibblify.wrangle.zone/dev/reference/dot-collect_tree_levels.md),
  containing `level_data`, `out_ptype`, `level_sizes`,
  `level_parent_ids`, and `level_ancestors`.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- call:

  (`environment`) The environment to use for error messages.

## Value

A vector of parent ids with the same type as `out[[id_col]]` and the
same length as `nrow(out)`.

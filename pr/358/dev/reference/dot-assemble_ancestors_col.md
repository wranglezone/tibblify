# Assemble the ancestors column for `unnest_tree()` output

Assemble the ancestors column for
[`unnest_tree()`](https://tibblify.wrangle.zone/dev/reference/unnest_tree.md)
output

## Usage

``` r
.assemble_ancestors_col(out, ancestors_to, tree_levels, call)
```

## Arguments

- out:

  (`data.frame`) The partially assembled output.

- ancestors_to:

  (`character(1)`) The column name (`NULL` by default) in which to store
  the ids of the ancestors of a deeply nested child. Use `NULL` if you
  don't need this information.

- tree_levels:

  (`list`) The object returned by
  [`.collect_tree_levels()`](https://tibblify.wrangle.zone/dev/reference/dot-collect_tree_levels.md),
  containing `level_data`, `out_ptype`, `level_sizes`,
  `level_parent_ids`, and `level_ancestors`.

- call:

  (`environment`) The environment to use for error messages.

## Value

A vector of ancestor ids with the same length as `nrow(out)`.

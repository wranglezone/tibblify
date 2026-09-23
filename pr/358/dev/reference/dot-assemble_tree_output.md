# Assemble the final output from per-level data

Assemble the final output from per-level data

## Usage

``` r
.assemble_tree_output(
  tree_levels,
  id_col,
  level_to,
  parent_to,
  ancestors_to,
  call = caller_env()
)
```

## Arguments

- tree_levels:

  (`list`) The object returned by
  [`.collect_tree_levels()`](https://tibblify.wrangle.zone/dev/reference/dot-collect_tree_levels.md),
  containing `level_data`, `out_ptype`, `level_sizes`,
  `level_parent_ids`, and `level_ancestors`.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- level_to:

  (`character(1)`) The column name (`"level"` by default) in which to
  store the level of an observation. Use `NULL` if you don't need this
  information.

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

(`data.frame`) The assembled output with metadata columns appended.

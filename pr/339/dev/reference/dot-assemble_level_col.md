# Assemble the level column for `unnest_tree()` output

Assemble the level column for
[`unnest_tree()`](https://tibblify.wrangle.zone/dev/reference/unnest_tree.md)
output

## Usage

``` r
.assemble_level_col(out, level_to, level_data, call)
```

## Arguments

- out:

  (`data.frame`) The partially assembled output.

- level_data:

  (`list`) Data frames collected at each tree level, without the child
  column.

- call:

  (`environment`) The environment to use for error messages.

## Value

An integer vector of levels with the same length as `nrow(out)`.

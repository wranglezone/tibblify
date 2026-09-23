# Shared (un)nest_tree parameters

These parameters are used in multiple
[`nest_tree()`](https://tibblify.wrangle.zone/dev/reference/nest_tree.md)
or
[`unnest_tree()`](https://tibblify.wrangle.zone/dev/reference/unnest_tree.md)
helpers. They are defined here to make them easier to import and to
find. This break-out is for parameters that differ between
`(un)nest_tree()` helpers and other functions that might use the same
parameters.

## Arguments

- col:

  (`character`, `integer`, or `symbol`) Defused R code describing a
  selection according to the tidyselect syntax.

- col_arg:

  (`character(1)`) The name of the `col` argument, used for error
  messages.

- ids:

  (`character` or `integer`) The potential child ids to compare against.

- parent_ids:

  (`character` or `integer`) The parent ids to check.

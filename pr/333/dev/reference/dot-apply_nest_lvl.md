# Apply nesting at a single tree level

Apply nesting at a single tree level

## Usage

``` r
.apply_nest_lvl(x_split, cur_lvl, children, parent_col, id_col, children_to)
```

## Arguments

- x_split:

  (`data.frame`) A data frame that has been split using
  [`vctrs::vec_split()`](https://vctrs.r-lib.org/reference/vec_split.html).

- cur_lvl:

  (`integer(1)`) The key being split.

- children:

  (`data.frame`) The data frame that contains potential children.

- parent_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that identifies
  the parent id of each observation. Each value must either be missing
  (for the root elements) or appear in the `id_col` column.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- children_to:

  (`character(1)`) The column name in which to store the children.

## Value

A data frame of parents with their children nested into a column.

# Resolve `child_col` to a column name string

Resolve `child_col` to a column name string

## Usage

``` r
.normalize_child_col_name(child_col, x, id_col, call = caller_env())
```

## Arguments

- child_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that contains
  the children of an observation. This column must be a list where each
  element is either `NULL` or a data frame with the same columns as `x`.

- x:

  (`data.frame`) The data frame to unnest.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- call:

  (`environment`) The environment to use for error messages.

## Value

`child_col` resolved to a `character(1)` column name.

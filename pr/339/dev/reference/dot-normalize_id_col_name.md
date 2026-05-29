# Resolve `id_col` to a column name string

Resolve `id_col` to a column name string

## Usage

``` r
.normalize_id_col_name(id_col, x, call = caller_env())
```

## Arguments

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- x:

  (`data.frame`) The data frame to unnest.

- call:

  (`environment`) The environment to use for error messages.

## Value

`id_col` resolved to a `character(1)` column name.

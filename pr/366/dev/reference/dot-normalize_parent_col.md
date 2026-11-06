# Normalize and check the parent column

Normalize and check the parent column

## Usage

``` r
.normalize_parent_col(parent_col, x, id_col, id_col_name, call = caller_env())
```

## Arguments

- parent_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that identifies
  the parent id of each observation. Each value must either be missing
  (for the root elements) or appear in the `id_col` column.

- x:

  (`any`) The object to check.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- id_col_name:

  (`character(1)`) The name of the column that uniquely identifies each
  observation.

- call:

  (`environment`) The environment to use for error messages.

## Value

The integer index of the parent column.

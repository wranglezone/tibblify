# Normalize and check the id column

Normalize and check the id column

## Usage

``` r
.normalize_id_col(id_col, x, call = caller_env())
```

## Arguments

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- x:

  (`any`) The object to check.

- call:

  (`environment`) The environment to use for error messages.

## Value

The integer index of the id column.

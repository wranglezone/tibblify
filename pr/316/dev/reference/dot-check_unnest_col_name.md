# Validate and normalise an output column name

Validate and normalise an output column name

## Usage

``` r
.check_unnest_col_name(
  col_name,
  x,
  col_arg = caller_arg(col_name),
  call = caller_env()
)
```

## Arguments

- col_name:

  (`character(1)`) The name of the column.

- x:

  (`data.frame`) The data frame to unnest.

- col_arg:

  (`character(1)`) The name of the `col` argument, used for error
  messages.

- call:

  (`environment`) The environment to use for error messages.

## Value

`col_name` (cast to `character`) or `NULL`.

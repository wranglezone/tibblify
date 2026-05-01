# Validate an output column name and check it differs from prior names

Validate an output column name and check it differs from prior names

## Usage

``` r
.check_unnest_col_diff(
  col_name,
  x,
  ...,
  col_arg = caller_arg(col_name),
  call = caller_env()
)
```

## Arguments

- col_name:

  (`character(1)`) The name of the column.

- x:

  (`data.frame`) The data frame to unnest.

- ...:

  Already-reserved column names that `col_name` must differ from.

- col_arg:

  (`character(1)`) The name of the `col` argument, used for error
  messages.

- call:

  (`environment`) The environment to use for error messages.

## Value

`col_name` or `NULL`.

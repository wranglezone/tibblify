# Check that a column name does not already exist in a data frame

Check that a column name does not already exist in a data frame

## Usage

``` r
.check_col_new(
  x,
  col_name,
  col_arg = caller_arg(col_name),
  x_arg = "x",
  call = caller_env()
)
```

## Arguments

- x:

  (`data.frame`) The data frame to unnest.

- col_name:

  (`character(1)`) The name of the column.

- col_arg:

  (`character(1)`) The name of the `col` argument, used for error
  messages.

- x_arg:

  (`character(1)`) Data frame argument name used in error messages.

- call:

  (`environment`) The environment to use for error messages.

## Value

`x` (invisibly). Throws an error if `col_name` is already a column of
`x`.

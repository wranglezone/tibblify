# Check that a column has no missing values

Check that a column has no missing values

## Usage

``` r
.check_col_values_missing(x, x_arg, call = caller_env())
```

## Arguments

- x:

  (`any`) The object to check.

- x_arg:

  (`character(1)`) The name of the x argument. This name will be
  mentioned in error messages as the input that is at the origin of a
  problem.

- call:

  (`environment`) The environment to use for error messages.

## Value

The input `x`.

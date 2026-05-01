# Confirm that an object is a data frame

Confirm that an object is a data frame

## Usage

``` r
.check_is_df(x, x_arg = caller_arg(x), call = caller_env())
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

The input object.

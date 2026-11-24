# Abort when x is neither an object nor a list of objects

Abort when x is neither an object nor a list of objects

## Usage

``` r
.abort_not_tibblifiable(x, arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  (`any`) The object to check.

- arg:

  (`character(1)`) An argument name. This name will be mentioned in
  error messages as the input that is at the origin of a problem.

- call:

  (`environment`) The environment to use for error messages.

## Value

Nothing. Called for its side effect of throwing an error.

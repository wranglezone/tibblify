# bort if `x` is not a list of objects

bort if `x` is not a list of objects

## Usage

``` r
.check_object_list(x, arg = caller_arg(x), call = caller_env())
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

`x` (invisibly). Called for side effect.

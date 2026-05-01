# Validate that arguments are different

Validate that arguments are different

## Usage

``` r
.check_arg_different(arg, ..., arg_name = caller_arg(arg), call = caller_env())
```

## Arguments

- arg:

  (`any`) The value to compare against `...`.

- ...:

  Other arguments that `arg` must differ from.

- arg_name:

  (`character(1)`) The argument name shown in error messages.

- call:

  (`environment`) The environment to use for error messages.

## Value

`arg` (invisibly). Throws an error if any values are identical.

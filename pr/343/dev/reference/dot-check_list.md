# Validate that an input is a list

Validate that an input is a list

## Usage

``` r
.check_list(
  x,
  ...,
  allow_null = FALSE,
  arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  (`any`) The object to check.

- ...:

  Additional arguments passed to
  [`rlang::stop_input_type()`](https://rlang.r-lib.org/reference/stop_input_type.html).

- allow_null:

  (`logical(1)`) Whether `NULL` is accepted.

- arg:

  (`character(1)`) An argument name. This name will be mentioned in
  error messages as the input that is at the origin of a problem.

- call:

  (`environment`) The environment to use for error messages.

## Value

`NULL` (invisibly) if valid; otherwise throws an error.

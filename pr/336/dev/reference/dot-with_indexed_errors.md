# Wrap indexed purrr errors with context

Wrap indexed purrr errors with context

## Usage

``` r
.with_indexed_errors(
  expr,
  message,
  error_call = caller_env(),
  env = caller_env()
)
```

## Arguments

- expr:

  (`any`) An expression to evaluate and return, with indexed errors
  wrapped.

- message:

  (`character`) A cli message template.

- error_call:

  (`environment`) The environment to use for error messages.

- env:

  (`environment`) The environment used to evaluate glue fields in
  `message`.

## Value

The evaluated result of `expr`, or an error with added context.

# Signal an error with standards applied

Signal an error with standards applied

## Usage

``` r
.tibblify_abort(
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
)
```

## Arguments

- message:

  (`character`) A cli message template.

- subclass:

  (`character`) Class(es) to assign to the error. Will be prefixed by
  "tibblify-error-".

- call:

  (`environment`) The environment to use for error messages.

- message_env:

  (`environment`) The environment used to evaluate glue fields in
  `message`.

- parent:

  (`condition` or `NULL`) A parent condition, if any.

- ...:

  Additional parameters passed to
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  and on to
  [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html).

## Value

Does not return; throws an error.

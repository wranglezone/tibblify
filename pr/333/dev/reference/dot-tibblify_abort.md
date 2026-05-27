# Throw a tibblify internal error

Throw a tibblify internal error

## Usage

``` r
.tibblify_abort(..., .envir = caller_env())
```

## Arguments

- ...:

  Arguments passed to
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html).

- .envir:

  (`environment`) The environment used to evaluate cli fields.

## Value

`NULL` (invisibly). Called for its side effect of throwing an error.

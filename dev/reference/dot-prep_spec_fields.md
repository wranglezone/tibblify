# Flatten, validate, and auto-name field specifications

Flatten, validate, and auto-name field specifications

## Usage

``` r
.prep_spec_fields(
  .fields,
  .duplicate_keys = "error",
  .error_call = caller_env()
)
```

## Arguments

- .fields:

  (`list`) A list of field specifications, typically created by
  `tib_*()`.

- .duplicate_keys:

  (`character(1)`) What to do if more than one field uses the same
  `.key`. Can be one of:

  - `"error"`: The default. Throw an error.

  - `"warn"`: Allow the duplicates, but warn.

  - `"allow"`: Allow the duplicates without checking.

  Keys are compared as a whole, so `c("a", "b")` and `c("a", "c")` are
  different keys.

- .error_call:

  (`environment`) The environment to use for error messages.

## Value

A named list of validated field specifications.

# Flatten, validate, and auto-name field specifications

Flatten, validate, and auto-name field specifications

## Usage

``` r
.prep_spec_fields(.fields, .error_call)
```

## Arguments

- .fields:

  (`list`) A list of field specifications, typically created by
  `tib_*()`.

- .error_call:

  (`environment`) The environment to use for error messages.

## Value

A named list of validated field specifications.

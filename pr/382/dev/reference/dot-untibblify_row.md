# Untibblify a single data frame row into a named list

Untibblify a single data frame row into a named list

## Usage

``` r
.untibblify_row(x, spec, call = caller_env())
```

## Arguments

- x:

  (`any`) The object to check.

- spec:

  (`tspec` or `NULL`) A spec object describing the structure of `x`.

- call:

  (`environment`) The environment to use for error messages.

## Value

A named list with one element per field of `x`.

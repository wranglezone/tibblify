# Untibblify a named list using a spec

Untibblify a named list using a spec

## Usage

``` r
.untibblify_list(x, spec, call = caller_env())
```

## Arguments

- x:

  (`any`) The object to check.

- spec:

  (`tspec` or `NULL`) A spec object describing the structure of `x`.

- call:

  (`environment`) The environment to use for error messages.

## Value

A named list with fields converted according to `spec`.

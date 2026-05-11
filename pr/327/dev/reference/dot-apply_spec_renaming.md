# Rename list elements back to their original spec keys

Reverses tibblify's field renaming by mapping column names back to the
original keys defined in `spec`.

## Usage

``` r
.apply_spec_renaming(x, spec, call = caller_env())
```

## Arguments

- x:

  (`any`) The object to check.

- spec:

  (`tspec` or `NULL`) A spec object describing the structure of `x`.

- call:

  (`environment`) The environment to use for error messages.

## Value

A named list with elements keyed by the original spec keys.

# Untibblify a data frame into a list of row lists

Untibblify a data frame into a list of row lists

## Usage

``` r
.untibblify_df(x, spec, call = caller_env())
```

## Arguments

- x:

  (`any`) The object to check.

- spec:

  (`tspec` or `NULL`) A spec object describing the structure of `x`.

- call:

  (`environment`) The environment to use for error messages.

## Value

A list with one named list per row of `x`.

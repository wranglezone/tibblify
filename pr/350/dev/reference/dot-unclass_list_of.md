# Unclass a list_of child data frame

Unclass a list_of child data frame

## Usage

``` r
.unclass_list_of(x, child_col, call = caller_env())
```

## Arguments

- x:

  (`data.frame` or `NULL`) A single child data frame.

- child_col:

  (`character(1)`) Name of the column that may itself be a
  `vctrs_list_of`.

- call:

  (`environment`) The environment to use for error messages.

## Value

(`data.frame` or `NULL`) `x` with `vctrs_list_of` classes removed, or
`NULL` if `x` is `NULL`.

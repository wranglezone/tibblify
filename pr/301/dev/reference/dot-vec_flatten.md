# Flatten a list to a vector

Flatten a list to a vector

## Usage

``` r
.vec_flatten(x, ptype, name_spec = zap())
```

## Arguments

- x:

  (`any`) The object to check.

- ptype:

  (`vector(0)`) Prototype for the flattened output.

- name_spec:

  (`character(1)`, `function`, or `NULL`) Name specification passed to
  [`vctrs::list_unchop()`](https://vctrs.r-lib.org/reference/list_unchop.html).

## Value

A vector with elements from `x`.

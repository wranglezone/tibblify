# Conver POSIXlt to POSIXct

Conver POSIXlt to POSIXct

## Usage

``` r
.cast_posixlt_ptype(ptype)
```

## Arguments

- ptype:

  (`any`) An object which might be a `POSIXlt` or have `POSIXlt` in its
  class hierarchy.

## Value

An object of class `POSIXct` if the input is `POSIXlt` (to be in line
with <https://github.com/r-lib/vctrs/issues/1576>), otherwise the input
unchanged.

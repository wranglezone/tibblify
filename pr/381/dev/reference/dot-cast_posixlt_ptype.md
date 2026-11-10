# Convert POSIXlt to POSIXct

Convert POSIXlt to POSIXct

## Usage

``` r
.cast_posixlt_ptype(x)
```

## Arguments

- x:

  (`any`) The object to check.

## Value

An object of class `POSIXct` if the input is `POSIXlt` (to be in line
with <https://github.com/r-lib/vctrs/issues/1576>), otherwise the input
unchanged.

# Remove empty lists from an object

Remove empty lists from an object

## Usage

``` r
.drop_empty_lists(x)
```

## Arguments

- x:

  (`any`) The object to check.

## Value

The input object with empty lists removed. If any were removed, the
returned object has an attribute `had_empty_lists` set to `TRUE`.

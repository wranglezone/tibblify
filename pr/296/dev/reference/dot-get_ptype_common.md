# Find the common ptype of a list of objects

Find the common ptype of a list of objects

## Usage

``` r
.get_ptype_common(x, empty_list_unspecified)
```

## Arguments

- x:

  (`any`) The object to check.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

## Value

A list with component `has_common_ptype` (`TRUE` if so, `FALSE`
otherwise) and optional components `ptype` (an object representing the
common `ptype`, if there is one) and `had_empty_lists` (`TRUE` if
`empty_list_unspecified` is `TRUE` and the `x` input had such empty
lists).

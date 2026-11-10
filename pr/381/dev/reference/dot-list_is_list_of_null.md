# For each element, is it a list of NULLs?

For each element, is it a list of NULLs?

## Usage

``` r
.list_is_list_of_null(x)
```

## Arguments

- x:

  (`any`) The object to check.

## Value

(`logical`) A logical vector the same length as `x`, where each element
is `TRUE` if the corresponding element of `x` is itself a list of
`NULL`s.

# Examine the column specification

Examine the column specification

## Usage

``` r
get_spec(x)
```

## Arguments

- x:

  The data frame object to extract from.

## Value

A tibblify specification object.

## Examples

``` r
df <- tibblify(list(list(x = 1, y = "a"), list(x = 2)))
get_spec(df)
#> tspec_df(
#>   tib_dbl("x"),
#>   tib_chr("y", required = FALSE),
#> )
```

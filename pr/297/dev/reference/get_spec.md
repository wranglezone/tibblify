# Examine the column specification

Examine the column specification

## Usage

``` r
get_spec(x)
```

## Arguments

- x:

  (`data.frame`) The data frame to extract a spec from.

## Value

A tibblify specification as returned by
[`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
[`tspec_row()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
[`tspec_object()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
or
[`tspec_recursive()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md).

## Examples

``` r
df <- tibblify(list(list(x = 1, y = "a"), list(x = 2)))
get_spec(df)
#> tspec_df(
#>   tib_dbl("x"),
#>   tib_chr("y", required = FALSE),
#> )
```

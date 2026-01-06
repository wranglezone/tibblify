# Combine multiple specifications

Combine multiple specifications

## Usage

``` r
tspec_combine(...)
```

## Arguments

- ...:

  Specifications to combine.

## Value

A tibblify specification.

## Examples

``` r
# union of fields
tspec_combine(
  tspec_df(tib_int("a")),
  tspec_df(tib_chr("b"))
)
#> tspec_df(
#>   tib_int("a", required = FALSE),
#>   tib_chr("b", required = FALSE),
#> )

# unspecified + x -> x
tspec_combine(
  tspec_df(tib_unspecified("a"), tib_chr("b")),
  tspec_df(tib_int("a"), tib_variant("b"))
)
#> tspec_df(
#>   tib_int("a"),
#>   tib_variant("b"),
#> )

# scalar + vector -> vector
tspec_combine(
  tspec_df(tib_chr("a")),
  tspec_df(tib_chr_vec("a"))
)
#> tspec_df(
#>   tib_chr_vec("a"),
#> )

# scalar/vector + variant -> variant
tspec_combine(
  tspec_df(tib_chr("a")),
  tspec_df(tib_variant("a"))
)
#> tspec_df(
#>   tib_variant("a"),
#> )
```

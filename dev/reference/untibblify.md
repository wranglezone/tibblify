# Convert a data frame or object into a nested list

Convert a data frame or an object into a nested list. This is the
inverse operation of
[`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md).
See
[`vignette("supported-structures")`](https://tibblify.wrangle.zone/dev/articles/supported-structures.md)
for a description of objects recognized by tibblify.

## Usage

``` r
untibblify(x, spec = get_spec(x))
```

## Arguments

- x:

  (`data.frame` or `object`) An object to convert into a nested list.

- spec:

  (`tspec`) Optional. A spec object which was used to create `x`.
  Defaults to the spec stored as the `tib_spec` attribute of `x`, if
  present.

## Value

A nested list.

## Examples

``` r
x <- tibble(
  a = 1:2,
  b = tibble(
    x = c("a", "b"),
    y = c(1.5, 2.5)
  )
)
untibblify(x)
#> [[1]]
#> [[1]]$a
#> [1] 1
#> 
#> [[1]]$b
#> [[1]]$b$x
#> [1] "a"
#> 
#> [[1]]$b$y
#> [1] 1.5
#> 
#> 
#> 
#> [[2]]
#> [[2]]$a
#> [1] 2
#> 
#> [[2]]$b
#> [[2]]$b$x
#> [1] "b"
#> 
#> [[2]]$b$y
#> [1] 2.5
#> 
#> 
#> 
```

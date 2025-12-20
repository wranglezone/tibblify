# Convert a data frame or object into a nested list

The inverse operation to
[`tibblify()`](https://wranglezone.github.io/tibblify/reference/tibblify.md).
It converts a data frame or an object into a nested list.

## Usage

``` r
untibblify(x, spec = NULL)
```

## Arguments

- x:

  A data frame or an object.

- spec:

  Optional. A spec object which was used to create `x`.

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

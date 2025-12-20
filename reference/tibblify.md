# Rectangle a nested list

Rectangle a nested list

## Usage

``` r
tibblify(x, spec = NULL, unspecified = NULL)
```

## Arguments

- x:

  A nested list.

- spec:

  A specification how to convert `x`. Generated with
  [`tspec_row()`](https://tibblify.wrangle.zone/reference/tspec_df.md)
  or
  [`tspec_df()`](https://tibblify.wrangle.zone/reference/tspec_df.md).

- unspecified:

  A string that describes what happens if the specification contains
  unspecified fields. Can be one of

  - `"error"`: Throw an error.

  - `"inform"`: Inform.

  - `"drop"`: Do not parse these fields.

  - `"list"`: Parse an unspecified field into a list.

## Value

Either a tibble or a list, depending on the specification

## See also

Use
[`untibblify()`](https://tibblify.wrangle.zone/reference/untibblify.md)
to undo the result of `tibblify()`.

## Examples

``` r
# List of Objects -----------------------------------------------------------
x <- list(
  list(id = 1, name = "Tyrion Lannister"),
  list(id = 2, name = "Victarion Greyjoy")
)
tibblify(x)
#> # A tibble: 2 × 2
#>      id name             
#>   <dbl> <chr>            
#> 1     1 Tyrion Lannister 
#> 2     2 Victarion Greyjoy

# Provide a specification
spec <- tspec_df(
  id = tib_int("id"),
  name = tib_chr("name")
)
tibblify(x, spec)
#> # A tibble: 2 × 2
#>      id name             
#>   <int> <chr>            
#> 1     1 Tyrion Lannister 
#> 2     2 Victarion Greyjoy

# Object --------------------------------------------------------------------
# Provide a specification for a single object
tibblify(x[[1]], tspec_object(spec))
#> $id
#> [1] 1
#> 
#> $name
#> [1] "Tyrion Lannister"
#> 

# Recursive Trees -----------------------------------------------------------
x <- list(
  list(
    id = 1,
    name = "a",
    children = list(
      list(id = 11, name = "aa"),
      list(id = 12, name = "ab", children = list(
        list(id = 121, name = "aba")
      ))
    ))
)
spec <- tspec_recursive(
  tib_int("id"),
  tib_chr("name"),
  .children = "children"
)
out <- tibblify(x, spec)
out
#> # A tibble: 1 × 3
#>      id name  children        
#>   <int> <chr> <list>          
#> 1     1 a     <tibble [2 × 3]>
out$children
#> [[1]]
#> # A tibble: 2 × 3
#>      id name  children        
#>   <int> <chr> <list>          
#> 1    11 aa    <NULL>          
#> 2    12 ab    <tibble [1 × 3]>
#> 
out$children[[1]]$children[[2]]
#> # A tibble: 1 × 3
#>      id name  children
#>   <int> <chr> <list>  
#> 1   121 aba   <NULL>  
```

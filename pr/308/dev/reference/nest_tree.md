# Convert a data frame to a tree

Convert a data frame to a tree

## Usage

``` r
nest_tree(data, id_col, parent_col, children_to)
```

## Arguments

- data:

  A data frame.

- id_col:

  Id column. The values must be unique and non-missing.

- parent_col:

  Parent column. Each value must either be missing (for the root
  elements) or appear in the `id_col` column.

- children_to:

  Name of the column the children should be put.

## Value

A tree like data frame.

## Examples

``` r
df <- tibble::tibble(
  id = 1:5,
  x = letters[1:5],
  parent = c(NA, NA, 1L, 2L, 4L)
)
out <- nest_tree(df, id, parent, "children")
out
#> # A tibble: 2 × 3
#>      id x     children        
#>   <int> <chr> <list>          
#> 1     1 a     <tibble [1 × 3]>
#> 2     2 b     <tibble [1 × 3]>

out$children
#> [[1]]
#> # A tibble: 1 × 3
#>      id x     children
#>   <int> <chr> <list>  
#> 1     3 c     <NULL>  
#> 
#> [[2]]
#> # A tibble: 1 × 3
#>      id x     children        
#>   <int> <chr> <list>          
#> 1     4 d     <tibble [1 × 3]>
#> 
out$children[[2]]$children
#> [[1]]
#> # A tibble: 1 × 3
#>      id x     children
#>   <int> <chr> <list>  
#> 1     5 e     <NULL>  
#> 
```

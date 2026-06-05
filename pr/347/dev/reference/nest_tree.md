# Convert a data frame to a tree

Recursively nest data frame rows based on parent-child relationships,
defined by an id column and a parent column. Children become sub-tibbles
of their parent rows. This structure is intended for representing
tree-like data, such as organizational charts, file systems, category
trees, or any other hierarchical relationships.

## Usage

``` r
nest_tree(x, id_col, parent_col, children_to)
```

## Arguments

- x:

  (`data.frame`) The data frame to nest.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- parent_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that identifies
  the parent id of each observation. Each value must either be missing
  (for the root elements) or appear in the `id_col` column.

- children_to:

  (`character(1)`) The column name in which to store the children.

## Value

A tree-like, recursively nested data frame.

## Examples

``` r
df <- tibble::tibble(
  id = 1:5,
  x = letters[1:5],
  parent = c(NA, NA, 1L, 2L, 4L)
)
df
#> # A tibble: 5 × 3
#>      id x     parent
#>   <int> <chr>  <int>
#> 1     1 a         NA
#> 2     2 b         NA
#> 3     3 c          1
#> 4     4 d          2
#> 5     5 e          4

# Only the root elements are in the top-level tibble.
out <- nest_tree(df, id, parent, "children")
out
#> # A tibble: 2 × 3
#>      id x     children        
#>   <int> <chr> <list>          
#> 1     1 a     <tibble [1 × 3]>
#> 2     2 b     <tibble [1 × 3]>

# The children of each element are stored in the "children" column.
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

# "d" (id 4) is a child of "b" (id 2), and "e" (id 5) is a child of "d"
# (id 4).
out$children[[2]]$children
#> [[1]]
#> # A tibble: 1 × 3
#>      id x     children
#>   <int> <chr> <list>  
#> 1     5 e     <NULL>  
#> 
```

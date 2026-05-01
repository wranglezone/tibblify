# Unnest a recursive data frame

Unnest a recursive data frame

## Usage

``` r
unnest_tree(
  x,
  id_col,
  child_col,
  level_to = "level",
  parent_to = "parent",
  ancestors_to = NULL
)
```

## Arguments

- x:

  (`data.frame`) The data frame to unnest.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- child_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that contains
  the children of an observation. This column must be a list where each
  element is either `NULL` or a data frame with the same columns as `x`.

- level_to:

  (`character(1)`) The column name (`"level"` by default) in which to
  store the level of an observation. Use `NULL` if you don't need this
  information.

- parent_to:

  (`character(1)`) The column name (`"parent"` by default) in which to
  store the parent id of an observation. Use `NULL` if you don't need
  this information.

- ancestors_to:

  (`character(1)`) The column name (`NULL` by default) in which to store
  the ids of the ancestors of a deeply nested child. Use `NULL` if you
  don't need this information.

## Value

A "flat" data frame.

## Examples

``` r
df <- tibble(
  id = 1L,
  name = "a",
  children = list(
    tibble(
      id = 11:12,
      name = c("b", "c"),
      children = list(
        NULL,
        tibble(
          id = 121:122,
          name = c("d", "e")
        )
      )
    )
  )
)
df
#> # A tibble: 1 × 3
#>      id name  children        
#>   <int> <chr> <list>          
#> 1     1 a     <tibble [2 × 3]>

unnest_tree(
  df,
  id_col = "id",
  child_col = "children",
  level_to = "level",
  parent_to = "parent",
  ancestors_to = "ancestors"
)
#> # A tibble: 5 × 5
#>      id name  level parent ancestors
#>   <int> <chr> <int>  <int> <list>   
#> 1     1 a         1     NA <NULL>   
#> 2    11 b         2      1 <int [1]>
#> 3    12 c         2      1 <int [1]>
#> 4   121 d         3     12 <int [2]>
#> 5   122 e         3     12 <int [2]>
```

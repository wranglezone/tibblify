# Unnest a recursive data frame

Unnest a recursive data frame

## Usage

``` r
unnest_tree(
  data,
  id_col,
  child_col,
  level_to = "level",
  parent_to = "parent",
  ancestors_to = NULL
)
```

## Arguments

- data:

  A data frame.

- id_col:

  A column that uniquely identifies each observation.

- child_col:

  Column containing the children of an observation. This must be a list
  where each element is either `NULL` or a data frame with the same
  columns as `data`.

- level_to:

  A string (`"level"` by default) specifying the new column to store the
  level of an observation. Use `NULL` if you don't need this
  information.

- parent_to:

  A string (`"parent"` by default) specifying the new column storing the
  parent id of an observation. Use `NULL` if you don't need this
  information.

- ancestors_to:

  A string (`NULL` by default) specifying the new column storing the ids
  of its ancestors. Use `NULL` if you don't need this information.

## Value

A data frame.

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

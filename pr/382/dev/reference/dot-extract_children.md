# Extract and validate the children list from a level data frame

Extract and validate the children list from a level data frame

## Usage

``` r
.extract_children(x, child_col, call = caller_env())
```

## Arguments

- x:

  (`data.frame`) Current level data frame.

- child_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that contains
  the children of an observation. This column must be a list where each
  element is either `NULL` or a data frame with the same columns as `x`.

- call:

  (`environment`) The environment to use for error messages.

## Value

(`list`) The children list extracted from `x[[child_col]]`.

# Unclass and unchop a list of child data frames

Unclass and unchop a list of child data frames

## Usage

``` r
.unchop_children(children, child_col, call = caller_env())
```

## Arguments

- children:

  (`list`) List of child data frames or `NULL` elements.

- child_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that contains
  the children of an observation. This column must be a list where each
  element is either `NULL` or a data frame with the same columns as `x`.

- call:

  (`environment`) The environment to use for error messages.

## Value

(`data.frame`) All non-`NULL` children combined into one data frame.

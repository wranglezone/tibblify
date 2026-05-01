# Compute tree level for each element based on id and parent relationships

Compute tree level for each element based on id and parent relationships

## Usage

``` r
.nest_tree_lvl(ids, parent_ids, id_col_name, call = caller_env())
```

## Arguments

- id_col_name:

  (`character(1)`) The name of the column that uniquely identifies each
  observation.

- call:

  (`environment`) The environment to use for error messages.

## Value

A list with `lvls` (integer vector of levels) and `max_lvl` (maximum
level).

# Validate parent ids: cast to id type, check for self-references and missing roots

Validate parent ids: cast to id type, check for self-references and
missing roots

## Usage

``` r
.check_parent_ids(x, parent_col, id_col, id_col_name, call = caller_env())
```

## Arguments

- x:

  (`any`) The object to check.

- parent_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that identifies
  the parent id of each observation. Each value must either be missing
  (for the root elements) or appear in the `id_col` column.

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- id_col_name:

  (`character(1)`) The name of the column that uniquely identifies each
  observation.

- call:

  (`environment`) The environment to use for error messages.

## Value

The parent ids, cast to the same type as ids.

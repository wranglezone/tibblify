# Evaluate and extract a single column selection

Evaluate and extract a single column selection

## Usage

``` r
.eval_pull(x, col, col_arg, call = caller_env())
```

## Arguments

- x:

  (`any`) The object to check.

- col:

  (`character`, `integer`, or `symbol`) Defused R code describing a
  selection according to the tidyselect syntax.

- col_arg:

  (`character(1)`) The name of the `col` argument, used for error
  messages.

- call:

  (`environment`) The environment to use for error messages.

## Value

An integer index of the selected column, named by the column name.

# Collapse expressions with padding and optional multi-line formatting

Collapse expressions with padding and optional multi-line formatting

## Usage

``` r
.name_exprs(exprs, names, show_name)
```

## Arguments

- exprs:

  (`list`) Expressions to collapse.

- names:

  (`character`) Names corresponding to the expressions.

- show_name:

  (`logical`) A vector indicating whether each name should be shown.

## Value

A character vector of the expressions with names prepended where
`show_name` is `TRUE`. Non-syntactic names are backticked. If
`show_name` is `FALSE`, the expressions are returned without names.

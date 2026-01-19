# Stabilize values_to argument

Stabilize values_to argument

## Usage

``` r
.stabilize_values_to(.values_to, .call)
```

## Arguments

- .values_to:

  (`character(1)` or `NULL`) For `NULL` (the default), the field is
  converted to a `.ptype` vector. If a string is provided, the field is
  converted to a tibble and the values go into the specified column.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`character(1)` or `NULL`) Validated `.values_to`.

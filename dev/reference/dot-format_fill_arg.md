# Format the `.fill` argument for display

Format the `.fill` argument for display

## Usage

``` r
.format_fill_arg(x, .fill)
```

## Arguments

- x:

  A tibblify collector object.

- .fill:

  (`vector` or `NULL`) Optionally, a value to use if the field does not
  exist.

## Value

(`character(1)` or `NULL`) The formatted fill string, or `NULL` if the
argument should be omitted.

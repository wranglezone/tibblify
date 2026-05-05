# Determine whether to inform about unspecified fields in spec

Wrapper around `getOption("tibblify.show_unspecified")` to return `TRUE`
unless the option is explicitly set to `FALSE`.

## Usage

``` r
should_inform_unspecified()
```

## Value

`FALSE` if the option is set to `FALSE`, `TRUE` otherwise.

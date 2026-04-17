# Determine whether to inform about unspecified fields in spec

Wrapper around `getOption("tibblify.show_unspecified")` that implements
some fall back logic if the option is unset. This returns:

- `FALSE` if the option is set to `FALSE`

- `TRUE` otherwise

## Usage

``` r
should_inform_unspecified()
```

## Value

`TRUE` or `FALSE`.

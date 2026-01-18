# Determine whether to inform about unspecified fields in spec

Wrapper around `getOption("tibblify.show_unspecified")` that implements
some fall back logic if the option is unset. This returns:

- `TRUE` if the option is set to `TRUE`

- `FALSE` if the option is set to `FALSE`

- `FALSE` if the option is unset and we appear to be running tests

- `TRUE` otherwise

## Usage

``` r
should_inform_unspecified()
```

## Value

`TRUE` or `FALSE`.

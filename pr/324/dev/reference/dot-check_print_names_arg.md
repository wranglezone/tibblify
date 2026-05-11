# Check and determine whether to print names for tibblifying

Check and determine whether to print names for tibblifying

## Usage

``` r
.check_print_names_arg(names)
```

## Arguments

- names:

  (`logical(1)`) Should names be printed even if they can be deduced
  from the spec?

## Value

A logical value indicating whether to print names for tibblifying, based
on the provided `names` argument or the `tibblify.print_names` option if
`names` is `NULL`.

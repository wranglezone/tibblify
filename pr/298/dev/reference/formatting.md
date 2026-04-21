# Printing tibblify specifications

Printing tibblify specifications

## Usage

``` r
# S3 method for class 'tspec'
print(x, width = NULL, ..., names = NULL)

# S3 method for class 'tspec_df'
format(x, width = NULL, ..., names = NULL)
```

## Arguments

- x:

  Spec to format or print

- width:

  Width of text output to generate.

- ...:

  These dots are for future extensions and must be empty.

- names:

  Should names be printed even if they can be deduced from the spec?

## Value

`x` is returned invisibly.

## Examples

``` r
spec <- tspec_df(
  a = tib_int("a"),
  new_name = tib_chr("b"),
  row = tib_row(
    "row",
    x = tib_int("x")
  )
)
print(spec, names = FALSE)
#> tspec_df(
#>   tib_int("a"),
#>   new_name = tib_chr("b"),
#>   tib_row(
#>     "row",
#>     tib_int("x"),
#>   ),
#> )
print(spec, names = TRUE)
#> tspec_df(
#>   a = tib_int("a"),
#>   new_name = tib_chr("b"),
#>   row = tib_row(
#>     "row",
#>     tib_int("x"),
#>   ),
#> )
```

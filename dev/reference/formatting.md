# Printing tibblify specifications

The [`print()`](https://rdrr.io/r/base/print.html) and
[`format()`](https://rdrr.io/r/base/format.html) methods for tibblify
specifications provide the code necessary to generate the specification.
Function names are color-coded to help visually distinguish different
types of collectors.

## Usage

``` r
# S3 method for class 'tib_collector'
print(x, width = NULL, ..., names = NULL)

# S3 method for class 'tib_scalar'
format(
  x,
  ...,
  .fill = NULL,
  .ptype_inner = NULL,
  .transform = NULL,
  multi_line = FALSE,
  nchar_indent = 0,
  width = NULL,
  names = FALSE
)

# S3 method for class 'tib_variant'
format(x, ..., multi_line = FALSE, nchar_indent = 0, width = NULL)

# S3 method for class 'tib_vector'
format(x, ..., multi_line = FALSE, nchar_indent = 0, width = NULL)

# S3 method for class 'tib_unspecified'
format(
  x,
  ...,
  .fill = NULL,
  .ptype_inner = NULL,
  .transform = NULL,
  multi_line = FALSE,
  nchar_indent = 0,
  width = NULL,
  names = FALSE
)

# S3 method for class 'tib_scalar_chr_date'
format(x, ..., multi_line = FALSE, nchar_indent = 0, width = NULL)

# S3 method for class 'tib_vector_chr_date'
format(x, ..., multi_line = FALSE, nchar_indent = 0, width = NULL)

# S3 method for class 'tib_row'
format(x, ..., width = NULL, names = NULL)

# S3 method for class 'tib_df'
format(x, ..., width = NULL, names = NULL)

# S3 method for class 'tib_recursive'
format(x, ..., width = NULL, names = NULL)

# S3 method for class 'tibblify_object'
print(x, ...)

# S3 method for class 'tspec'
print(x, width = NULL, ..., names = NULL)

# S3 method for class 'tspec_df'
format(x, width = NULL, ..., names = NULL)

# S3 method for class 'tspec_row'
format(x, width = NULL, ..., names = NULL)

# S3 method for class 'tspec_recursive'
format(x, width = NULL, ..., names = NULL)

# S3 method for class 'tspec_object'
format(x, width = NULL, ..., names = NULL)
```

## Arguments

- x:

  (`any`) The spec to format or print.

- width:

  (`integer(1)`) The width (in number of characters) of text output to
  generate.

- ...:

  These dots are for future extensions and must be empty.

- names:

  (`logical(1)`) Should names be printed even if they can be deduced
  from the spec?

- .fill:

  (`vector` or `NULL`) Optionally, a value to use if the field does not
  exist.

- .ptype_inner:

  (`vector(0)`) A prototype of the input field.

- .transform:

  (`function` or `NULL`) A function to apply to the whole vector after
  casting to `.ptype_inner`.

- multi_line:

  (`logical(1)`) Should the output be formatted across multiple lines?
  For example, should each element of even a short list be displayed on
  its own line?

- nchar_indent:

  (`integer(1)`) The number of (additional) characters that will be used
  to indent the output when `multi_line = TRUE`. Primarily for internal
  use when formatting is applied recursively.

## Value

For [`print()`](https://rdrr.io/r/base/print.html) methods, `x` is
returned invisibly. [`format()`](https://rdrr.io/r/base/format.html)
methods return a length-1 character vector.

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

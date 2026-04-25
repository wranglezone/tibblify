# Build the formatted argument string for a collector call

Build the formatted argument string for a collector call

## Usage

``` r
.format_tib_parts(
  f_name,
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
```

## Arguments

- f_name:

  (`character(1)`) The (possibly ANSI-colored) function name.

- x:

  A tibblify collector object.

- ...:

  Additional named arguments to include verbatim in the output,
  forwarded from the calling `format.*` method.

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

- width:

  (`integer(1)`) The width (in number of characers) of text output to
  generate.

- names:

  (`logical(1)`) Should names be printed even if they can be deduced
  from the spec?

## Value

(`character(1)`) A string of comma-separated, possibly wrapped arguments
ready to be placed inside the parentheses of the collector call.

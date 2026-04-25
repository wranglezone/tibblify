# Collapse expressions with padding and optional multi-line formatting

Collapse expressions with padding and optional multi-line formatting

## Usage

``` r
.collapse_with_pad(x, multi_line, nchar_prefix = 0, width)
```

## Arguments

- x:

  (`list`) Expressions to collapse.

- multi_line:

  (`logical(1)`) Should the output be formatted across multiple lines?
  For example, should each element of even a short list be displayed on
  its own line?

- nchar_prefix:

  (`integer(1)`) The number of characters that are "used up" by any
  prefix portions of the output. Used to determine whether the output
  will fit on a single line or if it should be wrapped across multiple
  lines.

- width:

  (`integer(1)`) The width (in number of characers) of text output to
  generate.

## Value

A single string with the expressions collapsed, either on a single line
or wrapped across multiple lines with indentation.

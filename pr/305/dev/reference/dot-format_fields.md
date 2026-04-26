# Format fields to print a function call

Format fields to print a function call

## Usage

``` r
.format_fields(f_name, fields, width, force_names, args = NULL)
```

## Arguments

- f_name:

  (`character(1)`) The (possibly ANSI-colored) function name.

- fields:

  (`list` or `NULL`) Fields to format.

- width:

  (`integer(1)`) The width (in number of characters) of text output to
  generate.

- force_names:

  (`logical(1)`) Should names be printed even if they can be deduced
  from the spec?

- args:

  (`list` or `NULL`) Additional arguments to format and display before
  fields.

## Value

A single string with the formatted fields.

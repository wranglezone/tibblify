# Collect formatted field parts

Collect formatted field parts

## Usage

``` r
.collect_parts(fields, width, force_names, args)
```

## Arguments

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

A character vector of formatted field parts.

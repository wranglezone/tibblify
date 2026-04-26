# Format field parts with canonical names

Format field parts with canonical names

## Usage

``` r
.format_field_canonical_names(fields, width, force_names)
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

## Value

A character vector of formatted field parts with canonical names
potentially suppressed.

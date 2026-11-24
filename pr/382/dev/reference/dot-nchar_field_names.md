# Calculate the number of characters in a field's name part

Calculate the number of characters in a field's name part

## Usage

``` r
.nchar_field_names(fields)
```

## Arguments

- fields:

  (`list` or `NULL`) Fields to format.

## Value

An integer vector of the number of characters in the name part of each
field, including the "=" separator and a trailing comma.

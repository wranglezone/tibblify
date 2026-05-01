# Check if a tib field has a canonical name

Check if a tib field has a canonical name

## Usage

``` r
.is_tib_name_canonical(field, name)
```

## Arguments

- field:

  (`list`) A tib field.

- name:

  (`character(1)`) The name to check against the field's key.

## Value

`TRUE` if the field's key is a single string that matches `name`,
`FALSE` otherwise.

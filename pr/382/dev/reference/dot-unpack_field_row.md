# Unpack a row field

Unpack a row field

## Usage

``` r
.unpack_field_row(field_spec, name, names_sep)
```

## Arguments

- field_spec:

  (`tib_collector`) A tibblify field collector.

- name:

  (`character(1)`) The name of the field.

- names_sep:

  (`character(1)` or `NULL`) If `NULL`, the default, the inner names of
  fields are used. If a string, the outer and inner names are pasted
  together, separated by `names_sep`.

## Value

(`list`) A list of unpacked fields from the row spec.

# Guess a vector spec from a flat list of field values

Guess a vector spec from a flat list of field values

## Usage

``` r
.guess_object_list_field_spec_flat_to_vector(value_flat, name, ptype_result)
```

## Arguments

- value_flat:

  (`list`) The flattened values of a list field.

- name:

  (`character(1)`) The name of the field.

- ptype_result:

  (`list`) The result of
  [`.get_ptype_common()`](https://tibblify.wrangle.zone/dev/reference/dot-get_ptype_common.md)
  applied to `value_flat`.

## Value

A
[`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
spec.

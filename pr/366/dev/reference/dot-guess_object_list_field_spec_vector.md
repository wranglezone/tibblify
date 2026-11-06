# Guess the spec for a vector-typed field in an object list

Guess the spec for a vector-typed field in an object list

## Usage

``` r
.guess_object_list_field_spec_vector(value, name, ptype)
```

## Arguments

- value:

  (`list`) An object list whose fields will be guessed.

- name:

  (`character(1)`) The name of the field.

- ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

## Value

A
[`tib_scalar()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
or
[`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
spec.

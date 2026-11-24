# Build a tib spec for a field-scalar input form

Build a tib spec for a field-scalar input form

## Usage

``` r
.guess_vector_input_form_field_scalar(value, name, ptype)
```

## Arguments

- value:

  (`list`) An object list whose fields will be guessed.

- name:

  (`character(1)`) The name of the field.

- ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

## Value

A list with `can_simplify = TRUE` and `tib_spec`, a `tib_vector` field
specification.

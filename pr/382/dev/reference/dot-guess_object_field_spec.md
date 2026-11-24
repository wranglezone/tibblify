# Guess the field spec for a single object field

Dispatches to the appropriate helper based on the detected type of
`value`.

## Usage

``` r
.guess_object_field_spec(value, name, empty_list_unspecified, simplify_list)
```

## Arguments

- value:

  (`list`) An object list whose fields will be guessed.

- name:

  (`character(1)`) The name of the field.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- simplify_list:

  (`logical(1)`) Should scalar lists be simplified to vectors?

## Value

A tib field specification.

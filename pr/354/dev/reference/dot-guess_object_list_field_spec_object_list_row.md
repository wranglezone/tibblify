# Guess a row spec from an object list field

Guess a row spec from an object list field

## Usage

``` r
.guess_object_list_field_spec_object_list_row(
  value,
  name,
  empty_list_unspecified,
  simplify_list,
  local_env
)
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

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

A [`tib_row()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
spec.

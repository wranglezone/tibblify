# Guess the field spec for a data-frame-typed field

Guess the field spec for a data-frame-typed field

## Usage

``` r
.guess_object_field_spec_df(value, name, empty_list_unspecified, local_env)
```

## Arguments

- value:

  (`list`) An object list whose fields will be guessed.

- name:

  (`character(1)`) The name of the field.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

A `tib_df` field specification.

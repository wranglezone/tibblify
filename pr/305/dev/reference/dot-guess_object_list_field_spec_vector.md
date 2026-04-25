# Guess the spec for a vector-typed field in an object list

Guess the spec for a vector-typed field in an object list

## Usage

``` r
.guess_object_list_field_spec_vector(
  value,
  name,
  ptype,
  had_empty_lists,
  local_env
)
```

## Arguments

- value:

  (`list`) An object list whose fields will be guessed.

- name:

  (`character(1)`) The name of the field.

- ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

- had_empty_lists:

  (`logical(1)` or `NULL`) Whether empty lists were dropped when
  computing the common ptype.

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

A
[`tib_scalar()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
or
[`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
spec.

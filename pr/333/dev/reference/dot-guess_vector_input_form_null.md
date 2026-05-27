# Guess input form for a list field whose common ptype is `NULL`

Guess input form for a list field whose common ptype is `NULL`

## Usage

``` r
.guess_vector_input_form_null(value, name)
```

## Arguments

- value:

  (`list`) An object list whose fields will be guessed.

- name:

  (`character(1)`) The name of the field.

## Value

A list with:

- `can_simplify` (`logical(1)`): Whether the field can be simplified.

- `tib_spec`: A tib field specification (present only when
  `can_simplify` is `TRUE`).

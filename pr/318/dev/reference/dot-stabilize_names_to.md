# Stabilize names_to argument

Stabilize names_to argument

## Usage

``` r
.stabilize_names_to(.names_to, .values_to, .input_form, .call)
```

## Arguments

- .names_to:

  (`character(1)` or `NULL`) What to do with the inner names of the
  object. Can be one of:

  - `NULL`: the default. The inner names of the field are not used.

  - A string: Use only if the input form is `"object"` or `"vector"`,
    and `.values_to` is a string. The inner names of the field will
    populate the specified column in the field's tibble.

- .values_to:

  (`character(1)` or `NULL`) For `NULL` (the default), the field is
  converted to a `.ptype` vector. If a string is provided, the field is
  converted to a tibble and the values go into the specified column.

- .input_form:

  (`character(1)`) The structure of the input field. Can be one of:

  - `"vector"`: The field is a vector, e.g. `c(1, 2, 3)`.

  - `"scalar_list"`: The field is a list of scalars, e.g.
    `list(1, 2, 3)`.

  - `"object"`: The field is a named list of scalars, e.g.
    `list(a = 1, b = 2, c = 3)`.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`character(1)` or `NULL`) Validated `.names_to`.

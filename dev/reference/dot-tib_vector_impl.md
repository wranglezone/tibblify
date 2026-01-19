# Implementation of tib_vector

Implementation of tib_vector

## Usage

``` r
.tib_vector_impl(
  .key,
  .ptype,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = .ptype,
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  .class = NULL,
  .call = caller_env()
)
```

## Arguments

- .key:

  (`character`) The path of names to the field in the object.

- .ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

- .required:

  (`logical(1)`) Throw an error if the field does not exist?

- .fill:

  (`vector` or `NULL`) Optionally, a value to use if the field does not
  exist.

- .ptype_inner:

  (`vector(0)`) A prototype of the input field.

- .transform:

  (`function` or `NULL`) A function to apply to the whole vector after
  casting to `.ptype_inner`.

- .elt_transform:

  (`function` or `NULL`) A function to apply to each element before
  casting to `.ptype_inner`.

- .input_form:

  (`character(1)`) The structure of the input field. Can be one of:

  - `"vector"`: The field is a vector, e.g. `c(1, 2, 3)`.

  - `"scalar_list"`: The field is a list of scalars, e.g.
    `list(1, 2, 3)`.

  - `"object"`: The field is a named list of scalars, e.g.
    `list(a = 1, b = 2, c = 3)`.

- .values_to:

  (`character(1)` or `NULL`) For `NULL` (the default), the field is
  converted to a `.ptype` vector. If a string is provided, the field is
  converted to a tibble and the values go into the specified column.

- .names_to:

  (`character(1)` or `NULL`) What to do with the inner names of the
  object. Can be one of:

  - `NULL`: the default. The inner names of the field are not used.

  - A string: Use only if the input form is `"object"` or `"vector"`,
    and `.values_to` is a string. The inner names of the field will
    populate the specified column in the field's tibble.

- .class:

  (`character` or `NULL`) Additional classes for the collector.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`tib_vector`) A tibblify vector collector.

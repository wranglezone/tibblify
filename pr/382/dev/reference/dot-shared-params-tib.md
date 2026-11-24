# Shared tib_spec parameters

These parameters are used in multiple `tib_*()` functions. They are
defined here to make them easier to import and to find, and to make sure
the deprecated forms get documented identically when these definitions
are imported. This break-out is for parameters that differ between
`tib_*()` functions and other functions that use the same parameters.

## Arguments

- .input_form:

  (`character(1)`) The structure of the input field. Can be one of:

  - `"vector"`: The field is a vector, e.g. `c(1, 2, 3)`.

  - `"scalar_list"`: The field is a list of scalars, e.g.
    `list(1, 2, 3)`.

  - `"object"`: The field is a named list of scalars, e.g.
    `list(a = 1, b = 2, c = 3)`.

- .names_to:

  (`character(1)` or `NULL`) What to do with the inner names of the
  object. Can be one of:

  - `NULL`: the default. The inner names of the field are not used.

  - A string: Use only if the input form is `"object"` or `"vector"`,
    and `.values_to` is a string. The inner names of the field will
    populate the specified column in the field's tibble.

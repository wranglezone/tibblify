# Shared parameters

These parameters are used in multiple functions. They are defined here
to make them easier to import and to find.

## Arguments

- .children:

  A string giving the name of the field that contains the children.

- .children_to:

  A string giving the column name in which to store the children.

- .elt_transform:

  A function to apply to each element before casting to `.ptype_inner`.

- .fill:

  Optionally, a value to use if the field does not exist.

- .format:

  Optional, a string passed to the `format` argument of
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html).

- .key:

  The path to the field in the object, as a character vector.

- .ptype:

  A prototype of the desired output type of the field.

- .ptype_inner:

  A prototype of the field.

- .required:

  Throw an error if the field does not exist?

- .transform:

  A function to apply to the whole vector after casting to
  `.ptype_inner`.

- .values_to:

  Can be one of the following:

  - `NULL`: the default. The field is converted to a `.ptype` vector.

  - A string: The field is converted to a tibble and the values go into
    the specified column.

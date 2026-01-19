# Shared parameters

These parameters are used in multiple functions. They are defined here
to make them easier to import and to find.

## Arguments

- .call:

  (`environment`) The environment to use for error messages.

- .children:

  (`character(1)`) The name of the field that contains the children.

- .children_to:

  (`character(1)`) The column name in which to store the children.

- .elt_transform:

  (`function` or `NULL`) A function to apply to each element before
  casting to `.ptype_inner`.

- .fill:

  (`vector` or `NULL`) Optionally, a value to use if the field does not
  exist.

- .format:

  (`character(1)` or `NULL`) Passed to the `format` argument of
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html).

- .key:

  (`character`) The path of names to the field in the object.

- name:

  (`character(1)`) The name of the field.

- .ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

- .ptype_inner:

  (`vector(0)`) A prototype of the input field.

- .required:

  (`logical(1)`) Throw an error if the field does not exist?

- spec_list:

  (`list`) A list of specifications.

- tib_list:

  (`list`) A list of tib fields.

- .transform:

  (`function` or `NULL`) A function to apply to the whole vector after
  casting to `.ptype_inner`.

- .values_to:

  (`character(1)` or `NULL`) For `NULL` (the default), the field is
  converted to a `.ptype` vector. If a string is provided, the field is
  converted to a tibble and the values go into the specified column.

- x:

  (`any`) The object to check.

# Shared parameters

These parameters are used in multiple functions. They are defined here
to make them easier to import and to find.

## Arguments

- allow_null:

  (`logical(1)`) Whether `NULL` is accepted.

- arg:

  (`character(1)`) An argument name. This name will be mentioned in
  error messages as the input that is at the origin of a problem.

- .call:

  (`environment`) The environment to use for error messages.

- .children:

  (`character(1)`) The name of the field that contains the children.

- .children_to:

  (`character(1)`) The column name in which to store the children.

- col:

  (`any`) A column from a data frame, which may be a vector, a list, or
  a nested data frame.

- elt:

  (`character` or `integer`) An element of a path.

- .elt_transform:

  (`function` or `NULL`) A function to apply to each element before
  casting to `.ptype_inner`.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- env:

  (`environment`) The environment used to evaluate glue fields in
  `message`.

- .error_call:

  (`environment`) The environment to use for error messages.

- expr:

  (`any`) An expression to evaluate and return, with indexed errors
  wrapped.

- f_name:

  (`character(1)`) The (possibly ANSI-colored) function name.

- field_spec:

  (`tib_collector`) A tibblify field collector.

- .fill:

  (`vector` or `NULL`) Optionally, a value to use if the field does not
  exist.

- force_names:

  (`logical(1)`) Should names be printed even if they can be deduced
  from the spec?

- .format:

  (`character(1)` or `NULL`) Passed to the `format` argument of
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html).

- index:

  (`integer(1)`) A zero-based location in a path.

- inform_unspecified:

  (`logical(1)`) Inform about fields whose type could not be determined?

- input_form:

  (`character(1)`) The input form string used in error messages.

- .key:

  (`character`) The path of names to the field in the object.

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

- message:

  (`character`) A cli message template.

- multi_line:

  (`logical(1)`) Should the output be formatted across multiple lines?
  For example, should each element of even a short list be displayed on
  its own line?

- name:

  (`character(1)`) The name of the field.

- name_spec:

  (`character(1)`, `function`, or `NULL`) Name specification passed to
  [`vctrs::list_unchop()`](https://vctrs.r-lib.org/reference/list_unchop.html).

- names:

  (`logical(1)`) Should names be printed even if they can be deduced
  from the spec?

- nchar_indent:

  (`integer(1)`) The number of (additional) characters that will be used
  to indent the output when `multi_line = TRUE`. Primarily for internal
  use when formatting is applied recursively.

- path:

  (`list`) A path object encoded as a depth and a list of path elements.

- path_exp:

  (`list`) The path of the field used as the reference in size mismatch
  errors.

- .ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

- .ptype_inner:

  (`vector(0)`) A prototype of the input field.

- .required:

  (`logical(1)`) Throw an error if the field does not exist?

- simplify_list:

  (`logical(1)`) Should scalar lists be simplified to vectors?

- size_act:

  (`integer(1)`) The observed size of a field.

- size_exp:

  (`integer(1)`) The expected size of a field.

- spec:

  (`tspec` or `NULL`) A spec object describing the structure of `x`.

- spec_list:

  (`list`) A list of specifications.

- tib_list:

  (`list`) A list of tib fields.

- .transform:

  (`function` or `NULL`) A function to apply to the whole vector after
  casting to `.ptype_inner`.

- value:

  (`list`) An object list whose fields will be guessed.

- .values_to:

  (`character(1)` or `NULL`) For `NULL` (the default), the field is
  converted to a `.ptype` vector. If a string is provided, the field is
  converted to a tibble and the values go into the specified column.

- width:

  (`integer(1)`) The width (in number of characers) of text output to
  generate.

- x:

  (`any`) The object to check.

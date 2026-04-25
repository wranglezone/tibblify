#' Shared parameters
#'
#' These parameters are used in multiple functions. They are defined here to
#' make them easier to import and to find.
#'
#' @param allow_null (`logical(1)`) Whether `NULL` is accepted.
#' @param arg (`character(1)`) An argument name. This name will be mentioned in
#'   error messages as the input that is at the origin of a problem.
#' @param .call (`environment`) The environment to use for error messages.
#' @param .children (`character(1)`) The name of the field that contains the
#'   children.
#' @param .children_to (`character(1)`) The column name in which to store the
#'   children.
#' @param col (`any`) A column from a data frame, which may be a vector, a list,
#'   or a nested data frame.
#' @param elt (`character` or `integer`) An element of a path.
#' @param .elt_transform (`function` or `NULL`) A function to apply to each
#'   element before casting to `.ptype_inner`.
#' @param empty_list_unspecified (`logical(1)`) Treat empty lists as
#'   unspecified?
#' @param env (`environment`) The environment used to evaluate glue fields in
#'   `message`.
#' @param .error_call (`environment`) The environment to use for error messages.
#' @param expr (`any`) An expression to evaluate and return, with indexed errors
#'   wrapped.
#' @param f_name (`character(1)`) The (possibly ANSI-colored) function name.
#' @param field_spec (`tib_collector`) A tibblify field collector.
#' @param .fill (`vector` or `NULL`) Optionally, a value to use if the field
#'   does not exist.
#' @param force_names (`logical(1)`) Should names be printed even if they can be
#'   deduced from the spec?
#' @param .format (`character(1)` or `NULL`) Passed to the `format` argument of
#'   [as.Date()].
#' @param index (`integer(1)`) A zero-based location in a path.
#' @param inform_unspecified (`logical(1)`) Inform about fields whose type could
#'   not be determined?
#' @param input_form (`character(1)`) The input form string used in error
#'   messages.
#' @param .key (`character`) The path of names to the field in the object.
#' @param local_env (`environment`) A local environment used to track state
#'   across recursive calls, such as whether empty lists were encountered.
#' @param message (`character`) A cli message template.
#' @param multi_line (`logical(1)`) Should the output be formatted across
#'   multiple lines? For example, should each element of even a short list be
#'   displayed on its own line?
#' @param name (`character(1)`) The name of the field.
#' @param name_spec (`character(1)`, `function`, or `NULL`) Name specification
#'   passed to [vctrs::list_unchop()].
#' @param names (`logical(1)`) Should names be printed even if they can be
#'   deduced from the spec?
#' @param nchar_indent (`integer(1)`) The number of (additional) characters that
#'   will be used to indent the output when `multi_line = TRUE`. Primarily for
#'   internal use when formatting is applied recursively.
#' @param path (`list`) A path object encoded as a depth and a list of path
#'   elements.
#' @param path_exp (`list`) The path of the field used as the reference in size
#'   mismatch errors.
#' @param .ptype (`vector(0)`) A prototype of the desired output type of the
#'   field.
#' @param .ptype_inner (`vector(0)`) A prototype of the input field.
#' @param .required (`logical(1)`) Throw an error if the field does not exist?
#' @param simplify_list (`logical(1)`) Should scalar lists be simplified to
#'   vectors?
#' @param size_act (`integer(1)`) The observed size of a field.
#' @param size_exp (`integer(1)`) The expected size of a field.
#' @param spec (`tspec` or `NULL`) A spec object describing the structure of
#'   `x`.
#' @param spec_list (`list`) A list of specifications.
#' @param tib_list (`list`) A list of tib fields.
#' @param .transform (`function` or `NULL`) A function to apply to the whole
#'   vector after casting to `.ptype_inner`.
#' @param value (`list`) An object list whose fields will be guessed.
#' @param .values_to (`character(1)` or `NULL`) For `NULL` (the default), the
#'   field is converted to a `.ptype` vector. If a string is provided, the field
#'   is converted to a tibble and the values go into the specified column.
#' @param width (`integer(1)`) The width (in number of characers) of text output
#'   to generate.
#' @param x (`any`) The object to check.
#'
#' @name .shared-params
#' @keywords internal
NULL

#' Shared tib_spec parameters
#'
#' These parameters are used in multiple `tib_*()` functions. They are defined
#' here to make them easier to import and to find, and to make sure the
#' deprecated forms get documented identically when these definitions are
#' imported. This break-out is for parameters that differ between `tib_*()`
#' functions and other functions that use the same parameters.
#'
#' @param .input_form (`character(1)`) The structure of the input field. Can be
#'   one of:
#'   * `"vector"`: The field is a vector, e.g. `c(1, 2, 3)`.
#'   * `"scalar_list"`: The field is a list of scalars, e.g. `list(1, 2, 3)`.
#'   * `"object"`: The field is a named list of scalars, e.g.
#'   `list(a = 1, b = 2, c = 3)`.
#' @param .names_to (`character(1)` or `NULL`) What to do with the inner names
#'   of the object. Can be one of:
#'   * `NULL`: the default. The inner names of the field are not used.
#'   * A string: Use only if the input form is `"object"` or `"vector"`, and `.values_to` is a string. The inner names of the field will populate the
#'   specified column in the field's tibble.
#'
#' @name .shared-params-tib
#' @keywords internal
NULL

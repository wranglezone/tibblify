#' Shared parameters
#'
#' These parameters are used in multiple functions. They are defined here to
#' make them easier to import and to find.
#'
#' @param .call (`environment`) The environment to use for error messages.
#' @param .children (`character(1)`) The name of the field that contains the
#'   children.
#' @param .children_to (`character(1)`) The column name in which to store the
#'   children.
#' @param .elt_transform (`function` or `NULL`) A function to apply to each
#'   element before casting to `.ptype_inner`.
#' @param .fill (`vector` or `NULL`) Optionally, a value to use if the field
#'   does not exist.
#' @param .format (`character(1)` or `NULL`) Passed to the `format` argument of
#'   [as.Date()].
#' @param .key (`character`) The path of names to the field in the object.
#' @param name (`character(1)`) The name of the field.
#' @param .ptype (`vector(0)`) A prototype of the desired output type of the
#'   field.
#' @param .ptype_inner (`vector(0)`) A prototype of the input field.
#' @param .required (`logical(1))` Throw an error if the field does not exist?
#' @param spec_list (`list`) A list of specifications.
#' @param tib_list (`list`) A list of tib fields.
#' @param .transform (`function` or `NULL`) A function to apply to the whole
#'   vector after casting to `.ptype_inner`.
#' @param .values_to (`character(1)` or `NULL`) For `NULL` (the default), the
#'   field is converted to a `.ptype` vector. If a string is provided, the field
#'   is converted to a tibble and the values go into the specified column.
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
#'   * A string: Use only if 1) the input form is `"object"` or `"vector"` and
#'   2) `.values_to` is a string. The inner names of the field will populate the
#'   specified column in the field's tibble.
#'
#' @name .shared-params-tib
#' @keywords internal
NULL

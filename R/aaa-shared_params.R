#' Shared parameters
#'
#' These parameters are used in multiple functions. They are defined here to
#' make them easier to import and to find.
#'
#' @param .children A string giving the name of the field that contains the
#'   children.
#' @param .children_to A string giving the column name in which to store the
#'   children.
#' @param .elt_transform A function to apply to each element before casting to
#'   `.ptype_inner`.
#' @param .fill Optionally, a value to use if the field does not exist.
#' @param .format Optional, a string passed to the `format` argument of
#'   `as.Date()`.
#' @param .key The path to the field in the object, as a character vector.
#' @param .ptype A prototype of the desired output type of the field.
#' @param .ptype_inner A prototype of the field.
#' @param .required Throw an error if the field does not exist?
#' @param .transform A function to apply to the whole vector after casting to
#'   `.ptype_inner`.
#' @param .values_to Can be one of the following:
#'   * `NULL`: the default. The field is converted to a `.ptype` vector.
#'   * A string: The field is converted to a tibble and the values go into the
#'   specified column.
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
#' @param .input_form A string that describes the structure of the field. Can be
#'   one of:
#'   * `"vector"`: The field is a vector, e.g. `c(1, 2, 3)`.
#'   * `"scalar_list"`: The field is a list of scalars, e.g. `list(1, 2, 3)`.
#'   * `"object"`: The field is a named list of scalars, e.g. `list(a = 1, b = 2, c = 3)`.
#' @param .names_to What to do with the inner names of the object. Can be one
#'   of:
#'   * `NULL`: the default. The inner names of the field are not used.
#'   * A string: This can only be used if 1) the input form is `"object"`
#'   or `"vector"` and 2) `.values_to` is a string. The inner names of the field
#'   will populate the specified column in the field's tibble.
#'
#' @name .shared-params-tib
#' @keywords internal
NULL

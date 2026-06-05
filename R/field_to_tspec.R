#' Elevate a field to a tspec
#'
#' Extract a nested field from a `tspec` and convert it to a top-level
#' `tspec_*()` object. `field_to_tspec()` dispatches to the appropriate
#' variant based on the type of the field. Use `field_to_tspec_df()`,
#' `field_to_tspec_row()`, or `field_to_tspec_recursive()` to extract a field
#' of a specific type.
#'
#' @param spec (`tspec`) A tibblify specification.
#' @inheritParams .shared-params
#'
#' @returns A tibblify specification (`tspec_df`, `tspec_row`, or
#'   `tspec_recursive`).
#' @export
#'
#' @examples
#' spec <- tspec_df(
#'   tib_int("id"),
#'   tib_df(
#'     "address",
#'     tib_chr("street"),
#'     tib_chr("city")
#'   )
#' )
#'
#' field_to_tspec(spec, "address")
#' field_to_tspec_df(spec, "address")
field_to_tspec <- function(spec, name) {
  .check_field_exists(spec, name)
  field <- spec$fields[[name]]
  if (!field$type %in% c("df", "row", "recursive")) {
    cli::cli_abort(
      c(
        "Field {.field {name}} must be a {.fn tib_df}, {.fn tib_row}, or {.fn tib_recursive} field.",
        x = "Field {.field {name}} is a {.fn tib_{field$type}} field."
      )
    )
  }
  switch(
    field$type,
    df = field_to_tspec_df(spec, name),
    row = field_to_tspec_row(spec, name),
    recursive = field_to_tspec_recursive(spec, name)
  )
}

#' @rdname field_to_tspec
#' @export
field_to_tspec_df <- function(spec, name) {
  field <- .get_field_of_type(spec, name, "df", "tib_df")
  tspec_df(
    !!!field$fields,
    .names_to = field$names_col,
    .vector_allows_empty_list = spec$vector_allows_empty_list
  )
}

#' @rdname field_to_tspec
#' @export
field_to_tspec_row <- function(spec, name) {
  field <- .get_field_of_type(spec, name, "row", "tib_row")
  tspec_row(
    !!!field$fields,
    .vector_allows_empty_list = spec$vector_allows_empty_list
  )
}

#' @rdname field_to_tspec
#' @export
field_to_tspec_recursive <- function(spec, name) {
  field <- .get_field_of_type(spec, name, "recursive", "tib_recursive")
  tspec_recursive(
    !!!field$fields,
    .children = field$child,
    .children_to = field$children_to,
    .vector_allows_empty_list = spec$vector_allows_empty_list
  )
}

# helpers ----------------------------------------------------------------------

#' Check that a field exists in spec and extract it
#'
#' @param type (`character(1)`) The expected field type string.
#' @param fn_name (`character(1)`) The name of the tib constructor function
#'   for use in error messages.
#' @inheritParams .shared-params
#' @returns (`tib_collector`) The field spec.
#' @keywords internal
.get_field_of_type <- function(
  spec,
  name,
  type,
  fn_name,
  .call = caller_env()
) {
  .check_field_exists(spec, name, .call)
  field <- spec$fields[[name]]
  if (field$type != type) {
    cli::cli_abort(
      c(
        "Field {.field {name}} must be a {.fn {fn_name}} field.",
        x = "Field {.field {name}} is a {.fn tib_{field$type}} field."
      ),
      call = .call
    )
  }
  field
}

#' Check that a named field exists in a spec
#'
#' @inheritParams .shared-params
#' @returns `NULL` (invisibly). Throws an error if the field does not exist.
#' @keywords internal
.check_field_exists <- function(spec, name, .call = caller_env()) {
  if (!.is_tspec(spec)) {
    cli::cli_abort(
      "{.arg spec} must be a tibblify spec.",
      call = .call
    )
  }
  rlang::check_string(name, call = .call)
  if (!name %in% names(spec$fields)) {
    cli::cli_abort(
      "Field {.field {name}} doesn't exist in {.arg spec}.",
      call = .call
    )
  }
  invisible(NULL)
}

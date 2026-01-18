#' Unpack a tibblify specification
#'
#' [tidyr::unpack()] makes data wider by expanding df-columns into individual
#' columns. Analogously, unpacking a tibblify specification makes a
#' specification which will result in a wider tibble by expanding [tib_row()]
#' specifications into their individual fields.
#'
#' @param spec (`tspec`) A tibblify specification.
#' @param ... These dots are for future extensions and must be empty.
#' @param fields (`character` or `NULL`) The fields to unpack. If `fields` is
#'   `NULL` (default), all fields are unpacked.
#' @param recurse (`logical(1)`) Should fields inside other fields be unpacked?
#' @param names_sep (`character(1)` or `NULL`) If `NULL`, the default, the inner
#'   names of fields are used. If a string, the outer and inner names are pasted
#'   together, separated by `names_sep`.
#' @param names_repair (`character(1)` or `function`) Passed to the `repair`
#'   argument of [vctrs::vec_as_names()] to check that the output data frame has
#'   valid names. Must be one of the following options:
#'
#'   * `"unique"` (the default) or `"unique_quiet"`: make sure names are unique
#'   and not empty,
#'   * `"universal"` or `"universal_quiet"`: make the names unique and syntactic
#'   * `"check_unique"`: no name repair, but check they are unique,
#'   * a function: apply custom name repair.
#' @param names_clean (`function`) A one-argument function to clean names after
#'   repairing. For example use [camel_case_to_snake_case()].
#'
#' @return A tibblify spec.
#' @export
#'
#' @examples
#' spec <- tspec_df(
#'   tib_lgl("a"),
#'   tib_row("x", tib_int("b"), tib_chr("c")),
#'   tib_row("y", tib_row("z", tib_chr("d")))
#' )
#' unpack_tspec(spec)
#' # only unpack `x`
#' unpack_tspec(spec, fields = "x")
#' # do not unpack the fields in `y`
#' unpack_tspec(spec, recurse = FALSE)
unpack_tspec <- function(
  spec,
  ...,
  fields = NULL,
  recurse = TRUE,
  names_sep = NULL,
  names_repair = c(
    "unique",
    "universal",
    "check_unique",
    "unique_quiet",
    "universal_quiet"
  ),
  names_clean = NULL
) {
  rlang::check_dots_empty()
  check_character(fields, allow_null = TRUE)
  names_repair <- rlang::arg_match(names_repair)
  check_function(names_clean, allow_null = TRUE)
  spec$fields <- .unpack_fields(
    spec,
    fields,
    recurse,
    names_sep,
    names_repair,
    names_clean
  )
  return(spec)
}

# helpers ----------------------------------------------------------------------

#' Unpack and repair fields
#'
#' @inheritParams unpack_tspec
#' @inheritParams .shared-params
#' @returns (`list`) A list of unpacked fields.
#' @keywords internal
.unpack_fields <- function(
  spec,
  fields,
  recurse,
  names_sep,
  names_repair,
  names_clean,
  .call = caller_env()
) {
  .unpack_fields_impl(
    spec,
    fields,
    recurse,
    names_sep,
    names_repair,
    names_clean,
    .call
  ) |>
    .unchop_fields(names_repair, names_clean, .call)
}

#' Unpack all fields in a spec
#'
#' @inheritParams unpack_tspec
#' @inheritParams .shared-params
#' @returns (`list`) A list of unpacked fields (still nested in a list
#'   structure).
#' @keywords internal
.unpack_fields_impl <- function(
  spec,
  fields,
  recurse,
  names_sep,
  names_repair,
  names_clean,
  .call = caller_env()
) {
  check_bool(recurse, call = .call)
  check_string(names_sep, allow_null = TRUE, call = .call)
  fields_to_unpack <- .stabilize_unpack_cols(fields, spec, .call)
  .with_indexed_errors(
    purrr::imap(
      spec$fields,
      \(field, name) {
        if (!name %in% fields_to_unpack) {
          return(rlang::set_names(list(field), name))
        }
        .unpack_field(
          field,
          recurse = recurse,
          name = name,
          names_sep = names_sep,
          names_repair = names_repair,
          names_clean = names_clean,
          .call = .call
        )
      }
    ),
    message = "In field {.field {cnd$name}}.",
    error_call = .call
  )
}

#' Check which fields to unpack
#'
#' @param fields (`character` or `NULL`) The fields to unpack.
#' @param spec (`tspec`) A tibblify specification.
#' @inheritParams .shared-params
#' @returns (`character`) The names of the fields to unpack.
#' @keywords internal
.stabilize_unpack_cols <- function(fields, spec, .call = caller_env()) {
  known_fields <- names(spec$fields)
  fields <- fields %||% known_fields
  missing_fields <- setdiff(fields, known_fields)
  if (is_empty(missing_fields)) {
    return(fields)
  }
  cli_abort(
    c(
      "Can't unpack fields that don't exist.",
      "Field{?s} {.field {missing_fields}} {?doesn/don}'t exist."
    ),
    call = .call
  )
}

#' Unpack a single field
#'
#' @param field_spec (`tib_collector`) A tibblify field collector.
#' @param name (`character(1)`) The name of the field.
#' @inheritParams unpack_tspec
#' @inheritParams .shared-params
#' @returns (`list`) A list of unpacked fields.
#' @keywords internal
.unpack_field <- function(
  field_spec,
  recurse,
  name,
  names_sep,
  names_repair,
  names_clean,
  .call
) {
  if (recurse && field_spec$type %in% c("row", "df")) {
    field_spec <- .unpack_field_recursive(
      field_spec,
      recurse,
      names_sep,
      names_repair,
      names_clean,
      .call
    )
  }
  if (field_spec$type != "row") {
    return(rlang::set_names(list(field_spec), name))
  }
  .unpack_field_row(field_spec, name, names_sep)
}

#' Recursively unpack a field
#'
#' @inheritParams .unpack_field
#' @returns (`tib_collector`) The field spec with updated sub-fields.
#' @keywords internal
.unpack_field_recursive <- function(
  field_spec,
  recurse,
  names_sep,
  names_repair,
  names_clean,
  .call
) {
  field_spec$fields <- .unpack_fields(
    field_spec,
    NULL,
    recurse,
    names_sep,
    names_repair,
    names_clean,
    .call
  )
  field_spec
}

#' Unpack a row field
#'
#' @inheritParams .unpack_field
#' @returns (`list`) A list of unpacked fields from the row spec.
#' @keywords internal
.unpack_field_row <- function(field_spec, name, names_sep) {
  row_fields <- purrr::map(
    field_spec$fields,
    \(row_field) .unpack_key(row_field, field_spec$key)
  )
  if (length(names_sep)) {
    names(row_fields) <- paste(name, names(row_fields), sep = names_sep)
  }
  return(row_fields)
}

#' Update the key of an unpacked field
#'
#' @param field (`tib_collector`) The field spec being unpacked.
#' @param key (`character`) The key to prepend.
#' @returns (`tib_collector`) The field with updated key.
#' @keywords internal
.unpack_key <- function(field, key) {
  field$key <- c(key, field$key)
  field
}

#' Unchop and repair fields
#'
#' @inheritParams unpack_tspec
#' @inheritParams .shared-params
#' @returns (`list`) A list of unchopped and repaired fields.
#' @keywords internal
.unchop_fields <- function(
  fields,
  names_repair,
  names_clean,
  .call = caller_env()
) {
  fields <- vctrs::list_unchop(
    fields,
    name_spec = "{inner}",
    name_repair = names_repair,
    error_call = .call
  )
  if (!is.null(names_clean)) {
    names(fields) <- names_clean(names(fields))
  }
  return(fields)
}

#' Convert CamelCase to snake_case
#'
#' @param x (`character`) CamelCase text to convert to snake_case.
#' @export
#' @rdname unpack_tspec
#' @examples
#' camel_case_to_snake_case(c("ExampleText", "otherTextToConvert"))
camel_case_to_snake_case <- function(x) {
  tolower(gsub("([A-Z]+)", "_\\1", x))
}

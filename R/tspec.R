#' Create a tibblify specification
#'
#' Use `tspec_df()` to specify how to convert a list of objects to a tibble. Use
#' `tspec_row()` to specify how to convert an object to a one-row tibble. Use
#' `tspec_object()` to specify how to convert an object to a list.
#'
#' @details In column-major format, all fields are required, regardless of the
#'   `.required` argument.
#'
#' @param ... (`tib_collector` or `tspec`) Column specifications created by
#'   `tib_*()` or `tspec_*()`. If the dots are named, the name will be used for
#'   the resulting column. Otherwise, the name of the input will be used for the
#'   column name.
#' @param .input_form (`character(1)`) The input form of data-frame-like lists.
#'   Can be one of:
#'   * `"rowmajor"`: The default. The input is a named list of rows.
#'   * `"colmajor"`: The input is a named list of columns.
#' @param .names_to (`character(1)` or `NULL`) The name of the column in the
#'   output which will contain the names of top-level elements of the input
#'   named list. If `NULL`, the default, no name column is created.
#' @param .vector_allows_empty_list,vector_allows_empty_list (`logical(1)`)
#'   Should empty lists for columns with `.input_form = "vector"` be accepted
#'   and treated as empty vectors?
#' @inheritParams .shared-params
#'
#' @returns A tibblify specification.
#' @export
#' @examples
#' tspec_df(
#'   id = tib_int("id"),
#'   name = tib_chr("name"),
#'   aliases = tib_chr_vec("aliases")
#' )
#'
#' # Equivalent to
#' tspec_df(
#'   tib_int("id"),
#'   tib_chr("name"),
#'   tib_chr_vec("aliases")
#' )
#'
#' # To create multiple columns of the same type use the bang-bang-bang (`!!!`)
#' # operator together with `purrr::map()`
#' tspec_df(
#'   !!!purrr::map(purrr::set_names(c("id", "age")), tib_int),
#'   !!!purrr::map(purrr::set_names(c("name", "title")), tib_chr)
#' )
#'
#' # The `tspec_*()` functions can also be nested
#' spec1 <- tspec_object(
#'   int = tib_int("int"),
#'   chr = tib_chr("chr")
#' )
#' spec2 <- tspec_object(
#'   int2 = tib_int("int2"),
#'   chr2 = tib_chr("chr2")
#' )
#'
#' tspec_df(spec1, spec2)
tspec_df <- function(
  ...,
  .input_form = c("rowmajor", "colmajor"),
  .names_to = NULL,
  .vector_allows_empty_list = FALSE,
  vector_allows_empty_list = deprecated()
) {
  .input_form <- arg_match0(.input_form, c("rowmajor", "colmajor"))
  .vector_allows_empty_list <- .deprecate_arg(
    .vector_allows_empty_list,
    vector_allows_empty_list
  )
  .check_names_to(.names_to, .input_form)

  out <- .tspec(
    list2(...),
    "df",
    .input_form = .input_form,
    .names_col = .names_to,
    .vector_allows_empty_list = .vector_allows_empty_list
  )
  if (!is.null(.names_to) && .names_to %in% names(out$fields)) {
    msg <- "The column name of {.arg .names_to} is already specified in {.arg ...}."
    cli::cli_abort(msg)
  }

  out
}

#' @rdname tspec_df
#' @export
tspec_object <- function(
  ...,
  .input_form = c("rowmajor", "colmajor"),
  .vector_allows_empty_list = FALSE,
  vector_allows_empty_list = deprecated()
) {
  .input_form <- arg_match0(.input_form, c("rowmajor", "colmajor"))
  .vector_allows_empty_list <- .deprecate_arg(
    .vector_allows_empty_list,
    vector_allows_empty_list
  )
  .tspec(
    list2(...),
    "object",
    .input_form = .input_form,
    .vector_allows_empty_list = .vector_allows_empty_list
  )
}

#' @rdname tspec_df
#' @export
tspec_row <- function(
  ...,
  .input_form = c("rowmajor", "colmajor"),
  .vector_allows_empty_list = FALSE,
  vector_allows_empty_list = deprecated()
) {
  .input_form <- arg_match0(.input_form, c("rowmajor", "colmajor"))
  .tspec(
    list2(...),
    "row",
    .input_form = .input_form,
    .vector_allows_empty_list = .vector_allows_empty_list
  )
}

#' @rdname tspec_df
#' @export
tspec_recursive <- function(
  ...,
  .children,
  .children_to = .children,
  .input_form = c("rowmajor", "colmajor"),
  .vector_allows_empty_list = FALSE,
  vector_allows_empty_list = deprecated()
) {
  .input_form <- arg_match0(.input_form, c("rowmajor", "colmajor"))
  .vector_allows_empty_list <- .deprecate_arg(
    .vector_allows_empty_list,
    vector_allows_empty_list
  )
  check_string(.children)
  check_string(.children_to)
  # TODO check that key is unique

  .tspec(
    list2(...),
    "recursive",
    child = .children,
    children_to = .children_to,
    .input_form = .input_form,
    .vector_allows_empty_list = .vector_allows_empty_list
  )
}

# helpers ----------------------------------------------------------------------

.check_names_to <- function(.names_to, .input_form, .call = caller_env()) {
  if (!is.null(.names_to)) {
    if (.input_form == "colmajor") {
      msg <- 'Can\'t use {.arg .names_to} with {.code .input_form = "colmajor"}.'
      cli::cli_abort(msg, call = .call)
    }
    check_string(.names_to, allow_null = TRUE, call = .call)
  }
}

.tspec <- function(
  .fields,
  .type,
  ...,
  .vector_allows_empty_list = FALSE,
  .error_call = caller_env()
) {
  check_bool(.vector_allows_empty_list, call = .error_call)

  out <- list2(
    type = .type,
    fields = .prep_spec_fields(.fields, .error_call),
    ...,
    vector_allows_empty_list = .vector_allows_empty_list
  )

  # We don't want to maintain dotted names past here.
  names(out) <- sub("^\\.", "", names(out))

  class(out) <- c(paste0("tspec_", .type), "tspec")
  out
}

## .tspec helpers --------------------------------------------------------------

.prep_spec_fields <- function(.fields, .error_call) {
  .fields <- .flatten_fields(.fields)
  if (is.null(.fields)) {
    return(list())
  }

  for (i in seq_along(.fields)) {
    field <- .fields[[i]]
    if (.is_tib(field)) {
      next
    }

    name <- names2(.fields)[[i]]
    if (name == "") {
      name <- paste0("..", i)
    }
    friendly_type <- obj_type_friendly(.fields[[i]])

    msg <- "{.field {name}} must be a tib collector, not {friendly_type}."
    cli::cli_abort(msg, call = .error_call)
  }

  .spec_auto_name_fields(.fields, .error_call)
}

.flatten_fields <- function(.fields) {
  ns <- lengths(.fields)
  .fields <- .fields[ns != 0]
  for (i in seq_along(.fields)) {
    field_i <- .fields[[i]]
    if (.is_tspec(field_i)) {
      .fields[[i]] <- field_i$fields
    } else {
      .fields[[i]] <- list(field_i)
    }
  }

  vctrs::vec_c(!!!.fields, .name_spec = "{inner}")
}

.is_tspec <- function(x) {
  inherits(x, "tspec")
}

.spec_auto_name_fields <- function(.fields, .error_call) {
  field_nms <- rlang::names2(.fields)
  unnamed <- !rlang::have_name(.fields)
  auto_nms <- .with_indexed_errors(
    .compat_map_chr(
      .fields[unnamed],
      function(field) {
        key <- field$key
        if (!is_string(key)) {
          msg <- c(
            "{.arg key} must be a single string to infer name.",
            x = "{.arg key} has length {length(key)}."
          )
          cli::cli_abort(msg, call = NULL)
        }

        key
      }
    ),
    message = "In field {cnd$location}.",
    error_call = .error_call
  )
  field_nms[unnamed] <- auto_nms
  field_nms_repaired <- vctrs::vec_as_names(
    field_nms,
    repair = "check_unique",
    call = .error_call
  )
  names(.fields) <- field_nms_repaired
  .fields
}

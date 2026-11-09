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
#' @param .vector_allows_empty_list,vector_allows_empty_list
#'   `r lifecycle::badge("deprecated")` Deprecated as of tibblify 0.5.0. Empty
#'   lists are now always accepted for vector fields. A required field treats
#'   `list()` as an empty vector, and an optional field uses `.fill`.
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
#'   !!!purrr::map(rlang::set_names(c("id", "age")), tib_int),
#'   !!!purrr::map(rlang::set_names(c("name", "title")), tib_chr)
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
  .duplicate_keys = c("error", "warn", "allow"),
  .vector_allows_empty_list = deprecated(),
  vector_allows_empty_list = deprecated()
) {
  .input_form <- arg_match0(.input_form, c("rowmajor", "colmajor"))
  .duplicate_keys <- rlang::arg_match(.duplicate_keys)
  .deprecate_vector_allows_empty_list(
    .vector_allows_empty_list,
    vector_allows_empty_list
  )
  .check_names_to(.names_to, .input_form)

  out <- .tspec(
    list2(...),
    "df",
    .input_form = .input_form,
    .names_col = .names_to,
    .duplicate_keys = .duplicate_keys
  )
  if (!is.null(.names_to) && .names_to %in% names(out$fields)) {
    cli::cli_abort(
      "The column name of {.arg .names_to} is already specified in {.arg ...}."
    )
  }

  out
}

#' @rdname tspec_df
#' @export
tspec_object <- function(
  ...,
  .input_form = c("rowmajor", "colmajor"),
  .duplicate_keys = c("error", "warn", "allow"),
  .vector_allows_empty_list = deprecated(),
  vector_allows_empty_list = deprecated()
) {
  .input_form <- arg_match0(.input_form, c("rowmajor", "colmajor"))
  .duplicate_keys <- rlang::arg_match(.duplicate_keys)
  .deprecate_vector_allows_empty_list(
    .vector_allows_empty_list,
    vector_allows_empty_list
  )
  .tspec(
    list2(...),
    "object",
    .input_form = .input_form,
    .duplicate_keys = .duplicate_keys
  )
}

#' @rdname tspec_df
#' @export
tspec_row <- function(
  ...,
  .input_form = c("rowmajor", "colmajor"),
  .duplicate_keys = c("error", "warn", "allow"),
  .vector_allows_empty_list = deprecated(),
  vector_allows_empty_list = deprecated()
) {
  .input_form <- arg_match0(.input_form, c("rowmajor", "colmajor"))
  .duplicate_keys <- rlang::arg_match(.duplicate_keys)
  .deprecate_vector_allows_empty_list(
    .vector_allows_empty_list,
    vector_allows_empty_list
  )
  .tspec(
    list2(...),
    "row",
    .input_form = .input_form,
    .duplicate_keys = .duplicate_keys
  )
}

#' @rdname tspec_df
#' @export
tspec_recursive <- function(
  ...,
  .children,
  .children_to = .children,
  .input_form = c("rowmajor", "colmajor"),
  .duplicate_keys = c("error", "warn", "allow"),
  .vector_allows_empty_list = deprecated(),
  vector_allows_empty_list = deprecated()
) {
  .input_form <- arg_match0(.input_form, c("rowmajor", "colmajor"))
  .duplicate_keys <- rlang::arg_match(.duplicate_keys)
  .deprecate_vector_allows_empty_list(
    .vector_allows_empty_list,
    vector_allows_empty_list
  )
  rlang::check_string(.children)
  rlang::check_string(.children_to)

  out <- .tspec(
    list2(...),
    "recursive",
    child = .children,
    children_to = .children_to,
    .input_form = .input_form,
    .duplicate_keys = .duplicate_keys
  )
  .check_recursive_children(
    out$fields,
    .children,
    .children_to,
    .duplicate_keys
  )

  out
}

#' Deprecate the `vector_allows_empty_list` arguments
#'
#' Empty lists are now always accepted, so the arguments have no effect.
#'
#' @param dotted,undotted The values of `.vector_allows_empty_list` and
#'   `vector_allows_empty_list`.
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly.
#' @keywords internal
.deprecate_vector_allows_empty_list <- function(
  dotted,
  undotted,
  fn_name = rlang::call_name(rlang::caller_call()),
  user_env = rlang::caller_env(2)
) {
  args <- c(
    .vector_allows_empty_list = lifecycle::is_present(dotted),
    vector_allows_empty_list = lifecycle::is_present(undotted)
  )
  # nocov start
  for (arg in names(args)[args]) {
    lifecycle::deprecate_warn(
      "0.5.0",
      paste0(fn_name, "(", arg, ")"),
      details = "Empty lists are now always accepted for vector fields.",
      user_env = user_env
    )
  }
  # nocov end
  invisible(NULL)
}

#' Check that `.names_to` is valid for the given input form
#'
#' @inheritParams tspec_df
#' @inheritParams .shared-params
#' @returns `NULL` (invisibly).
#' @keywords internal
.check_names_to <- function(.names_to, .input_form, .call = caller_env()) {
  if (!is.null(.names_to)) {
    if (.input_form == "colmajor") {
      cli::cli_abort(
        'Can\'t use {.arg .names_to} with {.code .input_form = "colmajor"}.',
        call = .call
      )
    }
    rlang::check_string(.names_to, allow_null = TRUE, call = .call)
  }
}

#' Create a tibblify specification object
#'
#' @param .fields (`list`) A list of field specifications, typically created by
#'   `tib_*()`.
#' @param .type (`character(1)`) The type of specification being created
#'   (`"df"`, `"object"`, `"row"`, or `"recursive"`).
#' @param ... Additional specification attributes passed to [rlang::list2()].
#' @inheritParams .shared-params
#' @returns A `tspec` object with class `tspec_<type>` and `tspec`.
#' @keywords internal
.tspec <- function(
  .fields,
  .type,
  ...,
  .duplicate_keys = "error",
  .error_call = caller_env()
) {
  out <- list2(
    type = .type,
    fields = .prep_spec_fields(.fields, .duplicate_keys, .error_call),
    ...
  )

  # We don't want to maintain dotted names past here.
  names(out) <- sub("^\\.", "", names(out))

  class(out) <- c(paste0("tspec_", .type), "tspec")
  out
}

## .tspec helpers --------------------------------------------------------------

#' Flatten, validate, and auto-name field specifications
#'
#' @inheritParams .tspec
#' @inheritParams .shared-params
#' @returns A named list of validated field specifications.
#' @keywords internal
.prep_spec_fields <- function(
  .fields,
  .duplicate_keys = "error",
  .error_call = caller_env()
) {
  .fields <- .flatten_fields(.fields)
  if (is.null(.fields)) {
    return(list())
  }

  for (i in seq_along(.fields)) {
    field <- .fields[[i]]
    if (.is_tib(field)) {
      next
    }

    name <- rlang::names2(.fields)[[i]]
    if (name == "") {
      name <- paste0("..", i)
    }
    friendly_type <- obj_type_friendly(.fields[[i]])
    cli::cli_abort(
      "{.field {name}} must be a tib collector, not {friendly_type}.",
      call = .error_call
    )
  }

  .fields <- .spec_auto_name_fields(.fields, .error_call)
  .check_duplicate_keys(.fields, .duplicate_keys, .error_call)
  .fields
}

#' Check that no two fields use the same key
#'
#' Keys are compared as a whole, so `c("a", "b")` and `c("a", "c")` are
#' different keys.
#'
#' @param fields (`list`) A named list of field specifications.
#' @inheritParams .shared-params
#' @returns `fields`, invisibly. Throws an error or warning if keys are
#'   duplicated, depending on `.duplicate_keys`.
#' @keywords internal
.check_duplicate_keys <- function(
  fields,
  .duplicate_keys,
  .call = caller_env()
) {
  if (.duplicate_keys == "allow") {
    return(invisible(fields))
  }

  keys <- purrr::map(fields, "key")
  is_duplicated <- vctrs::vec_duplicate_detect(keys)
  if (!any(is_duplicated)) {
    return(invisible(fields))
  }

  groups <- vctrs::vec_group_loc(keys[is_duplicated])
  field_names <- names(fields)[is_duplicated]
  message <- c(
    "Each field must use a unique {.arg .key}.",
    .duplicate_keys_bullets(groups$key, groups$loc, field_names),
    i = "Use {.code .duplicate_keys = \"allow\"} to process the same key in multiple fields."
  )

  if (.duplicate_keys == "error") {
    .tibblify_abort(message, c("spec", "duplicate_keys"), call = .call)
  }
  .tibblify_warn(message, c("spec", "duplicate_keys"), call = .call)
  invisible(fields)
}

#' Check that recursive children don't collide with other fields
#'
#' The children are parsed into an extra column named `.children_to`, using the
#' key `.children`. If `.children_to` matches the name of another field, that
#' field would be silently replaced, so this is always an error. If
#' `.children` matches the key of another field, the same input is processed
#' twice, so it is handled like any other duplicated key.
#'
#' @param fields (`list`) A named list of field specifications.
#' @inheritParams .shared-params
#' @returns `fields`, invisibly.
#' @keywords internal
.check_recursive_children <- function(
  fields,
  .children,
  .children_to,
  .duplicate_keys,
  .call = caller_env()
) {
  if (.children_to %in% names(fields)) {
    children_to <- .children_to
    .tibblify_abort(
      c(
        "{.arg .children_to} must not match the name of another field.",
        x = "The column name {.val {children_to}} is already specified in {.arg ...}."
      ),
      c("spec", "children_to"),
      call = .call,
      message_env = current_env()
    )
  }

  # Only fields that clash with the children, so other duplicates (already
  # reported by `.prep_spec_fields()`) aren't reported twice.
  clashing <- purrr::keep(fields, function(x) identical(x$key, .children))
  clashing[[.children_to]] <- list(key = .children)
  .check_duplicate_keys(clashing, .duplicate_keys, .call)
  invisible(fields)
}

#' Describe duplicated keys as cli bullets
#'
#' @param keys (`list`) The duplicated keys, each a character vector.
#' @param locs (`list`) For each key, the locations in `field_names` that use
#'   it.
#' @param field_names (`character`) Names of the fields with duplicated keys.
#' @returns (`character`) A named vector of cli bullets.
#' @keywords internal
.duplicate_keys_bullets <- function(keys, locs, field_names) {
  bullets <- purrr::map2_chr(keys, locs, function(key, loc) {
    key_string <- paste(key, collapse = "$")
    nms <- field_names[loc]
    cli::format_inline(
      "Key {.code {key_string}} is used by fields {.field {nms}}."
    )
  })
  # The bullets are passed through cli's glue again, so escape literal braces.
  bullets <- gsub(
    "}",
    "}}",
    gsub("{", "{{", bullets, fixed = TRUE),
    fixed = TRUE
  )
  rlang::set_names(bullets, rep("x", length(bullets)))
}

#' Flatten nested field specifications
#'
#' @inheritParams .tspec
#' @returns A flattened, named list of field specifications.
#' @keywords internal
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

#' Check if object is a tibblify specification
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` if `x` is a `tspec` object.
#' @keywords internal
.is_tspec <- function(x) {
  inherits(x, "tspec")
}

#' Auto-name fields based on their key attribute
#'
#' @inheritParams .tspec
#' @inheritParams .shared-params
#' @returns A named list of field specifications.
#' @keywords internal
.spec_auto_name_fields <- function(.fields, .error_call) {
  field_nms <- rlang::names2(.fields)
  unnamed <- !rlang::have_name(.fields)
  auto_nms <- .with_indexed_errors(
    .compat_map_chr(
      .fields[unnamed],
      function(field) {
        key <- field$key
        if (!rlang::is_string(key)) {
          cli::cli_abort(
            c(
              "{.arg key} must be a single string to infer name.",
              x = "{.arg key} has length {length(key)}."
            ),
            call = NULL
          )
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

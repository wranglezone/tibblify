#' @rdname guess_tspec
#' @export
guess_tspec_object <- function(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  call = rlang::current_call()
) {
  rlang::check_dots_empty()
  rlang::check_bool(empty_list_unspecified, call = call)
  rlang::check_bool(simplify_list, call = call)
  rlang::check_bool(inform_unspecified, call = call)
  .check_not_df(x, call)
  .check_list(x)
  .check_object_names(x, call)
  if (rlang::is_empty(x)) {
    return(tspec_object())
  }

  local_env <- rlang::new_environment(list(empty_list_used = FALSE))
  fields <- .imap_guess_object_field_spec(
    x,
    empty_list_unspecified,
    simplify_list,
    local_env
  )
  spec <- tspec_object(
    .vector_allows_empty_list = .read_empty_list_argument(local_env),
    !!!fields
  )
  return(.maybe_inform_unspecified(spec, inform_unspecified, call = call))
}

#' Abort if `x` is a data frame
#'
#' @inheritParams .shared-params
#' @returns `x` (invisibly).
#' @keywords internal
.check_not_df <- function(x, call) {
  if (is.data.frame(x)) {
    msg <- c(
      "{.arg x} must not be a dataframe.",
      i = "Did you want to use {.fn guess_tspec_df} instead?"
    )
    cli::cli_abort(msg, call = call)
  }
  return(invisible(x))
}

#' Guess the field spec for a single object field
#'
#' Dispatches to the appropriate helper based on the detected type of `value`.
#'
#' @inheritParams .shared-params
#' @returns A tib field specification.
#' @keywords internal
.guess_object_field_spec <- function(
  value,
  name,
  empty_list_unspecified,
  simplify_list,
  local_env
) {
  if (is.null(value) || identical(unname(value), list())) {
    return(tib_unspecified(name))
  }
  value_type <- .tib_type_of(value, name, other = TRUE)
  if (value_type == "other") {
    return(tib_variant(name))
  }
  if (value_type == "vector") {
    return(.guess_object_field_spec_vector(value, name))
  }
  if (value_type == "df") {
    return(.guess_object_field_spec_df(
      value,
      name,
      empty_list_unspecified,
      local_env
    ))
  }

  if (value_type != "list") {
    # nocov start
    cli::cli_abort(
      "{.fn .tib_type_of} returned an unexpected type",
      .internal = TRUE
    )
    # nocov end
  }

  if (.is_list_of_null(value)) {
    return(tib_unspecified(name))
  }
  if (.is_object_list(value)) {
    return(.guess_object_field_spec_object_list(
      value,
      name,
      empty_list_unspecified,
      simplify_list,
      local_env
    ))
  }
  if (simplify_list) {
    input_form_result <- .guess_vector_input_form(value, name)
    if (input_form_result$can_simplify) {
      return(input_form_result$tib_spec)
    }
  }
  if (.is_object(value)) {
    return(.guess_object_field_spec_object(
      value,
      name,
      empty_list_unspecified,
      simplify_list,
      local_env
    ))
  }

  return(tib_variant(name))
}

#' Guess the field spec for a vector-typed field
#'
#' @inheritParams .shared-params
#' @returns A tib field specification.
#' @keywords internal
.guess_object_field_spec_vector <- function(value, name) {
  ptype <- .tib_ptype(value)
  if (.is_unspecified(ptype)) {
    return(tib_unspecified(name))
  }
  .tib_scalar_or_vector_spec(name, ptype, vctrs::vec_size(value) == 1)
}

#' Guess the field spec for a data-frame-typed field
#'
#' @inheritParams .shared-params
#' @returns A `tib_df` field specification.
#' @keywords internal
.guess_object_field_spec_df <- function(
  value,
  name,
  empty_list_unspecified,
  local_env
) {
  field_spec <- .imap_col_to_spec(value, empty_list_unspecified, local_env)
  return(tib_df(name, !!!field_spec))
}

#' Guess the field spec for a nested object field
#'
#' @inheritParams .shared-params
#' @returns A `tib_row` field specification.
#' @keywords internal
.guess_object_field_spec_object <- function(
  value,
  name,
  empty_list_unspecified,
  simplify_list,
  local_env
) {
  .guess_object_field_spec_expand_fields(
    value,
    empty_list_unspecified,
    simplify_list,
    local_env,
    .key = name,
    tib_fn = tib_row,
    fields_fn = .imap_guess_object_field_spec
  )
}

#' Map `.guess_object_field_spec` over a named list
#'
#' @inheritParams .shared-params
#' @returns A named list of tib field specifications, one per element of `x`.
#' @keywords internal
.imap_guess_object_field_spec <- function(
  x,
  empty_list_unspecified,
  simplify_list,
  local_env
) {
  purrr::imap(
    x,
    function(value, name) {
      .guess_object_field_spec(
        value,
        name,
        empty_list_unspecified,
        simplify_list,
        local_env
      )
    }
  )
}

#' Abort for missing or duplicate names
#'
#' @inheritParams .shared-params
#' @returns `NULL` (invisibly).
#' @keywords internal
.check_object_names <- function(x, call) {
  .check_named(x, call = call) |>
    .check_names_not_duplicated(call = call)
}

#' Abort for missing names
#'
#' @inheritParams .shared-params
#' @returns `NULL` (invisibly).
#' @keywords internal
.check_named <- function(x, call) {
  if (!rlang::is_named2(x)) {
    msg <- "{.arg x} must be fully named."
    cli::cli_abort(msg, call = call)
  }
  return(invisible(x))
}

#' Abort for duplicate names
#'
#' @inheritParams .shared-params
#' @returns `NULL` (invisibly).
#' @keywords internal
.check_names_not_duplicated <- function(x, call) {
  if (vctrs::vec_duplicate_any(names(x))) {
    msg <- "Names of {.arg x} must be unique."
    cli::cli_abort(msg, call = call)
  }
  return(invisible(x))
}

#' Guess whether a list field can be simplified to a vector spec
#'
#' @inheritParams .shared-params
#' @returns A list with:
#'   - `can_simplify` (`logical(1)`): Whether the field can be simplified.
#'   - `tib_spec`: A tib field specification (present only when `can_simplify`
#'   is `TRUE`).
#' @keywords internal
.guess_vector_input_form <- function(value, name) {
  ptype_result <- .get_ptype_common(value, empty_list_unspecified = FALSE)
  if (!ptype_result$has_common_ptype) {
    return(list(can_simplify = FALSE))
  }
  ptype <- ptype_result$ptype
  if (is.null(ptype)) {
    return(.guess_vector_input_form_null(value, name))
  }
  if (!.is_vec(ptype)) {
    return(list(can_simplify = FALSE))
  }
  if (.is_field_scalar(value)) {
    return(.guess_vector_input_form_field_scalar(value, name, ptype))
  }
  return(
    list(can_simplify = TRUE, tib_spec = tib_variant(name, .required = TRUE))
  )
}

#' Guess input form for a list field whose common ptype is `NULL`
#'
#' @inheritParams .shared-params
#' @returns A list with:
#'   - `can_simplify` (`logical(1)`): Whether the field can be simplified.
#'   - `tib_spec`: A tib field specification (present only when `can_simplify`
#'   is `TRUE`).
#' @keywords internal
.guess_vector_input_form_null <- function(value, name) {
  if (rlang::is_named(value)) {
    return(list(can_simplify = FALSE))
  }
  tib_spec <- tib_unspecified(name, .required = TRUE)
  return(list(can_simplify = TRUE, tib_spec = tib_spec))
}

#' Build a tib spec for a field-scalar input form
#'
#' @inheritParams .shared-params
#' @returns A list with `can_simplify = TRUE` and `tib_spec`, a `tib_vector`
#'   field specification.
#' @keywords internal
.guess_vector_input_form_field_scalar <- function(value, name, ptype) {
  return(list(
    can_simplify = TRUE,
    tib_spec = tib_vector(
      name,
      ptype,
      .required = TRUE,
      .input_form = .tib_vector_input_form(value)
    )
  ))
}

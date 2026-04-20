#' @export
#' @rdname guess_tspec
guess_tspec_df <- function(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  call = rlang::current_call(),
  arg = rlang::caller_arg(x)
) {
  rlang::check_dots_empty()
  rlang::check_bool(empty_list_unspecified, call = call)
  rlang::check_bool(simplify_list, call = call)
  rlang::check_bool(inform_unspecified, call = call)

  local_env <- rlang::new_environment(list(empty_list_used = FALSE))
  if (is.data.frame(x)) {
    # TODO inform that `simplify_list` is not used for data frames
    fields <- .imap_col_to_spec(x, empty_list_unspecified, local_env)
    spec <- tspec_df(
      !!!fields,
      .vector_allows_empty_list = .read_empty_list_argument(local_env)
    )
  } else {
    .check_list(x, arg = arg)

    if (!.is_object_list(x)) {
      msg <- "Not every element of {.arg {arg}} is an object."
      cli::cli_abort(msg, call = call)
    }

    spec <- guess_tspec_object_list(
      x,
      empty_list_unspecified = empty_list_unspecified,
      simplify_list = simplify_list,
      call = call
    )
  }
  return(.maybe_inform_unspecified(spec, inform_unspecified, call = call))
}

#' Convert a column to a tib field specification
#'
#' @inheritParams .shared-params
#' @returns A tib field specification.
#' @keywords internal
.col_to_spec <- function(col, name, empty_list_unspecified, local_env) {
  col_type <- .tib_type_of(col, name, other = FALSE)

  # Can only be df, vector, or list
  if (col_type == "df") {
    return(.df_col_to_spec(col, name, empty_list_unspecified, local_env))
  }
  if (col_type == "vector") {
    return(.vector_col_to_spec(col, name))
  }

  return(.list_col_to_spec(col, name, empty_list_unspecified, local_env))
}

#' Apply column-to-spec conversion across a data frame
#'
#' @param col_list (`list`) A named list of columns, typically a data frame.
#' @inheritParams .shared-params
#' @returns A named list of tib field specifications.
#' @keywords internal
.imap_col_to_spec <- function(col_list, empty_list_unspecified, local_env) {
  purrr::imap(col_list, \(col, name) {
    .col_to_spec(col, name, empty_list_unspecified, local_env)
  })
}

#' Convert a nested data frame column to a tib_row specification
#'
#' @inheritParams .shared-params
#' @returns A [tib_row()] specification.
#' @keywords internal
.df_col_to_spec <- function(col, name, empty_list_unspecified, local_env) {
  fields_spec <- .imap_col_to_spec(col, empty_list_unspecified, local_env)
  return(tib_row(name, !!!fields_spec))
}

#' Convert a vector column to a tib scalar or unspecified specification
#'
#' @inheritParams .shared-params
#' @returns A [tib_scalar()] or [tib_unspecified()] specification.
#' @keywords internal
.vector_col_to_spec <- function(col, name) {
  ptype <- .tib_ptype(col)
  if (.is_unspecified(ptype)) {
    return(tib_unspecified(name))
  }
  return(tib_scalar(name, ptype))
}

## list_col_to_spec ------------------------------------------------------------

#' Convert a list column to a tib field specification
#'
#' Inspects the elements of `col` to determine whether they share a common ptype
#' and dispatches to the appropriate spec builder.
#'
#' @inheritParams .shared-params
#' @returns A tib field specification.
#' @keywords internal
.list_col_to_spec <- function(col, name, empty_list_unspecified, local_env) {
  # `col` must be a list, so we need to check what its elements are
  list_of_col <- vctrs::is_list_of(col)
  if (list_of_col) {
    ptype <- attr(col, "ptype", exact = TRUE)
    ptype_type <- .tib_type_of(ptype, name, other = FALSE)
  } else {
    # TODO this could use sampling for performance
    ptype_common <- .get_ptype_common(col, empty_list_unspecified)
    if (!ptype_common$has_common_ptype) {
      return(tib_variant(name))
    }
    ptype <- ptype_common$ptype
    if (is.null(ptype)) {
      return(tib_unspecified(name))
    }
    ptype_type <- .tib_type_of(ptype, name, other = FALSE)
    .mark_empty_list_argument(ptype_common$had_empty_lists, local_env)
  }

  if (ptype_type == "vector") {
    return(tib_vector(name, ptype))
  }
  if (ptype_type == "df") {
    return(.col_to_spec_df(
      ptype,
      col = col,
      name = name,
      list_of_col,
      empty_list_unspecified,
      local_env
    ))
  }

  cli::cli_abort(
    "List columns that only consists of lists are not supported yet."
  )
}

#' Convert a df-typed list column to a tib_df specification
#'
#' Delegates to [.list_of_col_to_spec_df()] or [.non_list_of_col_to_spec_df()]
#' based on whether `col` is a `list_of()` column.
#'
#' @param list_of_col (`logical(1)`) Whether `col` is a `list_of()` column.
#' @inheritParams .shared-params
#' @returns A [tib_df()] specification.
#' @keywords internal
.col_to_spec_df <- function(
  ptype,
  col,
  name,
  list_of_col,
  empty_list_unspecified,
  local_env
) {
  if (list_of_col) {
    fields_spec <- .list_of_col_to_spec_df(
      col,
      ptype,
      empty_list_unspecified,
      local_env
    )
  } else {
    fields_spec <- .non_list_of_col_to_spec_df(
      col,
      ptype,
      empty_list_unspecified,
      local_env
    )
  }
  tib_df(name, !!!fields_spec)
}

#' Build field specs from a list_of df column
#'
#' @inheritParams .shared-params
#' @returns A named list of tib field specifications.
#' @keywords internal
.list_of_col_to_spec_df <- function(
  col,
  ptype,
  empty_list_unspecified,
  local_env
) {
  col_required <- TRUE # Tests are the same with this being ~anything.
  has_non_vec_cols <- purrr::detect_index(ptype, ~ !.is_vec(.x)) > 0
  if (has_non_vec_cols) {
    # non-vector columns need to be inspected further to actually get their
    # specification
    col_flat <- vctrs::list_unchop(col, ptype = ptype)
  } else {
    col_flat <- ptype
  }
  .imap_col_to_spec(
    col_flat,
    empty_list_unspecified,
    local_env
  )
}

#' Build field specs from a non-list_of df column
#'
#' @inheritParams .shared-params
#' @returns A named list of tib field specifications with `required` set.
#' @keywords internal
.non_list_of_col_to_spec_df <- function(
  col,
  ptype,
  empty_list_unspecified,
  local_env
) {
  col_flat <- vctrs::list_unchop(col, ptype = ptype)
  fields_spec <- .imap_col_to_spec(
    col_flat,
    empty_list_unspecified,
    local_env
  ) |>
    .df_guess_required(col, ptype)
  fields_spec
}

#' Guess whether each field is required in a df-typed list column
#'
#' @param fields_spec (`list`) A named list of tib field specifications.
#' @param col (`list`) A list column whose elements are data frames.
#' @returns `fields_spec` with `$required` updated for each field.
#' @keywords internal
.df_guess_required <- function(fields_spec, col, ptype) {
  for (col_name in colnames(ptype)) {
    fields_spec[[col_name]]$required <- .col_guess_required(col_name, col)
  }
  fields_spec
}

#' Guess whether a field is required across a list of data frames
#'
#' @param col_name (`character(1)`) The column name to check.
#' @param df_list (`list`) A list of data frames.
#' @returns (`logical(1)`) `TRUE` if `col_name` is present in every data frame,
#'   `FALSE` otherwise.
#' @keywords internal
.col_guess_required <- function(col_name, df_list) {
  bad_idx <- purrr::detect_index(
    df_list,
    \(df) !col_name %in% colnames(df)
  )
  bad_idx == 0
}

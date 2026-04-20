#' Convert POSIXlt to POSIXct
#'
#' @inheritParams .shared-params
#' @returns An object of class `POSIXct` if the input is `POSIXlt` (to be in
#'   line with <https://github.com/r-lib/vctrs/issues/1576>), otherwise the
#'   input unchanged.
#' @keywords internal
.cast_posixlt_ptype <- function(x) {
  if (inherits(x, "POSIXlt")) {
    return(vctrs::vec_cast(x, vctrs::new_datetime()))
  }
  x
}

#' Remove empty lists from an object
#'
#' @inheritParams .shared-params
#' @returns The input object with empty lists removed. If any were removed, the
#'   returned object has an attribute `had_empty_lists` set to `TRUE`.
#' @keywords internal
.drop_empty_lists <- function(x) {
  # TODO this could be implement in C for performance
  #
  # For performance reasons don't check for every single element if it is an
  # empty list. Instead, only look at the ones with vec size 0.
  empty_flag <- vctrs::list_sizes(x) == 0
  empty_list_flag <- purrr::map_lgl(x[empty_flag], ~ identical(.x, list()))
  empty_flag[empty_flag] <- empty_list_flag
  if (any(empty_flag)) {
    x <- x[!empty_flag]
    attr(x, "had_empty_lists") <- TRUE
  }
  x
}

#' Is the object unspecified?
#'
#' @inheritParams .shared-params
#' @returns `TRUE` if the object has class `"vctrs_unspecified"`, `FALSE`
#'   otherwise.
#' @keywords internal
.is_unspecified <- function(x) {
  inherits(x, "vctrs_unspecified")
}

#' Is the object a vector?
#'
#' @inheritParams .shared-params
#' @returns `TRUE` if the object is a non-list vector, `FALSE` otherwise.
#' @keywords internal
.is_vec <- function(x) {
  # `obj_is_vector()` considers `list()` to be a vector but we don't
  vctrs::obj_is_vector(x) && !is.list(x)
}

#' Find the common ptype of a list of objects
#'
#' @inheritParams .shared-params
#' @returns A list with component `has_common_ptype` (`TRUE` if so, `FALSE`
#'   otherwise) and optional components `ptype` (an object representing the
#'   common `ptype`, if there is one) and `had_empty_lists` (`TRUE` if
#'   `empty_list_unspecified` is `TRUE` and the `x` input had such empty lists).
#' @keywords internal
.get_ptype_common <- function(x, empty_list_unspecified) {
  rlang::try_fetch(
    {
      if (empty_list_unspecified) {
        x <- .drop_empty_lists(x)
      }
      ptype <- vctrs::vec_ptype_common(!!!x)
      list(
        has_common_ptype = TRUE,
        ptype = .cast_posixlt_ptype(ptype),
        had_empty_lists = attr(x, "had_empty_lists", exact = TRUE)
      )
    },
    vctrs_error_incompatible_type = function(cnd) {
      list(has_common_ptype = FALSE)
    },
    vctrs_error_scalar_type = function(cnd) {
      list(has_common_ptype = FALSE)
    }
  )
}

#' Mark that the empty list argument was used
#'
#' @param used_empty_list_arg (`logical(1)`) Whether any empty lists were
#'   dropped during ptype detection due to `empty_list_unspecified`.
#' @inheritParams .shared-params
#' @returns Called for its side effect of setting `local_env$empty_list_used` to
#'   `TRUE` when `used_empty_list_arg` is `TRUE`.
#' @keywords internal
.mark_empty_list_argument <- function(used_empty_list_arg, local_env) {
  if (is_true(used_empty_list_arg)) {
    local_env$empty_list_used <- TRUE
  }
}

#' Read whether the empty list argument was used
#'
#' @inheritParams .shared-params
#' @returns `TRUE` if `local_env$empty_list_used` is `TRUE`, `FALSE` otherwise.
#' @keywords internal
.read_empty_list_argument <- function(local_env) {
  rlang::is_true(local_env$empty_list_used)
}

#' Determine the tib type of an object
#'
#' @param other (`logical(1)`) If `TRUE`, return `"other"` for unrecognized
#'   types rather than throwing an error.
#' @inheritParams .shared-params
#' @returns One of `"df"`, `"list"`, `"vector"`, or `"other"`.
#' @keywords internal
.tib_type_of <- function(x, name, other) {
  if (is.data.frame(x)) {
    "df"
  } else if (vctrs::obj_is_list(x)) {
    "list"
  } else if (vctrs::vec_is(x)) {
    "vector"
  } else {
    if (!other) {
      msg <- c(
        "Column {name} must be a dataframe, a list, or a vector.",
        x = "Column {name} has classes {.cls class(x)}."
      )
      cli::cli_abort(msg, .internal = TRUE)
    }
    "other"
  }
}

#' Get the ptype of an object
#'
#' @inheritParams .shared-params
#' @returns The ptype of `x`, with `POSIXlt` coerced to `POSIXct`.
#' @keywords internal
.tib_ptype <- function(x) {
  ptype <- vctrs::vec_ptype(x)
  .cast_posixlt_ptype(ptype)
}

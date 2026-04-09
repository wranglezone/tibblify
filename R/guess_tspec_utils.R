#' Conver POSIXlt to POSIXct
#'
#' @param ptype (`any`) An object which might be a `POSIXlt` or have `POSIXlt`
#'   in its class hierarchy.
#' @returns An object of class `POSIXct` if the input is `POSIXlt` (to be in
#'   line with <https://github.com/r-lib/vctrs/issues/1576>), otherwise the
#'   input unchanged.
#' @keywords internal
.cast_posixlt_ptype <- function(ptype) {
  if (inherits(ptype, "POSIXlt")) {
    return(vctrs::vec_cast(ptype, vctrs::new_datetime()))
  }
  ptype
}

#' Remove empty lists from an object
#'
#' @param x (`list`) An object which might contain empty lists.
#' @returns The input object with empty lists removed. If any were removed, the
#'   returned object has an attribute `had_empty_lists` set to `TRUE`.
#' @keywords internal
.drop_empty_lists <- function(x) {
  # TODO this could be implement in C for performance
  # for performance reasons don't check for every single element if it is
  # an empty list. Instead, only look at the ones with vec size 0.
  empty_flag <- vctrs::list_sizes(x) == 0
  empty_list_flag <- purrr::map_lgl(x[empty_flag], ~ identical(.x, list()))
  empty_flag[empty_flag] <- empty_list_flag
  if (any(empty_flag)) {
    x <- x[!empty_flag]
    x %@% "had_empty_lists" <- TRUE
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
#' @param x (`list`) Objects which might have a common `ptype`.
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
        had_empty_lists = x %@% "had_empty_lists"
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

# Aspects of this can only be reached via guess_tspec_object(), so its
# definition doesn't really belong in guess_tspec_object_list.R
.guess_object_list_field_spec <- function(
  value,
  name,
  empty_list_unspecified,
  simplify_list
) {
  ptype_result <- .get_ptype_common(value, empty_list_unspecified)

  # no common ptype can be one of two reasons:
  # * it contains non-vector elements
  # * it contains incompatible types
  # in both cases `tib_variant()` is used
  if (!ptype_result$has_common_ptype) {
    return(tib_variant(name))
  }

  # now we know that every element essentially has type `ptype`
  ptype <- ptype_result$ptype
  if (is.null(ptype)) {
    return(tib_unspecified(name))
  }

  ptype_type <- .tib_type_of(ptype, name, other = FALSE)
  if (ptype_type == "vector") {
    return(.guess_object_list_vector_spec(
      value,
      name,
      ptype,
      ptype_result$had_empty_lists
    ))
  }

  if (ptype_type == "df") {
    # TODO should this actually be supported?
    #
    # TODO fix error call? It's nested in purrr so will take some work to
    # matter.
    cli::cli_abort("A list of dataframes is not yet supported.")
  }

  # every element is a list or NULL at this point
  if (all(vctrs::list_sizes(value) == 0) || .list_is_list_of_null(value)) {
    return(tib_unspecified(name))
  }

  object <- .is_object_list(value)
  object_list <- .is_list_of_object_lists(value)

  value_flat <- .vec_flatten(value, list(), name_spec = NULL)
  if (object_list) {
    fields <- .guess_object_list_spec(
      value_flat,
      empty_list_unspecified,
      simplify_list
    )
    names_to <- if (rlang::is_named(value_flat) && !is_empty(value_flat)) {
      ".names"
    }
    spec <- tib_df(name, !!!fields, .names_to = names_to)
    return(spec)
  }

  if (!simplify_list) {
    if (object) {
      fields <- .guess_object_list_spec(
        value,
        empty_list_unspecified = empty_list_unspecified,
        simplify_list = simplify_list
      )
      return(tib_row(name, !!!fields))
    }

    return(tib_variant(name))
  }

  ptype_result <- .get_ptype_common(value_flat, empty_list_unspecified)
  could_be_vector <- ptype_result$has_common_ptype &&
    .is_field_scalar(value_flat)

  if (could_be_vector) {
    if (rlang::is_named(value_flat)) {
      return(tib_vector(name, ptype_result$ptype, .input_form = "object"))
    } else {
      return(tib_vector(name, ptype_result$ptype, .input_form = "scalar_list"))
    }
  }

  if (object) {
    fields <- .guess_object_list_spec(
      value,
      empty_list_unspecified = empty_list_unspecified,
      simplify_list = simplify_list
    )
    return(tib_row(name, !!!fields))
  }

  tib_variant(name)
}

.mark_empty_list_argument <- function(used_empty_list_arg) {
  if (is_true(used_empty_list_arg)) {
    options(tibblify.used_empty_list_arg = TRUE)
  }
}

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

.tib_ptype <- function(x) {
  ptype <- vctrs::vec_ptype(x)
  .cast_posixlt_ptype(ptype)
}

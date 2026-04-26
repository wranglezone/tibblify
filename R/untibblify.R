#' Convert a data frame or object into a nested list
#'
#' Convert a data frame or an object into a nested list. This is the inverse
#' operation of `tibblify()`. See `vignette("supported-structures")` for a
#' description of objects recognized by tibblify.
#'
#' @param x (`data.frame` or `object`) An object to convert into a nested list.
#' @param spec (`tspec`) Optional. A spec object which was used to create `x`.
#'   Defaults to the spec stored as the `tib_spec` attribute of `x`, if present.
#'
#' @returns A nested list.
#' @export
#'
#' @examples
#' x <- tibble(
#'   a = 1:2,
#'   b = tibble(
#'     x = c("a", "b"),
#'     y = c(1.5, 2.5)
#'   )
#' )
#' untibblify(x)
untibblify <- function(x, spec = get_spec(x)) {
  if (is.data.frame(x)) {
    return(.untibblify_df(x, spec))
  }
  if (vctrs::obj_is_list(x)) {
    return(.untibblify_list(x, spec))
  }
  friendly_type <- obj_type_friendly(x)
  .tibblify_abort(
    "{.arg x} must be a list. Instead, it is {friendly_type}."
  )
}

#' Untibblify a data frame into a list of row lists
#'
#' @inheritParams .shared-params
#' @returns A list with one named list per row of `x`.
#' @keywords internal
.untibblify_df <- function(x, spec, call = caller_env()) {
  idx <- seq_len(vctrs::vec_size(x))
  purrr::map(idx, \(i) {
    .untibblify_row(vctrs::vec_slice(x, i), spec, call)
  })
}

#' Untibblify a single data frame row into a named list
#'
#' @inheritParams .shared-params
#' @returns A named list with one element per field of `x`.
#' @keywords internal
.untibblify_row <- function(x, spec, call = caller_env()) {
  x <- .apply_spec_renaming(x, spec, call = call)
  out <- as.list(x)
  fields <- spec$fields
  for (i in seq_along(out)) {
    elt <- x[[i]]
    if (is.data.frame(elt)) {
      out[[i]] <- .untibblify_row(elt, fields[[i]], call)
    } else if (is.list(elt)) {
      tmp <- .untibblify_list_elt(elt[[1]], fields[[i]], call)
      if (is.null(tmp)) {
        out[i] <- list(NULL)
      } else {
        out[[i]] <- tmp
      }
    } else {
      out[[i]] <- elt
    }
  }
  out
}

#' Untibblify a named list using a spec
#'
#' @inheritParams .shared-params
#' @returns A named list with fields converted according to `spec`.
#' @keywords internal
.untibblify_list <- function(x, spec, call = caller_env()) {
  x <- .apply_spec_renaming(x, spec, call = call)
  fields <- spec$fields
  out <- x
  for (i in seq_along(x)) {
    out[[i]] <- .untibblify_list_elt(x[[i]], fields[[i]], call)
  }
  out
}

#' Untibblify a single list element
#'
#' @inheritParams .shared-params
#' @returns The converted element, or `x` unchanged if no conversion applies.
#' @keywords internal
.untibblify_list_elt <- function(x, field_spec, call = caller_env()) {
  if (is.data.frame(x)) {
    return(.untibblify_df(x, field_spec, call))
  }
  if (is.null(field_spec)) {
    return(x)
  }
  if (.is_tib_row(field_spec)) {
    x <- vctrs::new_data_frame(x, n = 1L)
    out <- .untibblify_df(x, field_spec, call)
    return(out[[1]])
  }
  x
}

#' Rename list elements back to their original spec keys
#'
#' Reverses tibblify's field renaming by mapping column names back to the
#' original keys defined in `spec`.
#'
#' @inheritParams .shared-params
#' @returns A named list with elements keyed by the original spec keys.
#' @keywords internal
.apply_spec_renaming <- function(x, spec, call = caller_env()) {
  if (is.null(spec)) {
    return(x)
  }
  out <- list()
  fields <- spec$fields
  for (i in seq_along(fields)) {
    key <- .check_key_can_untibblify(fields[[i]]$key, call = call)
    nm <- names(fields)[[i]]
    out[[key]] <- x[[nm]]
  }
  out
}

#' Check that a key is valid for untibblify
#'
#' Validates that `key` is a length-1 character string by chaining
#' `.check_key_length_1()` and `.check_key_is_character()`.
#'
#' @param key (`character`) The spec key to validate.
#' @inheritParams .shared-params
#' @returns `key` if valid; otherwise throws an error.
#' @keywords internal
.check_key_can_untibblify <- function(key, call = caller_env()) {
  .check_key_length_1(key, call) |>
    .check_key_is_character(call)
}

#' Check that a key has length 1
#'
#' @inheritParams .check_key_can_untibblify
#' @inheritParams .shared-params
#' @returns `key` if valid; otherwise throws an error.
#' @keywords internal
.check_key_length_1 <- function(key, call = caller_env()) {
  if (length(key) > 1) {
    .tibblify_abort(
      "{.fn untibblify} does not support specs with nested keys",
      call = call
    )
  }
  if (!length(key)) {
    .tibblify_abort(
      "{.fn untibblify} does not support specs with empty keys",
      call = call
    )
  }
  return(key)
}

#' Check that a key is a character string
#'
#' @inheritParams .check_key_can_untibblify
#' @inheritParams .shared-params
#' @returns `key` if valid; otherwise throws an error.
#' @keywords internal
.check_key_is_character <- function(key, call = caller_env()) {
  if (!is.character(key)) {
    .tibblify_abort(
      "{.fn untibblify} does not support specs with non-character keys",
      call = call
    )
  }
  return(key)
}

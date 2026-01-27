#' Rectangle a nested list
#'
#' Transform a nested list into a tibble or a list of objects according to a
#' specification.
#'
#' Fields specifically tagged as [tib_unspecified()] in the `spec` (or guessed
#' as such) will be handled according to the `unspecified` argument. Fields that
#' are present in `x` but not mentioned in the `spec` are ignored.
#'
#' @param x (`list`) A nested list.
#' @param spec (`tspec`) A specification of how to convert `x`. Generated with
#'   [tspec_df()], [tspec_row()], [tspec_object()], [tspec_recursive()], or
#'   [guess_tspec()]. If `spec` is `NULL` (the default), `guess_tspec(x,
#'   inform_unspecified = TRUE)` will be used to guess the `spec`.
#' @param unspecified (`character(1)`) What to do with [tib_unspecified()]
#'   fields. Can be one of
#'   * `"error"`: Throw an error.
#'   * `"inform"`: Inform the user then parse as with [tib_variant()].
#'   * `"drop"`: Do not parse these fields.
#'   * `"list"`: Parse unspecified fields into lists as with [tib_variant()].
#' @return Either a tibble or a list, depending on the specification.
#' @seealso Use [`untibblify()`] to undo the result of `tibblify()`.
#' @export
#'
#' @examples
#' # List of Objects -----------------------------------------------------------
#' x <- list(
#'   list(id = 1, name = "Tyrion Lannister"),
#'   list(id = 2, name = "Victarion Greyjoy")
#' )
#' tibblify(x)
#'
#' # Provide a specification
#' spec <- tspec_df(
#'   id = tib_int("id"),
#'   name = tib_chr("name")
#' )
#' tibblify(x, spec)
#'
#' # Object --------------------------------------------------------------------
#' # Provide a specification for a single object
#' tibblify(x[[1]], tspec_object(spec))
#'
#' # Recursive Trees -----------------------------------------------------------
#' x <- list(
#'   list(
#'     id = 1,
#'     name = "a",
#'     children = list(
#'       list(id = 11, name = "aa"),
#'       list(id = 12, name = "ab", children = list(
#'         list(id = 121, name = "aba")
#'       ))
#'     ))
#' )
#' spec <- tspec_recursive(
#'   tib_int("id"),
#'   tib_chr("name"),
#'   .children = "children"
#' )
#' out <- tibblify(x, spec)
#' out
#' out$children
#' out$children[[1]]$children[[2]]
tibblify <- function(x, spec = NULL, unspecified = NULL) {
  withr::local_locale(c(LC_COLLATE = "C"))

  if (is.null(spec)) {
    spec <- guess_tspec(x, inform_unspecified = TRUE)
    unspecified <- unspecified %||% "list"
  }

  if (!.is_tspec(spec)) {
    friendly_type <- obj_type_friendly(spec)
    msg <- "{.arg spec} must be a tibblify spec, not {friendly_type}."
    cli::cli_abort(msg)
  }

  spec_org <- spec <- .spec_prep_unspecified(spec, unspecified)
  spec <- .spec_prep(spec)
  spec$rowmajor <- spec$input_form == "rowmajor"

  out <- .try_tibblify_impl(x, spec)

  if (inherits(spec_org, "tspec_object")) {
    out <- purrr::map2(spec_org$fields, out, .finalize_tspec_object)
    class(out) <- "tibblify_object"
  }

  out <- .set_spec(out, spec_org)
  attr(out, "waldo_opts") <- list(ignore_attr = c("tib_spec", "waldo_opts"))
  out
}

#' Tibblify implementation with error handling
#'
#' @inheritParams tibblify
#' @inheritParams .shared-params
#' @return Either a tibble or a list, depending on the specification.
#' @keywords internal
.try_tibblify_impl <- function(x, spec, call = caller_env()) {
  path <- list(depth = 0, path_elts = list())
  rlang::try_fetch(
    .tibblify_impl(x, spec, path),
    error = function(cnd) {
      if (inherits(cnd, "tibblify_error")) {
        cnd$call <- call
        rlang::cnd_signal(cnd)
      }

      path_str <- .path_to_string(path)
      .tibblify_abort(
        "Problem while tibblifying {.arg {path_str}}",
        parent = cnd,
        call = call
      )
    }
  )
}

#' Tibblify implementation
#'
#' @inheritParams tibblify
#' @param path (`list`) The current path in the data structure.
#' @return Either a tibble or a list, depending on the specification.
#' @keywords internal
.tibblify_impl <- function(x, spec, path) {
  .Call(ffi_tibblify, x, spec, path)
}

#' Examine the column specification
#'
#' @param x (`data.frame`) The data frame to extract a spec from.
#'
#' @export
#' @return A tibblify specification as returned by [tspec_df()], [tspec_row()],
#'   [tspec_object()], or [tspec_recursive()].
#' @examples
#' df <- tibblify(list(list(x = 1, y = "a"), list(x = 2)))
#' get_spec(df)
get_spec <- function(x) {
  attr(x, "tib_spec")
}

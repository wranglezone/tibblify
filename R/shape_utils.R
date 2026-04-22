#' Is x an object?
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` if `x` is an object (a fully named list with
#'   unique names), `FALSE` otherwise.
#' @keywords internal
.is_object <- function(x) {
  .Call(ffi_is_object, x)
}

#' Is x a list of objects?
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` if `x` is a list of objects, `FALSE`
#'   otherwise.
#' @keywords internal
.is_object_list <- function(x) {
  .Call(ffi_is_object_list, x)
}

#' bort if `x` is not a list of objects
#'
#' @inheritParams .shared-params
#' @returns `x` (invisibly). Called for side effect.
#' @keywords internal
.check_object_list <- function(x, arg = caller_arg(x), call = caller_env()) {
  if (!.is_object_list(x)) {
    cli::cli_abort(
      "{.arg {arg}} must be a list of objects.",
      class = c(
        "tibblify-error-not_object_list",
        "tibblify-error",
        "tibblify-condition"
      ),
      call = call
    )
  }
  invisible(x)
}

#' Is x a list of object lists?
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` if every non-`NULL` element of `x` is a list
#'   of objects, `FALSE` otherwise.
#' @keywords internal
.is_list_of_object_lists <- function(x) {
  for (x_i in x) {
    if (!.is_object_list(x_i) && !is.null(x_i)) {
      return(FALSE)
    }
  }
  TRUE
}

#' Is x a list of NULLs?
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` if every element of `x` is `NULL`, `FALSE`
#'   otherwise.
#' @keywords internal
.is_list_of_null <- function(x) {
  .Call(ffi_is_null_list, x)
}

#' For each element, is it a list of NULLs?
#'
#' @inheritParams .shared-params
#' @returns (`logical`) A logical vector the same length as `x`, where each
#'   element is `TRUE` if the corresponding element of `x` is itself a list of
#'   `NULL`s.
#' @keywords internal
.list_is_list_of_null <- function(x) {
  .Call(ffi_list_is_list_null, x)
}

#' Abort when x is neither an object nor a list of objects
#'
#' @inheritParams .shared-params
#' @returns Nothing. Called for its side effect of throwing an error.
#' @keywords internal
.abort_not_tibblifiable <- function(
  x,
  arg = caller_arg(x),
  call = caller_env()
) {
  object_cnd <- c(
    "An object",
    "is a list,",
    "is fully named,",
    "and has unique names."
  )
  object_bullets <- .lgl_to_bullet(c(
    vctrs::obj_is_list(x),
    rlang::is_named2(x),
    anyDuplicated(names(x)) == 0
  ))
  o_msg <- rlang::set_names(object_cnd, c("", object_bullets))

  object_list_cnd <- c(
    "A list of objects is",
    "a data frame or",
    "a list and",
    "each element is {.code NULL} or an object."
  )
  object_list_bullets <- .lgl_to_bullet(c(
    is.data.frame(x),
    vctrs::obj_is_list(x),
    purrr::detect_index(x, ~ !is.null(.x) && !.is_object(.x)) == 0
  ))
  ol_msg <- rlang::set_names(object_list_cnd, c("", object_list_bullets))

  msg <- c(
    "{.arg {arg}} is neither an object nor a list of objects.",
    o_msg,
    ol_msg
  )

  cli::cli_abort(
    msg,
    class = c(
      "tibblify-error-untibblifiable_object",
      "tibblify-error",
      "tibblify-condition"
    ),
    call = call
  )
}

#' Convert a logical vector to cli bullet symbols
#'
#' @param x (`logical`) A logical vector where `TRUE` maps to a check mark
#'   bullet and `FALSE` to a cross bullet.
#' @returns (`character`) A character vector of cli bullet names (`"v"` or
#'   `"x"`) the same length as `x`.
#' @keywords internal
.lgl_to_bullet <- function(x) {
  bullets <- c("x", "v")
  x2 <- as.integer(x) + 1L
  bullets[x2]
}

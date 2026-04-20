#' Guess the `tibblify()` specification
#'
#' @description
#'
#' `guess_tspec()` automatically dispatches to the other `guess_tspec_*()`
#' functions based on the shape of the input. If you are unhappy with its
#' output, calling a specific `guess_tspec_*()` function may yield better
#' results, or at least clearer error messages about why that type isn't
#' supported.
#'
#' - Use `guess_tspec_df()` if the input is a data frame.
#' - Use `guess_tspec_object()` if the input is an object (such as a JSON
#' object that has been read into R as a named list).
#' - Use `guess_tspec_object_list()` if the input is a list of objects (such as
#' a JSON object that has been read into R as a list of named lists).
#' - Use `guess_tspec_list()` if the input object is a list but you aren't sure
#' how it should be processed.
#'
#' See `vignette("supported-structures)` for a discussion of the input types
#' supported by tibblify.
#'
#' @param x (`list`) A nested list.
#' @param ... These dots are for future extensions and must be empty.
#' @inheritParams .shared-params
#'
#' @returns A specification object that can be used in [tibblify()].
#' @export
#'
#' @examples
#' guess_tspec(list(x = 1, y = "a"))
#' guess_tspec(list(list(x = 1), list(x = 2)))
#'
#' guess_tspec(gh_users)
guess_tspec <- function(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  call = rlang::caller_env()
) {
  rlang::check_dots_empty(call = call)
  if (is.data.frame(x)) {
    return(guess_tspec_df(
      x,
      empty_list_unspecified = empty_list_unspecified,
      simplify_list = simplify_list,
      inform_unspecified = inform_unspecified,
      call = call
    ))
  }
  if (vctrs::obj_is_list(x)) {
    return(guess_tspec_list(
      x,
      empty_list_unspecified = empty_list_unspecified,
      simplify_list = simplify_list,
      inform_unspecified = inform_unspecified,
      call = call
    ))
  }
  stop_input_type(
    x,
    c("a data frame", "a list"),
    arg = caller_arg(x),
    call = call
  )
}

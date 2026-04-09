#' Guess the `tibblify()` specification
#'
#' Use `guess_tspec()` if you don't know the input type.
#' Use `guess_tspec_df()` if the input is a data frame or an object list.
#' Use `guess_tspec_objecte()` is the input is an object.
#'
#' @param x A nested list.
#' @param ... These dots are for future extensions and must be empty.
#' @param empty_list_unspecified Treat empty lists as unspecified?
#' @param simplify_list Should scalar lists be simplified to vectors?
#' @param inform_unspecified Inform about fields whose type could not be
#'   determined?
#' @param call The execution environment of a currently running function, e.g.
#'   `caller_env()`. The function will be mentioned in error messages as the
#'   source of the error. See the `call` argument of [`rlang::abort()`] for more
#'   information.
#' @param arg An argument name as a string. This argument will be mentioned in
#'   error messages as the input that is at the origin of a problem.
#'
#' @return A specification object that can used in `tibblify()`.
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
  check_dots_empty(call = call)
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

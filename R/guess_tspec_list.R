#' @export
#' @rdname guess_tspec
guess_tspec_list <- function(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  arg = caller_arg(x),
  call = current_call()
) {
  check_dots_empty()
  .check_list(x)
  if (is_empty(x)) {
    msg <- "{.arg {arg}} must not be empty."
    cli::cli_abort(msg, call = call)
  }

  # if `x` is both an object list and an object, it should be very rare that it
  # should be parsed as an object.
  if (.is_object_list(x)) {
    return(guess_tspec_object_list(
      x,
      empty_list_unspecified = empty_list_unspecified,
      simplify_list = simplify_list,
      inform_unspecified = inform_unspecified,
      call = call
    ))
  } else if (.is_object(x)) {
    return(guess_tspec_object(
      x,
      empty_list_unspecified = empty_list_unspecified,
      simplify_list = simplify_list,
      inform_unspecified = inform_unspecified,
      call = call
    ))
  } else {
    .abort_not_tibblifiable(x, arg, call)
  }
}

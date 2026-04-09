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
  check_bool(empty_list_unspecified, call = call)
  check_bool(simplify_list, call = call)
  check_bool(inform_unspecified, call = call)

  check_list(x)
  if (is_empty(x)) {
    msg <- "{.arg {arg}} must not be empty."
    cli::cli_abort(msg, call = call)
  }

  # if `x` is both, an object list and an object, it should be very rare that
  # it should be parsed as an object.
  if (is_object_list(x)) {
    spec <- guess_tspec_object_list(
      x,
      empty_list_unspecified = empty_list_unspecified,
      simplify_list = simplify_list,
      call = call
    )
  } else if (is_object(x)) {
    spec <- guess_tspec_object(
      x,
      empty_list_unspecified = empty_list_unspecified,
      simplify_list = simplify_list,
      call = call
    )
  } else {
    abort_not_tibblifiable(x, arg, call)
  }

  if (inform_unspecified) {
    .spec_inform_unspecified(spec)
  }

  spec
}

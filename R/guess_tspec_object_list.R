#' @export
#' @rdname guess_tspec
guess_tspec_object_list <- function(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  arg = caller_arg(x),
  call = current_call()
) {
  rlang::check_dots_empty()
  rlang::check_bool(empty_list_unspecified, call = call)
  rlang::check_bool(simplify_list, call = call)
  rlang::check_bool(inform_unspecified, call = call)
  .check_list(x, arg = arg, call = call)
  .check_object_list(x, arg = arg, call = call)

  local_env <- rlang::new_environment(list(empty_list_used = FALSE))
  spec <- .guess_object_field_spec_expand_fields_df(
    x,
    empty_list_unspecified,
    simplify_list,
    local_env,
    .vector_allows_empty_list = .read_empty_list_argument(local_env),
    tib_fn = tspec_df
  )
  return(.maybe_inform_unspecified(spec, inform_unspecified, call = call))
}

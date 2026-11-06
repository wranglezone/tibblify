#' Signal an error with standards applied
#'
#' @param subclass (`character`) Class(es) to assign to the error. Will be
#'   prefixed by "tibblify-error-".
#' @param message_env (`environment`) The environment used to evaluate glue
#'   fields in `message`.
#' @param parent (`condition` or `NULL`) A parent condition, if any.
#' @param ... Additional parameters passed to [cli::cli_abort()] and on to
#'   [rlang::abort()].
#' @inheritParams .shared-params
#' @returns Does not return; throws an error.
#' @keywords internal
.tibblify_abort <- function(
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
) {
  stbl::pkg_abort(
    "tibblify",
    message = message,
    subclass = subclass,
    call = call,
    message_env = message_env,
    parent = parent,
    ...
  )
}

#' Signal a warning with standards applied
#'
#' @param subclass (`character`) Class(es) to assign to the warning. Will be
#'   prefixed by "tibblify-warning-".
#' @inheritParams .tibblify_abort
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly. Called for its side effect of signaling a
#'   warning.
#' @keywords internal
.tibblify_warn <- function(
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
) {
  stbl::pkg_warn(
    "tibblify",
    message = message,
    subclass = subclass,
    call = call,
    message_env = message_env,
    parent = parent,
    ...
  )
}

#' Raise a package-scoped error
#'
#' @inheritParams .shared-params
#' @inheritParams stbl::pkg_abort
#' @returns Does not return.
#' @keywords internal
.pkg_abort <- function(
  message,
  subclass,
  call = caller_env(),
  message_env = caller_env(),
  ...
) {
  stbl::pkg_abort(
    "tibblify",
    message,
    subclass,
    call = call,
    message_env = message_env,
    ...
  )
}

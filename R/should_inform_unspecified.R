#' Determine whether to inform about unspecified fields in spec
#'
#' Wrapper around `getOption("tibblify.show_unspecified")` to return `TRUE`
#' unless the option is explicitly set to `FALSE`.
#'
#' @returns `FALSE` if the option is set to `FALSE`, `TRUE` otherwise.
#' @export
should_inform_unspecified <- function() {
  !rlang::is_false(getOption("tibblify.show_unspecified"))
}

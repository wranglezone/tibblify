#' Determine whether to inform about unspecified fields in spec
#'
#' @description
#' Wrapper around `getOption("tibblify.show_unspecified")` that implements some
#' fall back logic if the option is unset. This returns:
#'
#' * `FALSE` if the option is set to `FALSE`
#' * `TRUE` otherwise
#'
#' @return `TRUE` or `FALSE`.
#' @export
should_inform_unspecified <- function() {
  !is_false(getOption("tibblify.show_unspecified"))
}

#' Determine whether to inform about unspecified fields in spec
#'
#' @description
#' Wrapper around `getOption("tibblify.show_unspecified")` that implements some
#' fall back logic if the option is unset. This returns:
#'
#' * `TRUE` if the option is set to `TRUE`
#' * `FALSE` if the option is set to `FALSE`
#' * `FALSE` if the option is unset and we appear to be running tests
#' * `TRUE` otherwise
#'
#' @return `TRUE` or `FALSE`.
#' @export
should_inform_unspecified <- function() {
  opt <- getOption("tibblify.show_unspecified", NA)
  if (is_true(opt)) {
    TRUE
  } else if (is_false(opt)) {
    FALSE
  } else if (is.na(opt) && is_testing()) {
    FALSE
  } else {
    TRUE
  }
}

is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

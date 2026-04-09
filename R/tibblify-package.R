#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## Full rlang import required by R/import-standalone-*.R
#' @import rlang
#' @importFrom glue glue
#' @importFrom lifecycle deprecated
#' @importFrom rlang %@%
#' @importFrom rlang arg_match0
#' @importFrom rlang as_function
#' @importFrom rlang caller_arg
#' @importFrom rlang caller_env
#' @importFrom rlang check_bool
#' @importFrom rlang check_dots_empty
#' @importFrom rlang check_string
#' @importFrom rlang current_call
#' @importFrom rlang current_env
#' @importFrom rlang is_empty
#' @importFrom rlang is_true
#' @importFrom rlang list2
#' @importFrom vctrs list_unchop
#' @importFrom vctrs vec_cast
#' @importFrom vctrs vec_is
#' @useDynLib tibblify, .registration = TRUE
# These vctrs imports are used in C code.
## usethis namespace: end
NULL

#' @importFrom rlang zap
#' @export zap
#' @keywords internal
rlang::zap

#' @importFrom tibble tibble
#' @export tibble
#' @keywords internal
tibble::tibble

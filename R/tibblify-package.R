#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import rlang
#' @importFrom cli qty
#' @importFrom glue glue
#' @importFrom lifecycle deprecated
#' @importFrom rlang %&&%
#' @importFrom rlang arg_match0
#' @importFrom rlang as_function
#' @importFrom rlang caller_arg
#' @importFrom rlang caller_env
#' @importFrom rlang current_call
#' @importFrom rlang current_env
#' @importFrom rlang is_true
#' @importFrom rlang list2
#' @importFrom vctrs list_unchop
#' @importFrom vctrs vec_cast
#' @importFrom vctrs vec_is
#' @useDynLib tibblify, .registration = TRUE
# These vctrs imports are used in C code.
## Full rlang import required by R/import-standalone-*.R
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

#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import rlang
#' @import vctrs
#' @importFrom glue glue
#' @importFrom lifecycle deprecated
#' @importFrom rlang arg_match0
#' @importFrom rlang as_function
#' @importFrom rlang caller_arg
#' @importFrom rlang caller_env
#' @importFrom rlang check_dots_empty
#' @importFrom rlang current_call
#' @importFrom rlang current_env
#' @importFrom rlang exec
#' @importFrom rlang is_empty
#' @importFrom rlang is_named
#' @importFrom rlang is_true
#' @importFrom rlang list2
#' @importFrom vctrs list_sizes
#' @importFrom vctrs obj_check_vector
#' @importFrom vctrs vec_any_missing
#' @importFrom vctrs vec_cast
#' @importFrom vctrs vec_check_size
#' @importFrom vctrs vec_detect_missing
#' @importFrom vctrs vec_init
#' @importFrom vctrs vec_ptype
#' @importFrom vctrs vec_size
#' @importFrom vctrs vec_unique_loc
#' @useDynLib tibblify, .registration = TRUE
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

#' Validate that an input is a list
#'
#' @param allow_null (`logical(1)`) Whether `NULL` is accepted.
#' @param ... Additional arguments passed to [rlang::stop_input_type()].
#' @inheritParams .shared-params
#' @returns `NULL` (invisibly) if valid; otherwise throws an error.
#' @keywords internal
.check_list <- function(
  x,
  ...,
  allow_null = FALSE,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (!missing(x)) {
    if (vctrs::obj_is_list(x)) {
      return(invisible(NULL))
    }
    if (allow_null && is.null(x)) {
      return(invisible(NULL))
    }
  }

  stop_input_type(
    x,
    c("a list"),
    ...,
    allow_na = FALSE,
    allow_null = allow_null,
    arg = arg,
    call = call
  )
}

#' Validate that arguments are different
#'
#' @param arg (`any`) The value to compare against `...`.
#' @param ... Other arguments that `arg` must differ from.
#' @param arg_name (`character(1)`) The argument name shown in error messages.
#' @inheritParams .shared-params
#' @returns `NULL` (invisibly). Throws an error if any values are identical.
#' @keywords internal
.check_arg_different <- function(
  arg,
  ...,
  arg_name = caller_arg(arg),
  call = caller_env()
) {
  other_args <- dots_list(..., .named = TRUE)

  for (i in seq_along(other_args)) {
    if (identical(arg, other_args[[i]])) {
      other_arg_nm <- names(other_args)[[i]]
      msg <- "{.arg {arg_name}} must be different from {.arg {other_arg_nm}}."
      cli_abort(
        msg,
        call = call,
        class = c("tibblify-error-args_same_value", "tibblify-error")
      )
    }
  }
}

#' Convert a path object to a printable string
#'
#' @inheritParams .shared-params-utils
#' @returns (`character(1)`) A string path such as `"x$a[[1]]"`.
#' @keywords internal
.path_to_string <- function(path) {
  depth <- path[[1]] + 1L
  path_elts <- path[[2]]

  if (depth == 0) {
    return("x")
  }

  path_elements <- .compat_map_chr(
    path_elts[1:depth],
    function(elt) {
      if (is.character(elt)) {
        paste0("$", elt)
      } else {
        paste0("[[", elt + 1, "]]")
      }
    }
  )

  paste0("x", paste0(path_elements, collapse = ""))
}

#' Throw a tibblify internal error
#'
#' @param .envir (`environment`) The environment used to evaluate cli fields.
#' @param ... Arguments passed to [cli::cli_abort()].
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.tibblify_abort <- function(..., .envir = caller_env()) {
  cli::cli_abort(..., class = "tibblify_error", .envir = .envir)
}

#' Error for missing required field
#'
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_required <- function(path) {
  n <- path[[1]] + 1L
  path_elts <- path[[2]]
  path[[1]] <- path[[1]] - 1L
  path_str <- .path_to_string(path)
  msg <- c(
    "Field {.field {path_elts[[n]]}} is required but does not exist in {.arg {path_str}}.",
    i = "Use {.code required = FALSE} if the field is optional."
  )
  .tibblify_abort(msg)
}

#' Error for non-scalar field
#'
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_scalar <- function(path, size_act) {
  path_str <- .path_to_string(path)
  msg <- c(
    "{.arg {path_str}} must have size {.val {1}}, not size {.val {size_act}}.",
    i = "You specified that the field is a scalar.",
    i = "Use {.fn tib_vector} if the field is a vector instead."
  )
  .tibblify_abort(msg)
}

#' Error for duplicate names
#'
#' @inheritParams .shared-params
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_duplicate_name <- function(path, name) {
  path_str <- .path_to_string(path)
  msg <- c(
    "The names of an object must be unique.",
    x = "{.arg {path_str}} has the duplicated name {.val {name}}."
  )
  .tibblify_abort(msg)
}

#' Error for empty names
#'
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_empty_name <- function(path, index) {
  path_str <- .path_to_string(path)
  msg <- c(
    "The names of an object can't be empty.",
    x = "{.arg {path_str}} has an empty name at location {index + 1}."
  )
  .tibblify_abort(msg)
}

#' Error for unnamed object
#'
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_names_is_null <- function(path) {
  path_str <- .path_to_string(path)
  msg <- c(
    "An object must be named.",
    x = "{.arg {path_str}} is not named."
  )
  .tibblify_abort(msg)
}

#' Error for unnamed object vector
#'
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_object_vector_names_is_null <- function(path) {
  path_str <- .path_to_string(path)
  msg <- c(
    'A vector must be a named list for {.code input_form = "object."}',
    x = "{.arg {path_str}} is not named."
  )
  .tibblify_abort(msg)
}

#' Error for non-list vector element
#'
#' @inheritParams .shared-params
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_vector_non_list_element <- function(path, input_form, x) {
  path_str <- .path_to_string(path)
  msg <- c(
    "{.arg {path_str}} must be a list, not {obj_type_friendly(x)}.",
    x = '{.code input_form = "{input_form}"} can only parse lists.',
    i = 'Use `input_form = "vector"` (the default) if the field is already a vector.'
  )
  .tibblify_abort(msg)
}

#' Error for wrong-sized vector element
#'
#' @inheritParams .shared-params
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_vector_wrong_size_element <- function(path, input_form, x) {
  path_str <- .path_to_string(path)
  sizes <- vctrs::list_sizes(x)
  idx <- which(sizes != 1 & !vctrs::vec_detect_missing(x))
  if (input_form == "scalar_list") {
    desc <- "a list of scalars"
  } else {
    desc <- "an object"
  }
  msg <- c(
    "{.arg {path_str}} is not {desc}.",
    x = "Element {.field {idx}} must have size {.val {1}}, not size {.val {sizes[idx]}}."
  )
  .tibblify_abort(msg)
}

#' Error for NULL in colmajor fields
#'
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_colmajor_null <- function(path) {
  path_str <- .path_to_string(path)
  msg <- c(
    "Field {.field {path_str}} must not be {.val NULL}."
  )
  .tibblify_abort(msg)
}

#' Error for inconsistent colmajor field sizes
#'
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_colmajor_wrong_size_element <- function(
  path,
  size_act,
  path_exp,
  size_exp
) {
  path_str <- .path_to_string(path)
  path_str_exp <- .path_to_string(path_exp)
  msg <- c(
    "Not all fields of {.arg x} have the same size.",
    x = "Field {.field {path_str}} has size {.val {size_act}}.",
    x = "Field {.field {path_str_exp}} has size {.val {size_exp}}."
  )
  .tibblify_abort(msg)
}

#' Error for missing required colmajor field
#'
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_required_colmajor <- function(path) {
  n <- path[[1]] + 1L
  path_elts <- path[[2]]
  path[[1]] <- path[[1]] - 1L
  path_str <- .path_to_string(path)
  msg <- c(
    "Field {.field {path_elts[[n]]}} is required but does not exist in {.arg {path_str}}.",
    i = 'For {.code .input_form = "colmajor"} every field is required.'
  )
  .tibblify_abort(msg)
}

#' Error for non-list element
#'
#' @inheritParams .shared-params
#' @inheritParams .shared-params-utils
#' @returns Never returns; called for its side effect of throwing an error.
#' @keywords internal
.stop_non_list_element <- function(path, x) {
  path_str <- .path_to_string(path)
  msg <- c(
    "{.arg {path_str}} must be a list, not {obj_type_friendly(x)}."
  )
  .tibblify_abort(msg)
}

#' Flatten a list to a vector
#'
#' @param name_spec (`character(1)`, `function`, or `NULL`) Name specification
#'   passed to [vctrs::list_unchop()].
#' @param ptype (`vector(0)`) Prototype for the flattened output.
#' @inheritParams .shared-params
#' @returns A vector with elements from `x`.
#' @keywords internal
.vec_flatten <- function(x, ptype, name_spec = zap()) {
  vctrs::list_unchop(x, ptype = ptype, name_spec = name_spec)
}

#' Drop NULL elements from a list
#'
#' @inheritParams .shared-params
#' @returns `x` with `NULL` elements removed.
#' @keywords internal
.list_drop_null <- function(x) {
  null_flag <- vctrs::vec_detect_missing(x)
  if (any(null_flag)) {
    x <- x[!null_flag]
  }

  x
}

#' Map to a character vector
#'
#' @param .f (`function`) Function to apply to each element of `x`.
#' @param ... Additional arguments passed to `.f`.
#' @inheritParams .shared-params
#' @returns (`character`) The mapped character vector.
#' @keywords internal
.compat_map_chr <- function(x, .f, ...) {
  purrr::map_vec(x, .f, ..., .ptype = character())
}

#' Wrap indexed purrr errors with context
#'
#' @inheritParams .shared-params-utils
#' @returns The evaluated result of `expr`, or an error with added context.
#' @keywords internal
.with_indexed_errors <- function(
  expr,
  message,
  error_call = caller_env(),
  env = caller_env()
) {
  rlang::try_fetch(
    expr,
    purrr_error_indexed = function(cnd) {
      msg_env <- rlang::new_environment(list(cnd = cnd), parent = env)
      cli::cli_abort(
        message,
        call = error_call,
        parent = cnd$parent,
        .envir = msg_env
      )
    }
  )
}

#' Check whether input is an HTTP(S) URL string
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` for scalar strings starting with `http://` or
#'   `https://`, `FALSE` otherwise.
#' @keywords internal
.is_url_string <- function(x, arg = caller_arg(x), call = caller_env()) {
  rlang::is_scalar_character(x) && grepl("^https?://", x)
}

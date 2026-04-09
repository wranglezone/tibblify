.is_object <- function(x) {
  .Call(ffi_is_object, x)
}

.is_object_list <- function(x) {
  .Call(ffi_is_object_list, x)
}

.is_list_of_object_lists <- function(x) {
  for (x_i in x) {
    if (!.is_object_list(x_i) && !is.null(x_i)) {
      return(FALSE)
    }
  }
  TRUE
}

.is_list_of_null <- function(x) {
  .Call(ffi_is_null_list, x)
}

.list_is_list_of_null <- function(x) {
  .Call(ffi_list_is_list_null, x)
}

.abort_not_tibblifiable <- function(
  x,
  arg = caller_arg(x),
  error_call = caller_env()
) {
  object_cnd <- c(
    "An object",
    "is a list,",
    "is fully named,",
    "and has unique names."
  )
  object_bullets <- .lgl_to_bullet(c(
    vctrs::obj_is_list(x),
    rlang::is_named2(x),
    anyDuplicated(names(x)) == 0
  ))
  o_msg <- set_names(object_cnd, c("", object_bullets))

  object_list_cnd <- c(
    "A list of objects is",
    "a data frame or",
    "a list and",
    "each element is {.code NULL} or an object."
  )
  object_list_bullets <- .lgl_to_bullet(c(
    is.data.frame(x),
    vctrs::obj_is_list(x),
    purrr::detect_index(x, ~ !is.null(.x) && !.is_object(.x)) == 0
  ))
  ol_msg <- set_names(object_list_cnd, c("", object_list_bullets))

  msg <- c(
    "{.arg {arg}} is neither an object nor a list of objects.",
    o_msg,
    ol_msg
  )

  cli::cli_abort(
    msg,
    class = c(
      "tibblify-error-untibblifiable_object",
      "tibblify-error",
      "tibblify-condition"
    ),
    call = error_call
  )
}

.lgl_to_bullet <- function(x) {
  bullets <- c("x", "v")
  x2 <- as.integer(x) + 1L
  bullets[x2]
}

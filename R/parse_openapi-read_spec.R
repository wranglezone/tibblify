#' Read an OpenAPI spec from a file, connection, or list
#'
#' @inheritParams .shared-params
#' @returns (`list`) The parsed spec.
#' @keywords internal
.read_spec <- function(file, arg = caller_arg(file), call = caller_env()) {
  .check_openapi_version(.read_spec_impl(file, arg = arg, call = call))
}

#' Read an OpenAPI schema from a file, connection, or list
#'
#' @inheritParams .shared-params
#' @returns (`list`) The parsed schema.
#' @keywords internal
.read_schema <- function(file, arg = caller_arg(file), call = caller_env()) {
  .read_spec_impl(file, arg = arg, call = call)
}

#' Read an OpenAPI spec or schema from a file, connection, or list
#'
#' @inheritParams .shared-params
#' @returns (`list`) The parsed spec or schema.
#' @keywords internal
.read_spec_impl <- function(file, arg = caller_arg(file), call = caller_env()) {
  .forget_parse_schema_memoised()
  UseMethod(".read_spec_impl")
}

#' @rdname dot-read_spec_impl
#' @export
.read_spec_impl.list <- function(file, ...) {
  file
}

#' @rdname dot-read_spec_impl
#' @export
.read_spec_impl.connection <- function(
  file,
  ...
) {
  # nocov start
  rlang::check_installed("yaml", "to read OpenAPI specs from connections.")
  yaml::read_yaml(file)
  # nocov end
}

#' @rdname dot-read_spec_impl
#' @export
.read_spec_impl.character <- function(
  file,
  arg = caller_arg(file),
  call = caller_env()
) {
  rlang::check_string(file, arg = arg, call = call)
  rlang::check_installed("yaml", "to read OpenAPI specs.")
  if (grepl("\n", file)) {
    yaml::yaml.load(file)
  } else {
    yaml::read_yaml(file, readLines.warn = FALSE)
  }
}

#' @rdname dot-read_spec_impl
#' @export
.read_spec_impl.default <- function(
  file,
  arg = caller_arg(file),
  call = caller_env()
) {
  stop_input_type(
    file,
    c("a string", "a connection", "a list"),
    arg = arg,
    call = call
  )
}

#' Forget memoised version of `.parse_schema`
#'
#' @returns If memoise is installed, `TRUE` if the function is memoised, `FALSE`
#'   otherwise. If memoise is not installed, `NULL` (invisibly).
#' @keywords internal
.forget_parse_schema_memoised <- function() {
  # cannot use `openapi_spec` for memoising, as hashing it takes much more time
  # than everything else. To still make sure the result is correct simply forget
  # previous results.
  if (rlang::is_installed("memoise")) {
    memoise::forget(.parse_schema_memoised)
  }
}

#' Ensure the OpenAPI version is supported
#'
#' @inheritParams .shared-params
#' @returns The input `openapi_spec` if the version is supported.
#' @keywords internal
.check_openapi_version <- function(openapi_spec) {
  version <- openapi_spec$openapi
  if (is.null(version) || version < "3") {
    cli::cli_abort("OpenAPI versions before 3 are not supported.")
  }
  return(openapi_spec)
}

# tib_variant ------------------------------------------------------------------

#' @rdname tib_spec
#' @export
tib_variant <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .transform = NULL,
  .elt_transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  transform = deprecated(),
  elt_transform = deprecated()
) {
  check_dots_empty()
  .key <- .deprecate_arg(.key, key)
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .transform <- .deprecate_arg(.transform, transform)
  .elt_transform <- .deprecate_arg(.elt_transform, elt_transform)
  .tib_collector(
    .key = .key,
    .type = "variant",
    .required = .required,
    .fill = .fill,
    .transform = .transform,
    .elt_transform = .elt_transform
  )
}

#' Check if object is a tib variant
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` if `x` is a `tib_variant`.
#' @keywords internal
.is_tib_variant <- function(x) {
  inherits(x, "tib_variant")
}

# tib_recursive ----------------------------------------------------------------

#' @rdname tib_spec
#' @export
tib_recursive <- function(
  .key,
  ...,
  .children,
  .children_to = .children,
  .required = TRUE
) {
  check_string(.children)
  check_string(.children_to)

  .tib_collector(
    .key = .key,
    .type = "recursive",
    .required = .required,
    child = .children,
    children_to = .children_to,
    fields = .prep_spec_fields(list2(...), .error_call = current_env())
  )
}

# tib_row ----------------------------------------------------------------------

#' @rdname tib_spec
#' @export
tib_row <- function(.key, ..., .required = TRUE) {
  .tib_collector(
    .key = .key,
    .type = "row",
    .required = .required,
    fields = .prep_spec_fields(list2(...), .error_call = current_env())
  )
}

#' Check if object is a tib row
#'
#' @inheritParams .shared-params
#' @returns (`logical(1)`) `TRUE` if `x` is a `tib_row`.
#' @keywords internal
.is_tib_row <- function(x) {
  inherits(x, "tib_row")
}

# tib_df -----------------------------------------------------------------------

#' @rdname tib_spec
#' @export
tib_df <- function(.key, ..., .required = TRUE, .names_to = NULL) {
  if (!is.null(.names_to)) {
    check_string(.names_to)
  }

  .tib_collector(
    .key = .key,
    .type = "df",
    .required = .required,
    fields = .prep_spec_fields(list2(...), .error_call = current_env()),
    .names_col = .names_to
  )
}

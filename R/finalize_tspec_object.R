#' Finalize a tibblify object
#'
#' @param field (`any`) The field value.
#' @inheritParams .shared-params-spec_prep
#' @keywords internal
.finalize_tspec_object <- function(field_spec, field) {
  UseMethod(".finalize_tspec_object")
}

#' @export
.finalize_tspec_object.tib_collector <- function(field_spec, field) {
  field[[1]]
}

#' @export
.finalize_tspec_object.tib_scalar <- function(field_spec, field) {
  field
}

#' @export
.finalize_tspec_object.tib_row <- function(field_spec, field) {
  purrr::map2(field_spec$fields, field, .finalize_tspec_object)
}

#' Set the tibblify specification attribute
#'
#' @inheritParams tibblify
#' @returns The object `x` with the `tib_spec` attribute set.
#' @keywords internal
.set_spec <- function(x, spec) {
  attr(x, "tib_spec") <- spec
  x
}

#' Prepare unspecified fields
#'
#' @inheritParams tibblify
#' @inheritParams .shared-params
#' @returns A prepared tibblify specification.
#' @keywords internal
.spec_prep_unspecified <- function(spec, unspecified, call = caller_env()) {
  unspecified <- unspecified %||% "error"
  unspecified <- arg_match0(
    unspecified,
    c("error", "inform", "drop", "list"),
    arg_nm = "unspecified",
    error_call = call
  )
  .spec_inform_unspecified(spec, unspecified, call = call)
  .spec_replace_unspecified(spec, unspecified)
}

#' Replace unspecified fields in the specification
#'
#' @inheritParams tibblify
#' @inheritParams .shared-params-spec_prep
#' @returns A modified tibblify specification.
#' @keywords internal
.spec_replace_unspecified <- function(spec, unspecified) {
  spec$fields <- .spec_replace_unspecified_impl(spec$fields, unspecified)
  spec
}

#' Replace unspecified fields in the specification
#'
#' @inheritParams tibblify
#' @inheritParams .shared-params-spec_prep
#' @returns A modified list of `tib_collector` objects.
#' @keywords internal
.spec_replace_unspecified_impl <- function(spec_fields, unspecified) {
  purrr::map(
    spec_fields,
    function(field_spec) {
      if (length(field_spec)) {
        switch(
          field_spec$type,
          unspecified = .spec_replace_unspecified_type(field_spec, unspecified),
          df = ,
          row = .spec_replace_unspecified(field_spec, unspecified),
          field_spec
        )
      }
    }
  ) |>
    purrr::compact()
}

#' Replace tib_unspecified fields in the specification
#'
#' @inheritParams tibblify
#' @inheritParams .shared-params-spec_prep
#' @returns A modified `tib_collector`.
#' @keywords internal
.spec_replace_unspecified_type <- function(field_spec, unspecified) {
  if (unspecified != "drop") {
    return(tib_variant(field_spec$key, .required = field_spec$required))
  }
}

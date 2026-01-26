#' Prepare a recursive tibblify specification
#'
#' @inheritParams tibblify
#' @returns A prepared tibblify specification.
#' @keywords internal
.spec_prep_recursive <- function(spec) {
  # TODO how to rename?
  recursive_helper_field <- tib_df(
    spec$child,
    .required = FALSE
  )
  recursive_helper_field$type <- "recursive_helper"
  spec$fields[[spec$children_to]] <- recursive_helper_field

  spec <- .spec_prep_nonrecursive(spec)

  spec$type <- "df"
  spec["names_col"] <- list(NULL)
  spec$child_coll_pos <- which(
    .compat_map_chr(spec$fields, "type") == "recursive_helper"
  ) -
    1L

  spec
}

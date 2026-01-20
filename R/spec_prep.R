#' Shared spec_prep parameters
#'
#' These parameters are used in multiple [.spec_prep()]-related functions. They
#' are defined here to make them easier to import and to find. This break-out is
#' for parameters that may differ from other functions that use the same
#' parameter names.
#'
#' @param coll_locations (`integer`) A numeric vector of locations.
#' @param field_spec (`tib_collector`) A field specification.
#' @param fill (`vector`) The fill value.
#' @param first_keys (`character`) First keys of the complex fields.
#' @param key (`character(1)`) The key of the field.
#' @param spec_fields (`list`) Fields from spec$fields (or a subset thereof).
#' @param x (`tib_collector`) A field specification.
#' @param ptype (`vector(0)`) The target ptype.
#' @param names_to (`character(1)`) Name of the names column.
#' @param col_names (`character`) Column names.
#'
#' @name .shared-params-spec_prep
#' @keywords internal
NULL

#' Prepare a tibblify specification for tibblification
#'
#' @inheritParams tibblify
#' @returns A prepared tibblify specification.
#' @keywords internal
.spec_prep <- function(spec) {
  if (spec$type == "recursive") {
    # Tested in tests/testthat/test-tibblify_spec_prep_recursive.R
    return(.spec_prep_recursive(spec)) # nocov
  }
  .spec_prep_nonrecursive(spec)
}

#' Prepare a non-recursive tibblify specification
#'
#' @inheritParams tibblify
#' @returns A prepared tibblify specification.
#' @keywords internal
.spec_prep_nonrecursive <- function(spec) {
  has_names_col <- !is.null(spec$names_col)
  n_cols <- length(spec$fields)
  coll_locations <- rlang::seq2(1, n_cols) - !has_names_col
  spec$n_cols <- n_cols + has_names_col
  spec$col_names <- c(spec$names_col, rlang::names2(spec$fields))

  spec$ptype_dummy <- vctrs::vec_init(list(), spec$n_cols)
  result <- .prep_nested_keys(spec$fields, coll_locations)
  spec$fields <- result$fields
  spec$keys <- result$keys
  spec$coll_locations <- result$coll_locations
  # TODO maybe add `key_match_ind`?

  spec
}

#' Prepare nested keys in a tibblify specification
#'
#' @inheritParams .shared-params-spec_prep
#' @returns A list with prepared fields, keys, and locations.
#' @keywords internal
.prep_nested_keys <- function(spec_fields, coll_locations) {
  sorted <- .sort_spec_by_first_key(spec_fields, coll_locations)
  is_sub <- lengths(sorted$keys) > 1
  .combine_processed_fields(
    .process_simple_fields(sorted$spec[!is_sub]),
    .process_complex_fields(
      sorted$spec[is_sub],
      sorted$first_keys[is_sub]
    ),
    sorted$coll_locations,
    is_sub,
    sorted$first_keys
  )
}

#' Sort specification by the first key
#'
#' @inheritParams .shared-params-spec_prep
#' @returns A list with sorted components.
#' @keywords internal
.sort_spec_by_first_key <- function(spec_fields, coll_locations) {
  keys <- lapply(spec_fields, `[[`, "key")
  first_keys <- vapply(keys, `[[`, 1L, FUN.VALUE = character(1))
  key_order <- sort.list(first_keys, method = "radix")
  list(
    spec = spec_fields[key_order],
    coll_locations = coll_locations[key_order],
    keys = keys[key_order],
    first_keys = first_keys[key_order]
  )
}

#' Process simple fields (depth 1)
#'
#' @inheritParams .shared-params-spec_prep
#' @returns A list of prepared fields.
#' @keywords internal
.process_simple_fields <- function(spec_fields) {
  purrr::map(spec_fields, .prep_simple_field)
}

#' Process complex fields (depth > 1)
#'
#' @inheritParams .shared-params-spec_prep
#' @returns A list of prepared fields.
#' @keywords internal
.process_complex_fields <- function(spec_fields, first_keys) {
  spec_complex <- purrr::map(spec_fields, .remove_first_key)
  spec_split <- vctrs::vec_split(spec_complex, first_keys)
  purrr::map2(
    spec_split$key,
    spec_split$val,
    .prep_complex_field
  )
}

#' Combine processed simple and complex fields
#'
#' @param spec_simple (`list`) Processed simple fields.
#' @param spec_complex (`list`) Processed complex fields.
#' @param is_sub (`logical`) Which fields are sub-fields?
#' @inheritParams .shared-params-spec_prep
#' @returns A list with fields, locations, and keys.
#' @keywords internal
.combine_processed_fields <- function(
  spec_simple,
  spec_complex,
  coll_locations,
  is_sub,
  first_keys
) {
  spec_out <- c(spec_simple, spec_complex)
  coll_locations_out <- c(
    vctrs::vec_chop(coll_locations[!is_sub]),
    vctrs::vec_split(coll_locations[is_sub], first_keys[is_sub])$val
  )
  first_keys <- .compat_map_chr(spec_out, list("key", 1))
  key_order <- sort.list(first_keys)
  list(
    fields = spec_out[key_order],
    coll_locations = coll_locations_out[key_order],
    keys = first_keys[key_order]
  )
}

#' Remove the first key from a field
#'
#' @inheritParams .shared-params-spec_prep
#' @returns The field specification with the first key removed.
#' @keywords internal
.remove_first_key <- function(x) {
  x$key <- x$key[-1]
  x
}

#' Prepare a simple field
#'
#' @inheritParams .shared-params-spec_prep
#' @returns A prepared field specification.
#' @keywords internal
.prep_simple_field <- function(x) {
  x$key <- x$key[[1]]
  switch(
    x$type,
    scalar = .prep_tib_scalar(x),
    vector = .prep_tib_vector(x),
    row = .spec_prep(x),
    df = .spec_prep(x),
    # Tested in `test-tibblify_spec_prep_recursive.R`
    recursive = .spec_prep(x),
    x
  )
}

#' Prepare a complex field
#'
#' @inheritParams .shared-params-spec_prep
#' @returns A prepared field specification.
#' @keywords internal
.prep_complex_field <- function(key, spec_fields) {
  out <- list(
    key = key,
    type = "sub",
    fields = spec_fields
  )
  .spec_prep(out)
}

#' Prepare a scalar field
#'
#' @inheritParams .shared-params-spec_prep
#' @returns A prepared scalar field specification.
#' @keywords internal
.prep_tib_scalar <- function(x) {
  x$na <- vctrs::vec_init(x$ptype_inner, 1L)
  x
}

#' Prepare a vector field
#'
#' @inheritParams .shared-params-spec_prep
#' @returns A prepared vector field specification.
#' @keywords internal
.prep_tib_vector <- function(x) {
  col_names <- c(x$names_to, x$values_to)
  x["col_names"] <- list(col_names)
  x$list_of_ptype <- .prep_tib_list_of_ptype(x$ptype, x$names_to, col_names)
  # Need to avoid removing the case when x$fill is NULL (but present). Can
  # probably simplify this by having the C side deal with missing fill.
  if (length(x$fill)) {
    x$fill <- .prep_tib_fill(x$fill, x$names_to, col_names)
  }
  x$na <- vctrs::vec_init(x$ptype)
  x
}

#' Prepare the ptype list for a vector field
#'
#' @inheritParams .shared-params-spec_prep
#' @returns A tibble representing the ptype.
#' @keywords internal
.prep_tib_list_of_ptype <- function(ptype, names_to, col_names) {
  if (!length(col_names)) {
    return(ptype)
  }
  tibble::as_tibble(rlang::set_names(
    c(
      if (length(names_to)) list(character()),
      list(ptype)
    ),
    col_names
  ))
}

#' Prepare the fill value for a vector field
#'
#' @inheritParams .shared-params-spec_prep
#' @returns The existing fill value, or a tibble representing the fill.
#' @keywords internal
.prep_tib_fill <- function(fill, names_to, col_names) {
  if (!length(col_names)) {
    return(fill)
  }
  tibble::as_tibble(rlang::set_names(
    c(
      if (length(names_to)) list(names(fill)),
      list(unname(fill))
    ),
    col_names
  ))
}

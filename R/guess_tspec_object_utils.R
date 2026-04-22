#' Create a scalar or vector tib spec
#'
#' @param is_scalar (`logical(1)`) If `TRUE`, return a [tib_scalar()] spec,
#'   otherwise a [tib_vector()] spec.
#' @inheritParams .shared-params
#' @returns A [tib_scalar()] or [tib_vector()] spec.
#' @keywords internal
.tib_scalar_or_vector_spec <- function(name, ptype, is_scalar) {
  if (is_scalar) {
    tib_scalar(name, ptype)
  } else {
    tib_vector(name, ptype)
  }
}

#' Determine the vector input form of a value
#'
#' @inheritParams .shared-params
#' @returns `"object"` if `value` is named, `"scalar_list"` otherwise.
#' @keywords internal
.tib_vector_input_form <- function(value) {
  ifelse(rlang::is_named(value), "object", "scalar_list")
}

#' Expand an object list into a tib spec
#'
#' @param ... Additional arguments passed to `tib_fn`.
#' @param tib_fn (`function`) The tib constructor to wrap the fields in
#'   (e.g. [tib_df()] or [tib_row()]).
#' @param fields_fn (`function`) The function used to generate field specs from
#'   `value`; defaults to [.guess_object_list_spec()].
#' @inheritParams .shared-params
#' @returns A tib spec created by `tib_fn`.
#' @keywords internal
.guess_object_field_spec_expand_fields <- function(
  value,
  empty_list_unspecified,
  simplify_list,
  local_env,
  ...,
  tib_fn = tib_df,
  fields_fn = .guess_object_list_spec
) {
  fields <- fields_fn(
    value,
    empty_list_unspecified,
    simplify_list,
    local_env
  )
  return(tib_fn(
    !!!fields,
    ...
  ))
}

#' Expand an object list into a tib_df spec
#'
#' @param ... Additional arguments passed to `tib_fn`.
#' @param tib_fn (`function`) The tib constructor to wrap the fields in;
#'   defaults to [tib_df()].
#' @inheritParams .shared-params
#' @returns A [tib_df()] spec, with `.names_to` set when `value` is named and
#'   non-empty.
#' @keywords internal
.guess_object_field_spec_expand_fields_df <- function(
  value,
  empty_list_unspecified,
  simplify_list,
  local_env,
  ...,
  tib_fn = tib_df
) {
  .guess_object_field_spec_expand_fields(
    value,
    empty_list_unspecified,
    simplify_list,
    local_env,
    tib_fn = tib_fn,
    .names_to = if (rlang::is_named(value) && !is_empty(value)) ".names",
    ...
  )
}

#' Guess the spec for an object list field
#'
#' @inheritParams .shared-params
#' @returns A [tib_df()] spec keyed by `name`.
#' @keywords internal
.guess_object_field_spec_object_list <- function(
  value,
  name,
  empty_list_unspecified,
  simplify_list,
  local_env
) {
  .guess_object_field_spec_expand_fields_df(
    value,
    empty_list_unspecified,
    simplify_list,
    local_env,
    .key = name
  )
}

#' Guess the spec for a single field in an object list
#'
#' @inheritParams .shared-params
#' @returns A tib field spec.
#' @keywords internal
.guess_object_list_field_spec <- function(
  value,
  name,
  empty_list_unspecified,
  simplify_list,
  local_env
) {
  ptype_result <- .get_ptype_common(value, empty_list_unspecified)
  if (!ptype_result$has_common_ptype) {
    return(tib_variant(name))
  }

  ptype <- ptype_result$ptype
  if (is.null(ptype)) {
    return(tib_unspecified(name))
  }
  ptype_type <- .tib_type_of(ptype, name, other = FALSE)
  if (ptype_type == "vector") {
    return(.guess_object_list_field_spec_vector(
      value,
      name,
      ptype,
      ptype_result$had_empty_lists,
      local_env
    ))
  }
  if (ptype_type == "df") {
    cli::cli_abort("A list of dataframes is not yet supported.")
  }

  # every element is a list or NULL at this point
  if (all(vctrs::list_sizes(value) == 0) || .list_is_list_of_null(value)) {
    return(tib_unspecified(name))
  }

  value_flat <- .vec_flatten(value, list(), name_spec = NULL)
  if (.is_list_of_object_lists(value)) {
    return(.guess_object_field_spec_object_list(
      value_flat,
      name,
      empty_list_unspecified,
      simplify_list,
      local_env
    ))
  }

  if (!simplify_list) {
    return(.guess_object_list_field_spec_dont_simplify(
      value,
      name,
      empty_list_unspecified,
      simplify_list,
      local_env
    ))
  }

  ptype_result <- .get_ptype_common(value_flat, empty_list_unspecified)
  if (ptype_result$has_common_ptype && .is_field_scalar(value_flat)) {
    return(.guess_object_list_field_spec_flat_to_vector(
      value_flat,
      name,
      ptype_result
    ))
  }

  if (.is_object_list(value)) {
    return(.guess_object_list_field_spec_object_list_row(
      value,
      name,
      empty_list_unspecified,
      simplify_list,
      local_env
    ))
  }

  return(tib_variant(name))
}

#' Guess the spec for a vector-typed field in an object list
#'
#' @param had_empty_lists (`logical(1)` or `NULL`) Whether empty lists were
#'   dropped when computing the common ptype.
#' @inheritParams .shared-params
#' @returns A [tib_scalar()] or [tib_vector()] spec.
#' @keywords internal
.guess_object_list_field_spec_vector <- function(
  value,
  name,
  ptype,
  had_empty_lists,
  local_env
) {
  is_scalar <- .is_field_scalar(value)
  if (!is_scalar) {
    .mark_empty_list_argument(is_true(had_empty_lists), local_env)
  }
  .tib_scalar_or_vector_spec(name, ptype, is_scalar)
}

#' Guess the spec for a list field without list simplification
#'
#' @inheritParams .shared-params
#' @returns A tib field spec.
#' @keywords internal
.guess_object_list_field_spec_dont_simplify <- function(
  value,
  name,
  empty_list_unspecified,
  simplify_list,
  local_env
) {
  if (.is_object_list(value)) {
    return(
      .guess_object_list_field_spec_object_list_row(
        value,
        name,
        empty_list_unspecified,
        simplify_list,
        local_env
      )
    )
  }
  return(tib_variant(name))
}

#' Guess a vector spec from a flat list of field values
#'
#' @param value_flat (`list`) The flattened values of a list field.
#' @param ptype_result (`list`) The result of [.get_ptype_common()] applied to
#'   `value_flat`.
#' @inheritParams .shared-params
#' @returns A [tib_vector()] spec.
#' @keywords internal
.guess_object_list_field_spec_flat_to_vector <- function(
  value_flat,
  name,
  ptype_result
) {
  return(tib_vector(
    name,
    ptype_result$ptype,
    .input_form = .tib_vector_input_form(value_flat)
  ))
}

#' Guess a row spec from an object list field
#'
#' @inheritParams .shared-params
#' @returns A [tib_row()] spec.
#' @keywords internal
.guess_object_list_field_spec_object_list_row <- function(
  value,
  name,
  empty_list_unspecified,
  simplify_list,
  local_env
) {
  return(
    .guess_object_field_spec_expand_fields(
      value,
      empty_list_unspecified,
      simplify_list,
      local_env,
      tib_fn = tib_row,
      .key = name
    )
  )
}

#' Guess field specs for an object list
#'
#' @param object_list (`list`) A list of named lists (objects) whose fields
#'   are to be guessed.
#' @inheritParams .shared-params
#' @returns A named list of tib field specs.
#' @keywords internal
.guess_object_list_spec <- function(
  object_list,
  empty_list_unspecified,
  simplify_list,
  local_env
) {
  required <- .get_required(object_list)
  # need to remove empty elements for `purrr::transpose()` to work.
  object_list <- vctrs::list_drop_empty(object_list)
  x_t <- purrr::list_transpose(
    unname(object_list),
    template = names(required),
    simplify = FALSE
  )
  fields <- purrr::map2(
    x_t,
    names(required),
    \(value, name) {
      .guess_object_list_field_spec(
        value,
        name,
        empty_list_unspecified,
        simplify_list,
        local_env
      )
    }
  )
  .update_required_fields(fields, required)
}

#' Determine which fields are required in an object list
#'
#' @param sample_size (`integer(1)`) Maximum number of records to sample when
#'   `x` is large.
#' @inheritParams .shared-params
#' @returns A named logical vector indicating which fields are present in every
#'   element of `x`.
#' @keywords internal
.get_required <- function(x, sample_size = 10e3) {
  n <- vctrs::vec_size(x)
  x <- unname(x)
  if (n > sample_size) {
    n <- sample_size
    x <- vctrs::vec_slice(x, sample(n, sample_size))
  }
  names_count <- vctrs::vec_count(
    vctrs::list_unchop(lapply(x, names), ptype = character()),
    "location"
  )
  empty_loc <- lengths(x) == 0L
  if (any(empty_loc)) {
    rlang::rep_named(names_count$key, FALSE)
  } else {
    rlang::set_names(names_count$count == n, names_count$key)
  }
}

#' Is every element of a field scalar?
#'
#' @inheritParams .shared-params
#' @returns `TRUE` if every element has size 1 or is `NULL`, `FALSE` otherwise.
#' @keywords internal
.is_field_scalar <- function(value) {
  sizes <- vctrs::list_sizes(value)
  if (any(sizes > 1)) {
    return(FALSE)
  }

  # early exit for performance
  if (!any(sizes == 0)) {
    return(TRUE)
  }

  # check that all elements are `NULL`
  size_0_is_null <- vctrs::vec_detect_missing(value[sizes == 0])
  all(size_0_is_null)
}

#' Update the required status of field specs
#'
#' @param fields (`list`) A named list of tib field specs.
#' @param required (`logical`) A named logical vector of required statuses, as
#'   returned by [.get_required()].
#' @returns `fields` with the `$required` component of each spec updated.
#' @keywords internal
.update_required_fields <- function(fields, required) {
  for (field_name in names(required)) {
    fields[[field_name]]$required <- required[[field_name]]
  }
  fields
}

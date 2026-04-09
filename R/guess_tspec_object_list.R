#' @export
#' @rdname guess_tspec
guess_tspec_object_list <- function(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  arg = caller_arg(x),
  call = current_call()
) {
  check_dots_empty()
  check_bool(empty_list_unspecified, call = call)
  check_bool(simplify_list, call = call)
  check_bool(inform_unspecified, call = call)
  .check_list(x)

  withr::local_options(list(tibblify.used_empty_list_arg = NULL))

  fields <- .guess_object_list_spec(
    x,
    empty_list_unspecified = empty_list_unspecified,
    simplify_list = simplify_list
  )

  spec <- tspec_df(
    !!!fields,
    .names_to = if (rlang::is_named(x)) ".names",
    .vector_allows_empty_list = is_true(getOption(
      "tibblify.used_empty_list_arg"
    ))
  )
  if (inform_unspecified) {
    .spec_inform_unspecified(spec)
  }
  return(spec)
}

.guess_object_list_spec <- function(
  object_list,
  empty_list_unspecified,
  simplify_list
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
    function(value, name) {
      .guess_object_list_field_spec(
        value,
        name,
        empty_list_unspecified = empty_list_unspecified,
        simplify_list = simplify_list
      )
    }
  )

  .update_required_fields(fields, required)
}

.update_required_fields <- function(fields, required) {
  for (field_name in names(required)) {
    fields[[field_name]]$required <- required[[field_name]]
  }
  fields
}

.guess_object_list_vector_spec <- function(
  value,
  name,
  ptype,
  had_empty_lists
) {
  if (.is_field_scalar(value)) {
    tib_scalar(name, ptype)
  } else {
    .mark_empty_list_argument(is_true(had_empty_lists))
    tib_vector(name, ptype)
  }
}

.get_required <- function(x, sample_size = 10e3) {
  n <- vctrs::vec_size(x)
  x <- unname(x)
  if (n > sample_size) {
    n <- sample_size
    x <- vctrs::vec_slice(x, sample(n, sample_size))
  }

  all_names <- vctrs::list_unchop(lapply(x, names), ptype = character())
  names_count <- vctrs::vec_count(all_names, "location")

  empty_loc <- lengths(x) == 0L
  if (any(empty_loc)) {
    rlang::rep_named(names_count$key, FALSE)
  } else {
    rlang::set_names(names_count$count == n, names_count$key)
  }
}

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

# documentation ----------------------------------------------------------------

#' Create a field specification
#'
#' Use the `tib_*()` functions to specify how to process the fields of an
#' object.
#'
#' @param ... These dots are for future extensions and must be empty.
#' @inheritParams .shared-params-tib
#' @inheritParams .shared-params
#'
#' @details There are five families of `tib_*()` functions:
#'
#' * `tib_scalar(.ptype)`: Cast each instance of the field to a length-one
#'   vector of type `.ptype`. Inside [tspec_df()], this results in a column of
#'   the specified `.ptype`.
#' * `tib_vector(.ptype)`: Cast each instance of the field to an arbitrary
#'   length vector of type `.ptype`. Inside [tspec_df()], this results in a list
#'   column of vectors of the specified `.ptype`.
#' * `tib_variant()`: Cast each instance of the field to a list. Inside
#'   [tspec_df()], this results in a list column of lists.
#' * `tib_row()`: Cast each instance of the field to a 1-row tibble. Inside
#'   [tspec_df()], this results in a list column of 1-row tibbles.
#' * `tib_df()`: Cast each instance of the field to a tibble. Inside
#'   [tspec_df()], this results in a list column of tibbles (each of which can
#'   have multiple rows).
#'
#'   There are some special shortcuts of `tib_scalar()` and `tib_vector()` for
#'   the most common prototypes:
#'
#' * `logical()`: `tib_lgl()` and `tib_lgl_vec()`
#' * `integer()`: `tib_int()` and `tib_int_vec()`
#' * `double()`: `tib_dbl()` and `tib_dbl_vec()`
#' * `character()`: `tib_chr()` and `tib_chr_vec()`
#' * `Date`: `tib_date()` and `tib_date_vec()`
#'
#'   Further, there are special shortcuts for dates encoded as character:
#'   `tib_chr_date()` and `tib_chr_date_vec()`.
#'
#'   There are two other `tib_*()` functions for special cases:
#'
#' * `tib_recursive()`: Cast each instance of the field to a tibble, within
#'   which columns can themselves contain the same sorts of tibble, etc. Inside
#'   [tspec_df()], this results in a list column of tibbles, each row of which
#'   can itself contain a tibble, etc. This is intended for structures such as a
#'   directory tree.
#' * `tib_unspecified()`: Tag a field in the object as unspecified. The
#'   `unspecified` argument of [tibblify()] controls how such fields are
#'   handled. If you are constructing a specification manually (as opposed to
#'   using [guess_tspec()]), you should most likely specify such columns with
#'   `tib_variant()`, or leave them out of the spec entirely.
#'
#' @return A tibblify field collector. This specification can be used with
#'   [tspec_df()] or another `tspec_*()` function to specify how to process an
#'   object.
#' @name tib_spec
#'
#' @examples
#' tib_int("int")
#' tib_int("int", .required = FALSE, .fill = 0)
#'
#' # This is essentially how `tib_chr_date()` is implemented.
#' tib_scalar("date", Sys.Date(), .transform = function(x) as.Date(x, format = "%Y-%m-%d"))
#'
#' tib_df(
#'   "data",
#'   .names_to = "id",
#'   age = tib_int("age"),
#'   name = tib_chr("name")
#' )
NULL

# tib_collector ----------------------------------------------------------------

.tib_collector <- function(
  .key,
  .type,
  ...,
  .required = TRUE,
  .class = NULL,
  .transform = NULL,
  .elt_transform = NULL,
  .call = caller_env()
) {
  .check_key(.key, .call)
  check_bool(.required, call = .call)

  out <- list(
    type = .type,
    key = .key,
    required = .required,
    transform = .prep_transform(.transform, call = .call),
    elt_transform = .prep_transform(
      .elt_transform,
      .call,
      arg = ".elt_transform"
    ),
    ...
  )

  # We don't want to maintain dotted names past here.
  names(out) <- sub("^\\.", "", names(out))
  .class <- .choose_native_ptype(out$ptype, .class, out)
  class(out) <- unique(c(.class, paste0("tib_", .type), "tib_collector"))

  out
}

.check_key <- function(.key, .call = caller_env()) {
  check_character(.key, call = .call)
  n <- vec_size(.key)
  if (n == 0) {
    cli::cli_abort("{.arg .key} must not be empty.", call = .call)
  }
  if (n == 1) {
    if (is.na(.key)) {
      cli::cli_abort("{.arg .key} must not be {.val NA}.", call = .call)
    }
    if (.key == "") {
      cli::cli_abort("{.arg .key} must not be an empty string.", call = .call)
    }
  } else {
    if (vec_any_missing(.key)) {
      na_idx <- purrr::detect_index(vec_detect_missing(.key), ~.x)
      msg <- "`.key[{.field {na_idx}}] must not be NA."
      cli::cli_abort(msg, call = .call)
    }
    if (any(.key == "")) {
      empty_string_idx <- purrr::detect_index(.key == "", ~.x)
      msg <- "`.key[{.field {empty_string_idx}}] must not be an empty string."
      cli::cli_abort(msg, call = .call)
    }
  }
}

.choose_native_ptype <- function(ptype, class, fields) {
  if (!is.null(class)) {
    return(class)
  }
  cls <- tolower(class(ptype))
  if (
    isTRUE(fields$type %in% c("scalar", "vector")) &&
      length(cls) == 1 &&
      cls %in% c("logical", "integer", "numeric", "character", "date")
  ) {
    return(glue::glue("tib_{fields$type}_{cls}"))
  }
  return(NULL)
}

.prep_transform <- function(f, call, arg = ".transform") {
  if (is.null(f)) {
    return(f)
  }
  as_function(f, arg = arg, call = call)
}

.is_tib <- function(x) {
  inherits(x, "tib_collector")
}

# tib_scalar -------------------------------------------------------------------

#' @rdname tib_spec
#' @export
tib_scalar <- function(
  .key,
  .ptype,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = .ptype,
  .transform = NULL,
  key = deprecated(),
  ptype = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
) {
  check_dots_empty()
  .key <- .deprecate_arg(.key, key)
  # Previously ptype_inner would have been auto-filled from ptype, so resolve
  # that.
  if (lifecycle::is_present(ptype) && !lifecycle::is_present(ptype_inner)) {
    ptype_inner <- ptype
  }
  .ptype <- .deprecate_arg(.ptype, ptype)
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(
    .ptype_inner,
    ptype_inner,
    "tib_scalar"
  )
  .transform <- .deprecate_arg(.transform, transform)

  .tib_scalar_impl(
    .key = .key,
    .required = .required,
    .ptype = .ptype,
    .ptype_inner = .ptype_inner,
    .fill = .fill,
    .transform = .transform
  )
}

.tib_scalar_impl <- function(
  .key,
  .ptype,
  ...,
  .required = TRUE,
  .fill = vec_init(.ptype_inner),
  .ptype_inner = .ptype,
  .transform = NULL,
  .class = NULL,
  .call = caller_env()
) {
  .ptype <- vec_ptype(.ptype, x_arg = ".ptype", call = .call)
  .ptype_inner <- vec_ptype(.ptype_inner, x_arg = ".ptype_inner", call = .call)
  if (is.null(.fill)) {
    .fill <- vec_init(.ptype_inner)
  } else {
    obj_check_vector(.fill, call = .call)
    vec_check_size(.fill, size = 1L, call = .call)
    .fill <- vec_cast(
      .fill,
      .ptype_inner,
      call = .call,
      to_arg = ".ptype_inner"
    )
  }

  .tib_collector(
    .key = .key,
    .type = "scalar",
    .required = .required,
    .ptype = .ptype,
    .ptype_inner = .ptype_inner,
    .fill = .fill,
    .transform = .transform,
    ...,
    .class = .class,
    .call = .call
  )
}

.is_tib_scalar <- function(x) {
  inherits(x, "tib_scalar")
}

# tib_vector -------------------------------------------------------------------

#' @rdname tib_spec
#' @export
tib_vector <- function(
  .key,
  .ptype,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = .ptype,
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
  ptype = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated(),
  elt_transform = deprecated(),
  input_form = deprecated(),
  values_to = deprecated(),
  names_to = deprecated()
) {
  check_dots_empty()
  .key <- .deprecate_arg(.key, key)
  .ptype <- .deprecate_arg(.ptype, ptype)
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .elt_transform <- .deprecate_arg(.elt_transform, elt_transform)
  .input_form <- .deprecate_arg(.input_form, input_form)
  .values_to <- .deprecate_arg(.values_to, values_to)
  .names_to <- .deprecate_arg(.names_to, names_to)
  .tib_vector_impl(
    .key = .key,
    .required = .required,
    .ptype = .ptype,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform,
    .elt_transform = .elt_transform,
    .input_form = .input_form,
    .values_to = .values_to,
    .names_to = .names_to
  )
}

.tib_vector_impl <- function(
  .key,
  .ptype,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = .ptype,
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  .class = NULL,
  .call = caller_env()
) {
  .input_form <- arg_match0(
    .input_form,
    c("vector", "scalar_list", "object"),
    error_call = .call
  )
  .ptype <- vec_ptype(.ptype, call = .call, x_arg = ".ptype")
  .ptype_inner <- vec_ptype(.ptype_inner, call = .call, x_arg = ".ptype_inner")
  if (!is.null(.fill)) {
    .fill <- vec_cast(.fill, .ptype, call = .call, to_arg = ".ptype")
  }
  .values_to <- .stabilize_values_to(.values_to, .call)
  .names_to <- .stabilize_names_to(.names_to, .values_to, .input_form, .call)

  .tib_collector(
    .key = .key,
    .type = "vector",
    .required = .required,
    .ptype = .ptype,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform,
    .elt_transform = .elt_transform,
    .input_form = .input_form,
    .values_to = .values_to,
    .names_to = .names_to,
    ...,
    .class = .class,
    .call = .call
  )
}

.stabilize_values_to <- function(.values_to, .call) {
  if (!is.null(.values_to)) {
    check_string(.values_to, call = .call)
  }
  .values_to
}

.stabilize_names_to <- function(.names_to, .values_to, .input_form, .call) {
  if (!is.null(.names_to)) {
    if (is.null(.values_to)) {
      msg <- "{.arg .names_to} can only be used if {.arg .values_to} is not {.code NULL}."
      cli::cli_abort(msg, call = .call)
    }
    if (.input_form == "scalar_list") {
      msg <- '{.arg .names_to} can\'t be used for {.code .input_form = "scalar_list"}.'
      cli::cli_abort(msg, call = .call)
    }
    check_string(.names_to, call = .call)
    if (.names_to == .values_to) {
      msg <- "{.arg .names_to} must be different from {.arg .values_to}."
      cli::cli_abort(msg, call = .call)
    }
  }
  .names_to
}

.is_tib_vector <- function(x) {
  inherits(x, "tib_vector")
}

# tib_unspecified --------------------------------------------------------------

#' @rdname tib_spec
#' @export
tib_unspecified <- function(
  .key,
  ...,
  .required = TRUE,
  key = deprecated(),
  required = deprecated()
) {
  check_dots_empty()
  .key <- .deprecate_arg(.key, key)
  .required <- .deprecate_arg(.required, required)
  .tib_collector(
    .key = .key,
    .type = "unspecified",
    .required = .required,
    .class = "tib_unspecified"
  )
}

.is_tib_unspecified <- function(x) {
  inherits(x, "tib_unspecified")
}

# deprecation helper -----------------------------------------------------------

.deprecate_arg <- function(
  good_arg,
  bad_arg,
  fn_name = rlang::call_name(rlang::caller_call()),
  pkg_version = "0.4.0",
  good_arg_name = rlang::caller_arg(good_arg),
  bad_arg_name = rlang::caller_arg(bad_arg),
  call = rlang::caller_env(),
  user_env = rlang::caller_env(2)
) {
  force(fn_name)
  if (lifecycle::is_present(bad_arg)) {
    lifecycle::deprecate_soft(
      pkg_version,
      glue::glue("{fn_name}({bad_arg_name} = )"),
      glue::glue("{fn_name}({good_arg_name} = )"),
      env = call,
      user_env = user_env
    )
    return(bad_arg)
  }
  return(good_arg)
}

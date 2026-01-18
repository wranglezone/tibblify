# scalar fields ----------------------------------------------------------------

#' @rdname tib_spec
#' @export
tib_lgl <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = logical(),
  .transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
) {
  check_dots_empty()
  .key <- .deprecate_arg(.key, key)
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .tib_scalar_impl(
    .key,
    .ptype = logical(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform
  )
}

#' @rdname tib_spec
#' @export
tib_int <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = integer(),
  .transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
) {
  check_dots_empty()
  .key <- .deprecate_arg(.key, key)
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .tib_scalar_impl(
    .key,
    .ptype = integer(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform
  )
}

#' @rdname tib_spec
#' @export
tib_dbl <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = double(),
  .transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
) {
  check_dots_empty()
  .key <- .deprecate_arg(.key, key)
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .tib_scalar_impl(
    .key,
    .ptype = double(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform
  )
}

#' @rdname tib_spec
#' @export
tib_chr <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = character(),
  .transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
) {
  check_dots_empty()
  .key <- .deprecate_arg(.key, key)
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .tib_scalar_impl(
    .key,
    .ptype = character(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform
  )
}

#' @rdname tib_spec
#' @export
tib_date <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = vctrs::new_date(),
  .transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
) {
  check_dots_empty()
  .key <- .deprecate_arg(.key, key)
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .tib_scalar_impl(
    .key,
    .ptype = vctrs::new_date(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform
  )
}

#' @rdname tib_spec
#' @export
tib_chr_date <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .format = "%Y-%m-%d",
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  format = deprecated()
) {
  check_dots_empty()
  .key <- .deprecate_arg(.key, key)
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .format <- .deprecate_arg(.format, format)
  .tib_scalar_impl(
    .key,
    .ptype = vctrs::new_date(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = character(),
    .format = .format,
    .transform = ~ as.Date(.x, format = .format),
    .class = "tib_scalar_chr_date"
  )
}

# vector fields ----------------------------------------------------------------

#' @rdname tib_spec
#' @export
tib_lgl_vec <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = logical(),
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
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
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .elt_transform <- .deprecate_arg(.elt_transform, elt_transform)
  .input_form <- .deprecate_arg(.input_form, input_form)
  .values_to <- .deprecate_arg(.values_to, values_to)
  .names_to <- .deprecate_arg(.names_to, names_to)
  .tib_vector_impl(
    .key,
    .ptype = logical(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform,
    .elt_transform = .elt_transform,
    .input_form = .input_form,
    .values_to = .values_to,
    .names_to = .names_to
  )
}

#' @rdname tib_spec
#' @export
tib_int_vec <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = integer(),
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
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
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .elt_transform <- .deprecate_arg(.elt_transform, elt_transform)
  .input_form <- .deprecate_arg(.input_form, input_form)
  .values_to <- .deprecate_arg(.values_to, values_to)
  .names_to <- .deprecate_arg(.names_to, names_to)
  .tib_vector_impl(
    .key,
    .ptype = integer(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform,
    .elt_transform = .elt_transform,
    .input_form = .input_form,
    .values_to = .values_to,
    .names_to = .names_to
  )
}

#' @rdname tib_spec
#' @export
tib_dbl_vec <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = double(),
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
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
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .elt_transform <- .deprecate_arg(.elt_transform, elt_transform)
  .input_form <- .deprecate_arg(.input_form, input_form)
  .values_to <- .deprecate_arg(.values_to, values_to)
  .names_to <- .deprecate_arg(.names_to, names_to)
  .tib_vector_impl(
    .key,
    .ptype = double(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform,
    .elt_transform = .elt_transform,
    .input_form = .input_form,
    .values_to = .values_to,
    .names_to = .names_to
  )
}

#' @rdname tib_spec
#' @export
tib_chr_vec <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = character(),
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
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
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .elt_transform <- .deprecate_arg(.elt_transform, elt_transform)
  .input_form <- .deprecate_arg(.input_form, input_form)
  .values_to <- .deprecate_arg(.values_to, values_to)
  .names_to <- .deprecate_arg(.names_to, names_to)
  .tib_vector_impl(
    .key,
    .ptype = character(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform,
    .elt_transform = .elt_transform,
    .input_form = .input_form,
    .values_to = .values_to,
    .names_to = .names_to
  )
}

#' @rdname tib_spec
#' @export
tib_date_vec <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = vctrs::new_date(),
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
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
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .ptype_inner <- .deprecate_arg(.ptype_inner, ptype_inner)
  .transform <- .deprecate_arg(.transform, transform)
  .elt_transform <- .deprecate_arg(.elt_transform, elt_transform)
  .input_form <- .deprecate_arg(.input_form, input_form)
  .values_to <- .deprecate_arg(.values_to, values_to)
  .names_to <- .deprecate_arg(.names_to, names_to)
  .tib_vector_impl(
    .key,
    .ptype = vctrs::new_date(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform,
    .elt_transform = .elt_transform,
    .input_form = .input_form,
    .values_to = .values_to,
    .names_to = .names_to
  )
}

#' @rdname tib_spec
#' @export
tib_chr_date_vec <- function(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  .format = "%Y-%m-%d",
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  input_form = deprecated(),
  values_to = deprecated(),
  names_to = deprecated(),
  format = deprecated()
) {
  .key <- .deprecate_arg(.key, key)
  .required <- .deprecate_arg(.required, required)
  .fill <- .deprecate_arg(.fill, fill)
  .input_form <- .deprecate_arg(.input_form, input_form)
  .values_to <- .deprecate_arg(.values_to, values_to)
  .names_to <- .deprecate_arg(.names_to, names_to)
  .format <- .deprecate_arg(.format, format)
  .tib_vector_impl(
    .key,
    .ptype = vctrs::new_date(),
    .required = .required,
    .fill = .fill,
    .ptype_inner = character(),
    .format = .format,
    .transform = ~ as.Date(.x, format = .format),
    .input_form = .input_form,
    .values_to = .values_to,
    .names_to = .names_to,
    .class = "tib_vector_chr_date"
  )
}

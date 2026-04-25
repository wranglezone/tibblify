#' Printing tibblify specifications
#'
#' The `print()` and `format()` methods for tibblify specifications provide the
#' code necessary to generate the specification. Function names are color-coded
#' to help visually distinguish different types of collectors.
#'
#' @param x (`any`) The spec to format or print.
#' @param ... These dots are for future extensions and must be empty.
#' @inheritParams .shared-params
#'
#' @returns For `print()` methods, `x` is returned invisibly. `format()` methods
#'   return a length-1 character vector.
#' @name formatting
#' @export
#'
#' @examples
#' spec <- tspec_df(
#'   a = tib_int("a"),
#'   new_name = tib_chr("b"),
#'   row = tib_row(
#'     "row",
#'     x = tib_int("x")
#'   )
#' )
#' print(spec, names = FALSE)
#' print(spec, names = TRUE)
print.tib_collector <- function(x, width = NULL, ..., names = NULL) {
  names <- .check_print_names_arg(names)
  cat(format(x, width = width, ..., names = names))
  invisible(x)
}

#' @rdname formatting
#' @export
format.tib_scalar <- function(
  x,
  ...,
  .fill = NULL,
  .ptype_inner = NULL,
  .transform = NULL,
  multi_line = FALSE,
  nchar_indent = 0,
  width = NULL,
  names = FALSE
) {
  f_name <- .format_tib_f(x)
  parts <- .format_tib_parts(
    f_name = f_name,
    x = x,
    ...,
    .fill = .fill,
    .ptype_inner = .ptype_inner,
    .transform = .transform,
    multi_line = multi_line,
    nchar_indent = nchar_indent,
    width = width,
    names = names
  )
  paste0(f_name, "(", parts, ")")
}

#' @rdname formatting
#' @export
format.tib_variant <- function(
  x,
  ...,
  multi_line = FALSE,
  nchar_indent = 0,
  width = NULL
) {
  format.tib_scalar(
    x = x,
    .elt_transform = x$elt_transform,
    multi_line = multi_line,
    nchar_indent = nchar_indent,
    width = width
  )
}

#' @rdname formatting
#' @export
format.tib_vector <- function(
  x,
  ...,
  multi_line = FALSE,
  nchar_indent = 0,
  width = NULL
) {
  format.tib_scalar(
    x = x,
    .elt_transform = x$elt_transform,
    .input_form = if (!identical(x$input_form, "vector")) {
      .double_quote(x$input_form)
    },
    .values_to = .double_quote(x$values_to),
    .names_to = .double_quote(x$names_to),
    multi_line = multi_line,
    nchar_indent = nchar_indent,
    width = width
  )
}

#' @rdname formatting
#' @export
format.tib_unspecified <- format.tib_scalar

#' @rdname formatting
#' @export
format.tib_scalar_chr_date <- function(
  x,
  ...,
  multi_line = FALSE,
  nchar_indent = 0,
  width = NULL
) {
  format.tib_scalar(
    x = x,
    .fill = if (identical(x$fill, NA_character_)) zap(),
    .ptype_inner = zap(),
    .format = if (x$format != "%Y-%m-%d") .double_quote(x$format),
    .transform = zap(),
    multi_line = multi_line,
    nchar_indent = nchar_indent,
    width = width
  )
}

#' @rdname formatting
#' @export
format.tib_vector_chr_date <- format.tib_scalar_chr_date

#' @rdname formatting
#' @export
format.tib_row <- function(x, ..., width = NULL, names = NULL) {
  names <- .check_print_names_arg(names)
  .format_fields(
    .format_tib_f(x),
    fields = x$fields,
    width = width,
    args = list(
      deparse(x$key),
      `.required` = if (!x$required) FALSE
    ),
    force_names = names
  )
}

#' @rdname formatting
#' @export
format.tib_df <- function(x, ..., width = NULL, names = NULL) {
  names <- .check_print_names_arg(names)
  .format_fields(
    .format_tib_f(x),
    fields = x$fields,
    width = width,
    args = list(
      deparse(x$key),
      `.required` = if (!x$required) FALSE,
      .names_to = .double_quote(x$names_col)
    ),
    force_names = names
  )
}

#' @rdname formatting
#' @export
format.tib_recursive <- function(x, ..., width = NULL, names = NULL) {
  names <- .check_print_names_arg(names)
  .format_fields(
    .format_tib_f(x),
    fields = x$fields,
    width = width,
    args = list(
      deparse(x$key),
      `.children` = .double_quote(x$child),
      .children_to = if (x$child != x$children_to) .double_quote(x$children_to),
      `.required` = if (!x$required) FALSE
    ),
    force_names = names
  )
}


# .format_tib_f ----

#' Return the display function name for a collector
#'
#' @param x A tibblify collector object.
#' @returns (`character(1)`) The (possibly ANSI-colored) function name string.
#' @keywords internal
.format_tib_f <- function(x) {
  UseMethod(".format_tib_f")
}

#' @export
.format_tib_f.tib_unspecified <- function(x) {
  "tib_unspecified"
}

#' @export
.format_tib_f.tib_scalar_logical <- function(x) {
  cli::col_yellow("tib_lgl")
}
#' @export
.format_tib_f.tib_scalar_integer <- function(x) {
  cli::col_green("tib_int")
}
#' @export
.format_tib_f.tib_scalar_numeric <- function(x) {
  cli::col_green("tib_dbl")
}
#' @export
.format_tib_f.tib_scalar_character <- function(x) {
  cli::col_red("tib_chr")
}
#' @export
.format_tib_f.tib_scalar_date <- function(x) {
  "tib_date"
}
#' @export
.format_tib_f.tib_scalar_chr_date <- function(x) {
  "tib_chr_date"
}
#' @export
.format_tib_f.tib_scalar <- function(x) {
  "tib_scalar"
}

#' @export
.format_tib_f.tib_vector_logical <- function(x) {
  cli::col_yellow("tib_lgl_vec")
}
#' @export
.format_tib_f.tib_vector_integer <- function(x) {
  cli::col_green("tib_int_vec")
}
#' @export
.format_tib_f.tib_vector_numeric <- function(x) {
  cli::col_green("tib_dbl_vec")
}
#' @export
.format_tib_f.tib_vector_character <- function(x) {
  cli::col_red("tib_chr_vec")
}
#' @export
.format_tib_f.tib_vector_date <- function(x) {
  cli::col_red("tib_date_vec")
}
#' @export
.format_tib_f.tib_vector_chr_date <- function(x) {
  "tib_chr_date_vec"
}
#' @export
.format_tib_f.tib_vector <- function(x) {
  "tib_vector"
}

#' @export
.format_tib_f.tib_variant <- function(x) {
  "tib_variant"
}

#' @export
.format_tib_f.tib_row <- function(x) {
  cli::col_magenta("tib_row")
}
#' @export
.format_tib_f.tib_df <- function(x) {
  cli::col_magenta("tib_df")
}
#' @export
.format_tib_f.tib_recursive <- function(x) {
  cli::col_magenta("tib_recursive")
}

#' @export
.format_tib_f.default <- function(x) {
  class(x)[[1]]
}


# format_tib_parts ----

#' Build the formatted argument string for a collector call
#'
#' @param x A tibblify collector object.
#' @param ... Additional named arguments to include verbatim in the output,
#'   forwarded from the calling `format.*` method.
#' @inheritParams .shared-params
#' @returns (`character(1)`) A string of comma-separated, possibly wrapped
#'   arguments ready to be placed inside the parentheses of the collector call.
#' @keywords internal
.format_tib_parts <- function(
  f_name,
  x,
  ...,
  .fill = NULL,
  .ptype_inner = NULL,
  .transform = NULL,
  multi_line = FALSE,
  nchar_indent = 0,
  width = NULL,
  names = FALSE
) {
  nchar_prefix <- nchar_indent + cli::ansi_nchar(f_name) + 2
  parts <- list(
    deparse(x$key),
    .ptype = .format_ptype_arg(x),
    .required = if (!x$required) FALSE,
    .fill = .format_fill_arg(x, .fill),
    .ptype_inner = .format_ptype_inner(x, .ptype_inner),
    .transform = if (!rlang::is_zap(.transform)) x$transform,
    ...
  )
  .collapse_with_pad(
    parts[!vctrs::vec_detect_missing(parts)],
    multi_line = multi_line,
    nchar_prefix = nchar_prefix,
    width = width
  )
}

## format ptype ---------------------------------------------------------------

#' Format the `.ptype_inner` argument for display
#'
#' @inheritParams .format_tib_parts
#' @returns (`character(1)` or `NULL`) The formatted `.ptype` string, or `NULL`
#'   if the argument should be omitted.
#' @keywords internal
.format_ptype_inner <- function(x, .ptype_inner) {
  if (rlang::is_zap(.ptype_inner) || is.null(x$ptype_inner)) {
    return(NULL)
  }
  if (!identical(x$ptype, x$ptype_inner)) .format_ptype(x$ptype_inner)
}

#' Format the `.ptype` argument for display
#'
#' @inheritParams .format_tib_parts
#' @returns (`character(1)` or `NULL`) The formatted ptype string, or `NULL` if
#'   the argument should be omitted.
#' @keywords internal
.format_ptype_arg <- function(x) {
  if (!class(x)[1] %in% c("tib_scalar", "tib_vector")) {
    return(NULL)
  }
  .format_ptype(x$ptype)
}

#' Format a ptype object as a character string
#'
#' @param x (`ptype`) A prototype object.
#' @returns (`character(1)`) An R expression string representing `x`.
#' @keywords internal
.format_ptype <- function(x) {
  UseMethod(".format_ptype")
}

#' @export
.format_ptype.default <- function(x) {
  deparse(x)
}

#' @export
.format_ptype.difftime <- function(x) {
  if (!identical(class(x), "difftime")) {
    return(deparse(x))
  }
  "vctrs::new_duration()"
}

#' @export
.format_ptype.Date <- function(x) {
  if (!vctrs::vec_is(x, vctrs::new_date())) {
    return(deparse(x))
  }
  "vctrs::new_date()"
}

#' @export
.format_ptype.POSIXct <- function(x) {
  tzone <- attr(x, "tzone")
  tzone_str <- if (!is.null(tzone)) paste0("tzone = ", deparse(tzone))
  paste0("vctrs::new_datetime(", tzone_str, ")")
}


## format fill ----------------------------------------------------------------

#' Format the `.fill` argument for display
#'
#' @inheritParams .format_tib_parts
#' @returns (`character(1)` or `NULL`) The formatted fill string, or `NULL` if
#'   the argument should be omitted.
#' @keywords internal
.format_fill_arg <- function(x, .fill) {
  if (rlang::is_zap(.fill) || is.null(x$fill)) {
    return(NULL)
  }
  if (.is_tib_variant(x) || .is_tib_unspecified(x)) {
    return(deparse(x$fill))
  }
  if (.is_tib_scalar(x)) {
    canonical_default <- vctrs::vec_init(x$ptype_inner)
  } else if (.is_tib_vector(x)) {
    canonical_default <- vctrs::vec_init(x$ptype)
  } else {
    # nocov start
    cli::cli_abort(
      "{.arg x} has unexpected type {.cls class(x)}.",
      .internal = TRUE
    )
    # nocov end
  }
  if (
    vctrs::vec_size(x$fill) == 1 &&
      vctrs::vec_equal(x$fill, canonical_default, na_equal = TRUE)
  ) {
    return(NULL)
  }
  .format_fill(x$fill)
}

#' Format a fill value as a character string
#'
#' @param x A fill value.
#' @returns (`character(1)`) An R expression string representing `x`.
#' @keywords internal
.format_fill <- function(x) {
  UseMethod(".format_fill")
}

#' @export
.format_fill.default <- function(x) {
  deparse(x)
}

#' @export
.format_fill.Date <- function(x) {
  paste0("as.Date(", .double_quote(format(x, format = "%Y-%m-%d")), ")")
}

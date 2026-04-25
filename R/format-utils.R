#' Title
#'
#' @param fields (`list`) Fields to format.
#' @param args (`list`) Additional arguments to format and prepend before
#'   fields.
#' @inheritParams .shared-params
#' @returns A single string with the formatted fields.
#' @keywords internal
.format_fields <- function(f_name, fields, width, force_names, args = NULL) {
  parts <- .collect_parts(fields, width, force_names, args)
  if (is_empty(parts)) {
    return(paste0(f_name, "()"))
  }
  inner <- .collapse_with_pad(parts, multi_line = TRUE, width = width)
  paste0(f_name, "(", inner, ")")
}

#' Collect formatted field parts
#'
#' @inheritParams .format_fields
#' @returns A character vector of formatted field parts.
#' @keywords internal
.collect_parts <- function(fields, width, force_names, args) {
  fields_formatted <- .format_field_canonical_names(fields, width, force_names)
  args <- args[!vctrs::vec_detect_missing(args)]
  c(args, fields_formatted)
}

#' Format field parts with canonical names
#'
#' @inheritParams .format_fields
#' @returns A character vector of formatted field parts with canonical names
#'   potentially suppressed.
#' @keywords internal
.format_field_canonical_names <- function(fields, width, force_names) {
  if (force_names) {
    nchar_indent_vector <- 0L
  } else {
    canonical <- purrr::map2_lgl(fields, names2(fields), .is_tib_name_canonical)
    names2(fields)[canonical] <- ""
    nchar_indent_vector <- ifelse(canonical, 0L, .nchar_field_names(fields))
  }
  purrr::map2(
    fields,
    nchar_indent_vector,
    \(col, nchar_indent) {
      format(col, nchar_indent = nchar_indent, width = width)
    }
  )
}

#' Check if a tib field has a canonical name
#'
#' @param field (`list`) A tib field.
#' @param name (`character(1)`) The name to check against the field's key.
#' @returns `TRUE` if the field's key is a single string that matches `name`,
#'   `FALSE` otherwise.
#' @keywords internal
.is_tib_name_canonical <- function(field, name) {
  key <- field$key
  is.character(key) && vctrs::vec_size(key) == 1 && key == name
}

#' Calculate the number of characters in a field's name part
#'
#' @inheritParams .format_fields
#' @returns An integer vector of the number of characters in the name part of
#'   each field, including the "=" separator and a trailing comma.
#' @keywords internal
.nchar_field_names <- function(fields) {
  nchar(paste0(names(fields), " = ", ","))
}

#' Wrap a string in double quotes if it's not `NULL`
#'
#' @param x (`character(1)` or `NULL`) A string to wrap in double quotes, or
#'   `NULL`.
#' @returns The input string wrapped in double quotes if it was not `NULL`, or
#'   `NULL`.
#' @keywords internal
.double_quote <- function(x) {
  x %&&% paste0('"', x, '"')
}

#' Collapse expressions with padding and optional multi-line formatting
#'
#' @param x (`list`) Expressions to collapse.
#' @param nchar_prefix (`integer(1)`) The number of characters that are "used
#'   up" by any prefix portions of the output. Used to determine whether the
#'   output will fit on a single line or if it should be wrapped across multiple
#'   lines.
#' @inheritParams .shared-params
#' @returns A single string with the expressions collapsed, either on a single
#'   line or wrapped across multiple lines with indentation.
#' @keywords internal
.collapse_with_pad <- function(x, multi_line, nchar_prefix = 0, width) {
  x <- .name_exprs(x, names2(x), names2(x) != "")
  x_single_line <- paste0(x, collapse = ", ")
  line_length <- nchar(x_single_line) + nchar_prefix
  if (multi_line || length(x) > 2 || line_length > .tibblify_width(width)) {
    return(.paste_multiline(x))
  }
  x_single_line
}

#' Collapse expressions with padding and optional multi-line formatting
#'
#' @param exprs (`list`) Expressions to collapse.
#' @param names (`character`) Names corresponding to the expressions.
#' @param show_name (`logical`) A vector indicating whether each name should be
#'   shown.
#' @returns A character vector of the expressions with names prepended where
#'   `show_name` is `TRUE`. Non-syntactic names are backticked. If `show_name`
#'   is `FALSE`, the expressions are returned without names.
#' @keywords internal
.name_exprs <- function(exprs, names, show_name) {
  # nocov start
  if (!length(names) || !length(exprs)) {
    cli::cli_abort("Empty names or empty exprs", .internal = TRUE)
  }
  # nocov end
  non_syn <- make.names(names) != names
  names[non_syn] <- .backtick(names[non_syn])
  ifelse(show_name, paste(names, "=", exprs), exprs)
}

#' Backtick-wrap a character vector
#'
#' @param x (`character`) A character vector to backtick-wrap.
#' @returns A character vector with each element wrapped in backticks and any
#'   existing backticks escaped with a backslash.
#' @keywords internal
.backtick <- function(x) {
  paste0("`", gsub("`", "\\\\`", x), "`")
}

#' Get the width for tibblifying
#'
#' @inheritParams .shared-params
#' @returns The width to use for tibblifying, either the provided `width` or the
#'   value of the `width` option if `width` is `NULL`.
#' @keywords internal
.tibblify_width <- function(width = NULL) {
  width %||% getOption("width")
}

#' Pad and collapse a character vector across multiple lines
#'
#' @param x (`character`) A vector to pad and collapse.
#' @returns A single string with the elements of `x` padded and collapsed across
#'   multiple lines, with a leading newline and a trailing comma on each line.
#' @keywords internal
.paste_multiline <- function(x) {
  paste0("\n", paste0(.pad(x, 2), ",", collapse = "\n"), "\n")
}

#' Pad a character vector with a specified number of spaces
#'
#' @param x (`character`) A vector to pad.
#' @param n (`integer`) The number of spaces to use for padding.
#' @returns A character vector with each element of `x` prepended with `n`
#'   spaces. If an element of `x` contains newlines, each line will be prepended
#'   with `n` spaces.
#' @keywords internal
.pad <- function(x, n) {
  whitespaces <- paste0(rep(" ", n), collapse = "")
  x <- gsub("\n", paste0("\n", whitespaces), x)
  paste0(whitespaces, x)
}

#' Check and determine whether to print names for tibblifying
#'
#' @inheritParams .shared-params
#' @returns A logical value indicating whether to print names for tibblifying,
#'   based on the provided `names` argument or the `tibblify.print_names` option
#'   if `names` is `NULL`.
#' @keywords internal
.check_print_names_arg <- function(names) {
  rlang::check_bool(names, allow_null = TRUE)
  names %||% .should_force_names()
}

#' Determine whether to print names for tibblifying
#'
#' @returns A logical value indicating whether to print names for tibblifying,
#'   based on the `tibblify.print_names` option.
#' @keywords internal
.should_force_names <- function() {
  as.logical(getOption("tibblify.print_names", default = FALSE))
}

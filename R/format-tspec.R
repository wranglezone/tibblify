#' @rdname formatting
#' @export
print.tspec <- function(x, width = NULL, ..., names = NULL) {
  names <- .check_print_names_arg(names)
  cat(format(x, width = width, ..., names = names))
  invisible(x)
}

#' @rdname formatting
#' @export
format.tspec_df <- function(x, width = NULL, ..., names = NULL) {
  names <- .check_print_names_arg(names)
  .format_fields(
    "tspec_df",
    fields = x$fields,
    width = width,
    args = list(
      .names_to = if (!is.null(x$names_col)) deparse(x$names_col),
      .vector_allows_empty_list = if (x$vector_allows_empty_list) {
        x$vector_allows_empty_list
      },
      .input_form = if (x$input_form != "rowmajor") .double_tick(x$input_form)
    ),
    force_names = names
  )
}

#' @rdname formatting
#' @export
format.tspec_row <- function(x, width = NULL, ..., names = NULL) {
  names <- .check_print_names_arg(names)
  .format_fields(
    "tspec_row",
    fields = x$fields,
    width = width,
    args = list(
      .vector_allows_empty_list = if (x$vector_allows_empty_list) {
        x$vector_allows_empty_list
      },
      .input_form = if (x$input_form != "rowmajor") .double_tick(x$input_form)
    ),
    force_names = names
  )
}

#' @rdname formatting
#' @export
format.tspec_recursive <- function(x, width = NULL, ..., names = NULL) {
  names <- .check_print_names_arg(names)
  .format_fields(
    "tspec_recursive",
    fields = x$fields,
    width = width,
    args = list(
      .children = .double_tick(x$child),
      .children_to = if (x$child != x$children_to) .double_tick(x$children_to),
      .vector_allows_empty_list = if (x$vector_allows_empty_list) {
        x$vector_allows_empty_list
      },
      .input_form = if (x$input_form != "rowmajor") .double_tick(x$input_form)
    ),
    force_names = names
  )
}

#' @rdname formatting
#' @export
format.tspec_object <- function(x, width = NULL, ..., names = NULL) {
  names <- .check_print_names_arg(names)
  .format_fields(
    "tspec_object",
    fields = x$fields,
    width = width,
    args = list(
      .vector_allows_empty_list = if (x$vector_allows_empty_list) {
        x$vector_allows_empty_list
      },
      .input_form = if (x$input_form != "rowmajor") .double_tick(x$input_form)
    ),
    force_names = names
  )
}

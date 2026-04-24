# Shared infrastructure used by both tspec and tib format methods.

.format_fields <- function(f_name, fields, width, args = NULL, force_names) {
  if (force_names) {
    canonical_name <- FALSE
  } else {
    canonical_name <- purrr::map2_lgl(
      fields,
      names2(fields),
      .is_tib_name_canonical
    )
    names2(fields)[canonical_name] <- ""
  }

  fields_formatted <- purrr::map2(
    fields,
    ifelse(canonical_name, 0, nchar(paste0(names(fields), " = ", ","))),
    function(col, nchar_indent) {
      format(
        col,
        nchar_indent = nchar_indent,
        width = width
      )
    }
  )

  args <- args[!vctrs::vec_detect_missing(args)]
  if (is_empty(args)) {
    parts <- fields_formatted
  } else {
    parts <- c(args, fields_formatted)
  }

  if (is_empty(parts)) {
    return(paste0(f_name, "()"))
  }

  inner <- .collapse_with_pad(
    parts,
    multi_line = TRUE,
    width = width
  )

  paste0(
    f_name,
    "(",
    inner,
    ")"
  )
}

.is_tib_name_canonical <- function(field, name) {
  key <- field$key
  if (vctrs::vec_size(key) > 1 || !is.character(key)) {
    return(FALSE)
  }

  key == name
}

.double_tick <- function(x) {
  if (is.null(x)) {
    return(NULL)
  }

  paste0('"', x, '"')
}

.collapse_with_pad <- function(x, multi_line, nchar_prefix = 0, width) {
  x_nms <- names2(x)
  x <- .name_exprs(x, x_nms, x_nms != "")
  x_single_line <- paste0(x, collapse = ", ")
  line_length <- nchar(x_single_line) + nchar_prefix
  if (multi_line || length(x) > 2 || line_length > .tibblify_width(width)) {
    paste0("\n", paste0(.pad(x, 2), ",", collapse = "\n"), "\n")
  } else {
    x_single_line
  }
}

.tibblify_width <- function(width = NULL) {
  width %||% getOption("width")
}

.is_syntactic <- function(x) {
  make.names(x) == x
}

.pad <- function(x, n) {
  whitespaces <- paste0(rep(" ", n), collapse = "")
  x <- gsub("\n", paste0("\n", whitespaces), x)
  paste0(whitespaces, x)
}

.name_exprs <- function(exprs, names, show_name) {
  # nocov start
  if (!length(names) || !length(exprs)) {
    cli::cli_abort("Empty names or empty exprs", .internal = TRUE)
  }
  # nocov end
  non_syntactic <- !.is_syntactic(names)
  names[non_syntactic] <- paste0(
    "`",
    gsub("`", "\\\\`", names[non_syntactic]),
    "`"
  )
  ifelse(show_name, paste(names, "=", exprs), exprs)
}

.should_force_names <- function() {
  as.logical(getOption("tibblify.print_names", default = FALSE))
}

.check_print_names_arg <- function(names) {
  rlang::check_bool(names, allow_null = TRUE)
  names %||% .should_force_names()
}

#' Inform about or error for unspecified fields
#'
#' @inheritParams tibblify
#' @inheritParams .shared-params
#' @returns The original spec, invisibly.
#' @keywords internal
.spec_inform_unspecified <- function(
  spec,
  unspecified = "inform",
  call = caller_env()
) {
  if (unspecified %in% c("inform", "error")) {
    unspecified_paths <- .get_unspecified_paths(spec)
    lines <- .format_unspecified_paths(unspecified_paths)
    if (length(lines)) {
      msg <- c(
        "The spec contains {length(lines)} unspecified field{?s}:",
        rlang::set_names(lines, "*"),
        "\n"
      )
      switch(
        unspecified,
        inform = cli::cli_inform(msg),
        error = cli::cli_abort(msg, call = call)
      )
    }
  }
  invisible(spec)
}

#' Prep unspecified paths for messaging
#'
#' @param path_list (`list`) A list of [tib_unspecified()] objects and objects
#'   containing [tib_unspecified()] objects.
#' @param path (`character`) Current path prefix.
#' @returns The formatted paths as `character`.
#' @keywords internal
.format_unspecified_paths <- function(path_list, path = character()) {
  nms <- names(path_list)
  lines <- character()

  for (i in seq_along(path_list)) {
    nm <- nms[i]
    elt <- path_list[[i]]
    if (is.character(elt)) {
      new_lines <- paste0(path, cli::style_bold(nm))
    } else {
      new_path <- paste0(path, nm, "->")
      new_lines <- .format_unspecified_paths(elt, path = new_path)
    }

    lines <- c(lines, new_lines)
  }

  lines
}

#' Find unspecified fields
#'
#' @inheritParams tibblify
#' @returns A list of [tib_unspecified()] objects and objects containing
#'   [tib_unspecified()] objects.
#' @keywords internal
.get_unspecified_paths <- function(spec) {
  fields <- spec$fields
  unspecified_paths <- list()

  for (i in seq_along(fields)) {
    field <- fields[[i]]
    nm <- names(fields)[[i]]
    if (field$type == "unspecified") {
      unspecified_paths[[nm]] <- nm
    } else if (field$type %in% c("df", "row")) {
      sub_paths <- .get_unspecified_paths(field)
      unspecified_paths[[nm]] <- sub_paths
    }
  }

  unspecified_paths
}

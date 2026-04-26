#' Convert a data frame to a tree
#'
#' Recursively nest data frame rows based on parent-child relationships, defined
#' by an id column and a parent column. Children become sub-tibbles of their
#' parent rows. This structure is intended for representing tree-like data, such
#' as organizational charts, file systems, category trees, or any other
#' hierarchical relationships.
#'
#' @param x (`data.frame`) The data frame to nest.
#' @inheritParams .shared-params
#'
#' @returns A tree-like, recursively nested data frame.
#' @export
#'
#' @examples
#' df <- tibble::tibble(
#'   id = 1:5,
#'   x = letters[1:5],
#'   parent = c(NA, NA, 1L, 2L, 4L)
#' )
#' df
#'
#' # Only the root elements are in the top-level tibble.
#' out <- nest_tree(df, id, parent, "children")
#' out
#'
#' # The children of each element are stored in the "children" column.
#' out$children
#'
#' # "d" (id 4) is a child of "b" (id 2), and "e" (id 5) is a child of "d"
#' # (id 4).
#' out$children[[2]]$children
nest_tree <- function(x, id_col, parent_col, children_to) {
  .check_is_df(x)
  id_col <- .normalize_id_col(rlang::enquo(id_col), x)
  id_col_name <- colnames(x)[[id_col]]
  parent_col <- .normalize_parent_col(
    rlang::enquo(parent_col),
    x,
    id_col,
    id_col_name
  )
  children_to <- .check_children_to(children_to, id_col, parent_col)
  return(.nest_tree_impl(
    x,
    id_col,
    parent_col,
    children_to,
    id_col_name
  ))
}

# helpers ----

## check args ----

#' Confirm that an object is a data frame
#'
#' @inheritParams .shared-params
#' @returns The input object.
#' @keywords internal
.check_is_df <- function(x, x_arg = caller_arg(x), call = caller_env()) {
  if (!is.data.frame(x)) {
    cli::cli_abort(
      "{.arg {x_arg}} must be a data frame.",
      class = c("tibblify-error-invalid_data_frame", "tibblify-error"),
      call = call
    )
  }
  x
}

#' Confirm that `children_to` is a single string that is different from `id_col` and `parent_col`
#'
#' @inheritParams .shared-params
#' @returns The input `children_to` object as a string.
#' @keywords internal
.check_children_to <- function(
  children_to,
  id_col,
  parent_col,
  call = caller_env()
) {
  children_to <- vctrs::vec_cast(children_to, character(), call = call)
  vctrs::vec_check_size(children_to, size = 1L, call = call)
  .check_arg_different(
    children_to,
    id_col = names(id_col),
    parent_col = names(parent_col),
    call = call
  )
  children_to
}

### normalize ID column ----

#' Normalize and check the id column
#'
#' @inheritParams .shared-params
#' @returns The integer index of the id column.
#' @keywords internal
.normalize_id_col <- function(id_col, x, call = caller_env()) {
  .eval_pull(x, id_col, "id_col", call = call) |>
    .check_id_col(x, call = call)
}

#' Check that id column has no missing or duplicate values
#'
#' @inheritParams .shared-params
#' @returns The integer index of the id column.
#' @keywords internal
.check_id_col <- function(id_col, x, call = caller_env()) {
  id_col_name <- colnames(x)[[id_col]]
  ids <- x[[id_col]]
  .check_id(ids, id_col_name, call)
  return(id_col)
}

### normalize parent column ----

#' Normalize and check the parent column
#'
#' @inheritParams .shared-params
#' @returns The integer index of the parent column.
#' @keywords internal
.normalize_parent_col <- function(
  parent_col,
  x,
  id_col,
  id_col_name,
  call = caller_env()
) {
  .eval_pull(x, parent_col, "parent_col", call = call) |>
    .check_parent_col(x, id_col, id_col_name, call = call)
}

#' Check that parent column is valid and distinct from id column
#'
#' @inheritParams .shared-params
#' @returns The integer index of the parent column.
#' @keywords internal
.check_parent_col <- function(
  parent_col,
  x,
  id_col,
  id_col_name,
  call = caller_env()
) {
  .check_arg_different(parent_col, id_col, call = call)
  .check_parent_ids(x, parent_col, id_col, id_col_name, call)
  parent_col
}

#' Validate parent ids: cast to id type, check for self-references and missing roots
#'
#' @inheritParams .shared-params
#' @returns The parent ids, cast to the same type as ids.
#' @keywords internal
.check_parent_ids <- function(
  x,
  parent_col,
  id_col,
  id_col_name,
  call = caller_env()
) {
  ids <- x[[id_col]]
  parent_ids <- vctrs::vec_cast(
    x[[parent_col]],
    ids,
    x_arg = .data_field_name(colnames(x)[[parent_col]]),
    to_arg = .data_field_name(id_col_name),
    call = call
  ) |>
    .check_self_reference(ids, call = call) |>
    .check_parent_id_missing(ids, call = call)
  return(parent_ids)
}

#' Format a data frame column reference for error messages
#'
#' @returns A string in the form "x$col".
#' @keywords internal
.data_field_name <- function(col_name) {
  paste0("x$", col_name)
}

#' Check that no element is its own parent
#'
#' @param parent_ids (`character` or `integer`) The parent ids to check.
#' @param ids (`character` or `integer`) The potential child ids to compare
#'   against.
#' @inheritParams .shared-params
#' @returns The input `parent_ids`.
#' @keywords internal
.check_self_reference <- function(parent_ids, ids, call = caller_env()) {
  self_reference <- vctrs::vec_equal(parent_ids, ids, na_equal = FALSE)
  if (any(self_reference, na.rm = TRUE)) {
    self_reference_loc <- which(self_reference)
    n <- length(self_reference_loc)
    msg <- c(
      "An element must not be its own parent",
      i = "{qty(n)}Element{?s} {self_reference_loc} {qty(n)}refer{?s/} to {?itself/themselves} as parent."
    )
    cli::cli_abort(msg, call = call)
  }
  return(parent_ids)
}

#' Check that parent ids aren't missing
#'
#' @inheritParams .check_self_reference
#' @inheritParams .shared-params
#' @returns The input `parent_ids`.
#' @keywords internal
.check_parent_id_missing <- function(parent_ids, ids, call = caller_env()) {
  parent_na <- vctrs::vec_detect_missing(parent_ids)
  if (!any(parent_na) && !vctrs::vec_is_empty(parent_ids)) {
    msg <- c(
      "There must be root elements.",
      i = "A root element is an elements whose parent id is missing."
    )
    cli::cli_abort(msg, call = call)
  }
  missing_parents <- !vctrs::vec_in(parent_ids, ids) & !parent_na
  if (any(missing_parents)) {
    missing_parent_ids <- vctrs::vec_slice(parent_ids, missing_parents)
    n <- sum(missing_parents)
    msg <- c(
      "The parent of each element must be found.",
      i = "The parent {qty(n)} id{?s} {.value {missing_parent_ids}} {qty(n)}{?is/are} not found."
    )
    cli::cli_abort(msg, call = call)
  }
  return(parent_ids)
}

### normalize utils ----

#' Evaluate and extract a single column selection
#'
#' @inheritParams .shared-params-tree
#' @inheritParams .shared-params
#' @returns An integer index of the selected column, named by the column name.
#' @keywords internal
.eval_pull <- function(x, col, col_arg, call = caller_env()) {
  col <- tidyselect::eval_select(
    col,
    x,
    allow_rename = FALSE,
    error_call = call
  )
  if (length(col) != 1L) {
    cli::cli_abort(
      "{.arg {col_arg}} must select 1 column, not {length(col)}.",
      class = c("tibblify-error-invalid_column_selection", "tibblify-error"),
      call = call
    )
  }
  nm <- colnames(x)[[col]]
  rlang::set_names(col, nm)
}

#' Check that id column has no missing or duplicate values
#'
#' @inheritParams .shared-params
#' @returns The input `x`.
#' @keywords internal
.check_id <- function(x, x_arg, call = caller_env()) {
  .check_col_values_missing(x, x_arg, call) |>
    .check_col_value_duplicates(x_arg, call)
}

#' Check that a column has no missing values
#'
#' @inheritParams .shared-params
#' @returns The input `x`.
#' @keywords internal
.check_col_values_missing <- function(x, x_arg, call = caller_env()) {
  if (vctrs::vec_any_missing(x)) {
    incomplete <- vctrs::vec_detect_missing(x)
    incomplete_loc <- which(incomplete)
    n <- length(incomplete_loc)
    cli::cli_abort(
      c(
        "Each value of column {.field {x_arg}} must be non-missing.",
        i = "{qty(n)}Element{?s} {incomplete_loc} {qty(n)}{?is/are} missing."
      ),
      call = call
    )
  }
  return(x)
}

#' Check that a column has no duplicate values
#'
#' @inheritParams .shared-params
#' @returns The input `x`.
#' @keywords internal
.check_col_value_duplicates <- function(x, x_arg, call = caller_env()) {
  if (vctrs::vec_duplicate_any(x)) {
    duplicated_flag <- vctrs::vec_duplicate_detect(x)
    duplicated_loc <- which(duplicated_flag)
    cli::cli_abort(
      c(
        "Each value of column {.field {x_arg}} must be unique.",
        i = "The elements at locations {duplicated_loc} are duplicated."
      ),
      call = call
    )
  }
  return(x)
}

## nest implementation ----

#' Main implementation of tree nesting
#'
#' @inheritParams .shared-params
#' @returns A nested data frame with children column and parent column removed.
#' @keywords internal
.nest_tree_impl <- function(
  x,
  id_col,
  parent_col,
  children_to,
  id_col_name,
  call = caller_env()
) {
  x[[children_to]] <- list(NULL)
  if (!vctrs::vec_is_empty(x)) {
    x <- .apply_nesting(x, id_col, parent_col, children_to, id_col_name, call)
  }
  x[[parent_col]] <- NULL
  x
}

#' Apply nesting across all tree levels
#'
#' @inheritParams .shared-params
#' @returns A nested data frame with root elements at the top level.
#' @keywords internal
.apply_nesting <- function(
  x,
  id_col,
  parent_col,
  children_to,
  id_col_name,
  call = caller_env()
) {
  lvl_info <- .nest_tree_lvl(x[[id_col]], x[[parent_col]], id_col_name, call)
  max_lvl <- lvl_info$max_lvl
  lvls <- lvl_info$lvls
  x_split <- vctrs::vec_split(x, lvls)
  children <- x_split$val[[max_lvl]]
  for (cur_lvl in seq(max_lvl - 1L, 1L)) {
    x <- .apply_nest_lvl(
      x_split,
      cur_lvl,
      children,
      parent_col,
      id_col_name,
      children_to
    )
    children <- x
  }
  return(x)
}

#' Apply nesting at a single tree level
#'
#' @param x_split (`data.frame`) A data frame that has been split using
#'   [vctrs::vec_split()].
#' @param cur_lvl (`integer(1)`) The key being split.
#' @param children (`data.frame`) The data frame that contains potential
#'   children.
#' @inheritParams .shared-params
#' @returns A data frame of parents with their children nested into a column.
#' @keywords internal
.apply_nest_lvl <- function(
  x_split,
  cur_lvl,
  children,
  parent_col,
  id_col,
  children_to
) {
  x <- x_split$val[[cur_lvl]]
  child_parent_ids <- children[[parent_col]]
  children[[parent_col]] <- NULL
  children_split <- vctrs::vec_split(children, child_parent_ids)
  child_parent_match <- vctrs::vec_match(x[[id_col]], children_split$key)
  x[[children_to]] <- children_split$val[child_parent_match]
  return(x)
}

#' Compute tree level for each element based on id and parent relationships
#'
#' @inheritParams .shared-params
#' @returns A list with `lvls` (integer vector of levels) and `max_lvl` (maximum
#'   level).
#' @keywords internal
.nest_tree_lvl <- function(ids, parent_ids, id_col_name, call = caller_env()) {
  lvls <- NA_integer_
  child_idx <- is.na(parent_ids)
  lvls[child_idx] <- 1L
  cur_parent_ids <- ids[child_idx]
  cur_lvl <- 1L
  while (TRUE) {
    # TODO add `call` argument once available
    child_idx <- vctrs::vec_in(parent_ids, cur_parent_ids)
    if (!any(child_idx)) {
      break
    }
    cur_lvl <- cur_lvl + 1L
    lvls[child_idx] <- cur_lvl
    cur_parent_ids <- ids[child_idx]
  }
  list(lvls = .check_lvls(lvls, call), max_lvl = cur_lvl)
}

#' Check that all elements have assigned tree levels
#'
#' @param lvls (`integer`) A vector of levels.
#' @inheritParams .shared-params
#' @returns The input `lvls`.
#' @keywords internal
.check_lvls <- function(lvls, call = caller_env()) {
  na_lvls <- is.na(lvls)
  if (any(na_lvls)) {
    not_found_loc <- which(na_lvls)
    n <- length(not_found_loc)
    cli::cli_abort(
      c(
        "Each element must be connected to a root element.",
        i = "The {qty(n)}element{?s} {not_found_loc} {qty(n)}{?is/are} not connected."
      ),
      call = call,
      class = c("tibblify-error-detached_tree_parts", "tibblify-error")
    )
  }
  lvls
}

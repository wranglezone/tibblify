#' Unnest a recursive data frame
#'
#' @param x (`data.frame`) The data frame to unnest.
#' @param child_col (`character(1)`, `integer(1)`, or `symbol`) The column that
#'   contains the children of an observation. This column must be a list where
#'   each element is either `NULL` or a data frame with the same columns as `x`.
#' @param level_to (`character(1)`) The column name (`"level"` by default) in
#'   which to store the level of an observation. Use `NULL` if you don't need
#'   this information.
#' @param parent_to (`character(1)`) The column name (`"parent"` by default) in
#'   which to store the parent id of an observation. Use `NULL` if you don't
#'   need this information.
#' @param ancestors_to (`character(1)`) The column name (`NULL` by default) in
#'   which to store the ids of the ancestors of a deeply nested child. Use
#'   `NULL` if you don't need this information.
#' @inheritParams .shared-params
#'
#' @returns A "flat" data frame.
#' @export
#'
#' @examples
#' df <- tibble(
#'   id = 1L,
#'   name = "a",
#'   children = list(
#'     tibble(
#'       id = 11:12,
#'       name = c("b", "c"),
#'       children = list(
#'         NULL,
#'         tibble(
#'           id = 121:122,
#'           name = c("d", "e")
#'         )
#'       )
#'     )
#'   )
#' )
#' df
#'
#' unnest_tree(
#'   df,
#'   id_col = "id",
#'   child_col = "children",
#'   level_to = "level",
#'   parent_to = "parent",
#'   ancestors_to = "ancestors"
#' )
unnest_tree <- function(
  x,
  id_col,
  child_col,
  level_to = "level",
  parent_to = "parent",
  ancestors_to = NULL
) {
  .check_is_df(x)
  id_col <- .normalize_id_col_name(rlang::enquo(id_col), x)
  child_col <- .normalize_child_col_name(rlang::enquo(child_col), x, id_col)
  level_to <- .check_unnest_col_name(level_to, x)
  parent_to <- .check_unnest_col_diff(parent_to, x, level_to)
  ancestors_to <- .check_unnest_col_diff(ancestors_to, x, level_to, parent_to)

  tree_levels <- .collect_tree_levels(
    x,
    id_col,
    child_col,
    parent_to,
    ancestors_to
  )
  .assemble_tree_output(tree_levels, id_col, level_to, parent_to, ancestors_to)
}

# helpers ----

## validate inputs ----

#' Resolve `id_col` to a column name string
#'
#' @inheritParams unnest_tree
#' @inheritParams .shared-params
#' @returns `id_col` resolved to a `character(1)` column name.
#' @keywords internal
.normalize_id_col_name <- function(id_col, x, call = caller_env()) {
  names(.eval_pull(x, id_col, "id_col", call = call))
}

#' Resolve `child_col` to a column name string
#'
#' @inheritParams unnest_tree
#' @inheritParams .shared-params
#' @returns `child_col` resolved to a `character(1)` column name.
#' @keywords internal
.normalize_child_col_name <- function(
  child_col,
  x,
  id_col,
  call = caller_env()
) {
  names(.eval_pull(x, child_col, "child_col", call)) |>
    .check_arg_different(id_col, arg_name = "child_col", call = call)
}

#' Validate and normalise an output column name
#'
#' @inheritParams unnest_tree
#' @inheritParams .shared-params-tree
#' @inheritParams .shared-params
#' @returns `col_name` (cast to `character`) or `NULL`.
#' @keywords internal
.check_unnest_col_name <- function(
  col_name,
  x,
  col_arg = caller_arg(col_name),
  call = caller_env()
) {
  if (!is.null(col_name)) {
    force(col_arg)
    col_name <- vctrs::vec_cast(
      col_name,
      character(),
      x_arg = col_arg,
      call = call
    )
    vctrs::obj_check_vector(col_name, arg = col_arg, call = call)
    vctrs::vec_check_size(col_name, size = 1L, arg = col_arg, call = call)
    .check_col_new(x, col_name, col_arg = col_arg, call = call)
  }
  col_name
}

#' Validate an output column name and check it differs from prior names
#'
#' @param ... Already-reserved column names that `col_name` must differ from.
#' @inheritParams unnest_tree
#' @inheritParams .shared-params-tree
#' @inheritParams .shared-params
#' @returns `col_name` or `NULL`.
#' @keywords internal
.check_unnest_col_diff <- function(
  col_name,
  x,
  ...,
  col_arg = caller_arg(col_name),
  call = caller_env()
) {
  .check_unnest_col_name(col_name, x, col_arg = col_arg, call = call) |>
    .check_arg_different(..., arg_name = col_arg, call = call)
}

#' Check that a column name does not already exist in a data frame
#'
#' @param x_arg (`character(1)`) Data frame argument name used in error
#'   messages.
#' @inheritParams unnest_tree
#' @inheritParams .shared-params-tree
#' @inheritParams .shared-params
#' @returns `x` (invisibly). Throws an error if `col_name` is already a column
#'   of `x`.
#' @keywords internal
.check_col_new <- function(
  x,
  col_name,
  col_arg = caller_arg(col_name),
  x_arg = "x",
  call = caller_env()
) {
  if (col_name %in% colnames(x)) {
    cli::cli_abort(
      "{.arg {col_arg}} must not be a column in {.arg {x_arg}}.",
      call = call
    )
  }
  return(x)
}

## collect tree levels ----

#' Traverse the tree and collect per-level data
#'
#' @param x (`data.frame`) The root-level data frame.
#' @inheritParams unnest_tree
#' @inheritParams .shared-params
#' @returns A named list with elements `level_data`, `out_ptype`, `level_sizes`,
#'   `level_parent_ids`, and `level_ancestors`.
#' @keywords internal
.collect_tree_levels <- function(
  x,
  id_col,
  child_col,
  parent_to,
  ancestors_to,
  call = caller_env()
) {
  snapshots <- .walk_tree_levels(x, id_col, child_col, call)
  list(
    level_data = purrr::map(snapshots, "data"),
    out_ptype = .reduce_ptype(snapshots, call),
    level_sizes = purrr::map(snapshots, "ns"),
    level_parent_ids = purrr::map(snapshots, "parent_ids"),
    level_ancestors = .build_level_ancestors(snapshots, id_col, call)
  )
}

#' Walk the tree level by level, collecting a snapshot at each depth
#'
#' @inheritParams .collect_tree_levels
#' @returns A list of per-level snapshots, each with elements `data`, `ns`,
#'   `parent_ids`, and `child_sizes`.
#' @keywords internal
.walk_tree_levels <- function(x, id_col, child_col, call) {
  snapshots <- list()
  parent_ids <- vctrs::vec_init(x[[id_col]])
  ns <- vctrs::vec_size(x)
  repeat {
    children <- .extract_children(x, child_col, call = call)
    child_sizes <- vctrs::list_sizes(children)
    snapshots <- c(
      snapshots,
      list(list(
        data = x[, setdiff(names(x), child_col)],
        ns = ns,
        parent_ids = parent_ids,
        child_sizes = child_sizes
      ))
    )
    if (all(child_sizes == 0)) {
      break
    }
    ns <- child_sizes
    parent_ids <- x[[id_col]]
    x <- .unchop_children(children, child_col, call = call)
  }
  snapshots
}

#' Reduce per-level data frames to their combined ptype
#'
#' @param snapshots (`list`) The object returned by `.walk_tree_levels()`.
#' @inheritParams .shared-params
#' @returns A 0-row data frame representing the combined type of all levels.
#' @keywords internal
.reduce_ptype <- function(snapshots, call) {
  purrr::reduce(
    purrr::map(snapshots, "data"),
    \(out_ptype, x) vctrs::vec_ptype2(out_ptype, x, call = call),
    .init = vctrs::vec_ptype(snapshots[[1]]$data)
  )
}

#' Build ancestor chains across levels using accumulate
#'
#' @param snapshots (`list`) The object returned by `.walk_tree_levels()`.
#' @inheritParams unnest_tree
#' @inheritParams .shared-params
#' @returns A list of length `length(snapshots)`, where element `k` is a list
#'   of ancestor vectors (one per row at level `k`).
#' @keywords internal
.build_level_ancestors <- function(snapshots, id_col, call) {
  init <- vctrs::vec_rep_each(list(NULL), vctrs::vec_size(snapshots[[1]]$data))
  purrr::accumulate(
    snapshots[-length(snapshots)],
    \(cur_ancestors, snapshot) {
      .accumulate_snapshot_level(cur_ancestors, snapshot, id_col, call)
    },
    .init = init
  )
}

#' Accumulate ancestor chains for a single snapshot level
#'
#' @param cur_ancestors (`list`) A list of ancestor vectors for the current
#'   level, one per row.
#' @param snapshot (`list`) A single snapshot object with elements `data`, `ns`,
#'   `parent_ids`,
#' @inheritParams .build_level_ancestors
#' @returns A list of ancestor vectors for the next level, where each vector is
#'   the ancestor vector of the parent row with the parent id appended.
#' @keywords internal
.accumulate_snapshot_level <- function(cur_ancestors, snapshot, id_col, call) {
  ancestors_with_parent <- purrr::map2(
    cur_ancestors,
    vctrs::vec_chop(snapshot$data[[id_col]]),
    \(ancestors, parent_id) c(ancestors, parent_id)
  )
  vctrs::vec_rep_each(
    ancestors_with_parent,
    snapshot$child_sizes,
    error_call = call
  )
}

#' Extract and validate the children list from a level data frame
#'
#' @param x (`data.frame`) Current level data frame.
#' @inheritParams unnest_tree
#' @inheritParams .shared-params
#' @returns (`list`) The children list extracted from `x[[child_col]]`.
#' @keywords internal
.extract_children <- function(x, child_col, call = caller_env()) {
  children <- x[[child_col]] %||% list()
  # TODO this could mention the path?
  # -> this would require tracking the current ancestors. Worth it?
  vctrs::vec_check_list(children, arg = child_col, call = call)
  children
}

#' Unclass and unchop a list of child data frames
#'
#' @param children (`list`) List of child data frames or `NULL` elements.
#' @inheritParams unnest_tree
#' @inheritParams .shared-params
#' @returns (`data.frame`) All non-`NULL` children combined into one data frame.
#' @keywords internal
.unchop_children <- function(children, child_col, call = caller_env()) {
  children <- .with_indexed_errors(
    purrr::map(children, \(child) {
      .unclass_list_of(child, child_col, call = NULL)
    }),
    message = "In child {cnd$location}.",
    error_call = call
  )
  vctrs::list_unchop(children, error_call = call)
}

#' Unclass a list_of child data frame
#'
#' @param x (`data.frame` or `NULL`) A single child data frame.
#' @param child_col (`character(1)`) Name of the column that may itself be a
#'   `vctrs_list_of`.
#' @inheritParams .shared-params
#' @returns (`data.frame` or `NULL`) `x` with `vctrs_list_of` classes removed,
#'   or `NULL` if `x` is `NULL`.
#' @keywords internal
.unclass_list_of <- function(x, child_col, call = caller_env()) {
  if (is.null(x)) {
    return(NULL)
  }
  if (!inherits(x, "data.frame")) {
    # TODO mention path
    stop_input_type(
      x,
      "a data frame",
      allow_null = TRUE,
      arg = "Each child",
      call = call
    )
  }
  x <- unclass(x)
  child_children <- x[[child_col]]
  if (inherits(child_children, "vctrs_list_of")) {
    x[[child_col]] <- unclass(child_children)
  }
  vctrs::new_data_frame(x)
}

## assemble tree output ----

#' Assemble the final output from per-level data
#'
#' @param tree_levels (`list`) The object returned by `.collect_tree_levels()`,
#'   containing `level_data`, `out_ptype`, `level_sizes`, `level_parent_ids`,
#'   and `level_ancestors`.
#' @inheritParams unnest_tree
#' @inheritParams .shared-params
#' @returns (`data.frame`) The assembled output with metadata columns appended.
#' @keywords internal
.assemble_tree_output <- function(
  tree_levels,
  id_col,
  level_to,
  parent_to,
  ancestors_to,
  call = caller_env()
) {
  level_data <- tree_levels$level_data
  out <- vctrs::vec_rbind(
    !!!level_data,
    .ptype = tree_levels$out_ptype,
    .error_call = call
  ) |>
    .assemble_level_col(level_to, level_data, call) |>
    .assemble_parent_col(parent_to, tree_levels, id_col, call) |>
    .assemble_ancestors_col(ancestors_to, tree_levels, call)
  .check_id(out[[id_col]], id_col, call)
  out
}

#' Assemble the level column for `unnest_tree()` output
#'
#' @param out (`data.frame`) The partially assembled output.
#' @param level_data (`list`) Data frames collected at each tree level, without
#'   the child column.
#' @inheritParams .shared-params
#' @returns An integer vector of levels with the same length as `nrow(out)`.
#' @keywords internal
.assemble_level_col <- function(out, level_to, level_data, call) {
  if (!is.null(level_to)) {
    out[[level_to]] <- vctrs::vec_rep_each(
      vctrs::vec_seq_along(level_data),
      vctrs::list_sizes(level_data),
      error_call = call
    )
  }
  out
}

#' Assemble the parent id column for `unnest_tree()` output
#'
#' @inheritParams .assemble_level_col
#' @inheritParams .assemble_tree_output
#' @returns A vector of parent ids with the same type as `out[[id_col]]` and
#'   the same length as `nrow(out)`.
#' @keywords internal
.assemble_parent_col <- function(out, parent_to, tree_levels, id_col, call) {
  if (!is.null(parent_to)) {
    parent_ids <- vctrs::list_unchop(
      tree_levels$level_parent_ids,
      ptype = out[[id_col]],
      error_call = call
    )
    times <- vctrs::list_unchop(
      tree_levels$level_sizes,
      ptype = integer(),
      error_call = call
    )
    out[[parent_to]] <- vctrs::vec_rep_each(
      parent_ids,
      times,
      error_call = call
    )
  }
  out
}

#' Assemble the ancestors column for `unnest_tree()` output
#'
#' @inheritParams .assemble_level_col
#' @inheritParams .assemble_tree_output
#' @returns A vector of ancestor ids with the same length as `nrow(out)`.
#' @keywords internal
.assemble_ancestors_col <- function(out, ancestors_to, tree_levels, call) {
  if (!is.null(ancestors_to)) {
    out[[ancestors_to]] <- vctrs::list_unchop(
      tree_levels$level_ancestors,
      error_call = call
    )
  }
  out
}

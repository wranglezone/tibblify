# nest_tree checks arguments (#163)

    Code
      (expect_error(nest_tree(1L), class = "tibblify-error-invalid_data_frame"))
    Output
      <error/tibblify-error-invalid_data_frame>
      Error in `nest_tree()`:
      ! `x` must be a data frame.
    Code
      (expect_error(nest_tree(df, "not-there"), class = "vctrs_error_subscript_oob"))
    Output
      <error/vctrs_error_subscript_oob>
      Error in `nest_tree()`:
      ! Can't select columns that don't exist.
      x Column `not-there` doesn't exist.
    Code
      (expect_error(nest_tree(df, 1:2), class = "tibblify-error-invalid_column_selection")
      )
    Output
      <error/tibblify-error-invalid_column_selection>
      Error in `nest_tree()`:
      ! `id_col` must select 1 column, not 2.
    Code
      (expect_error(nest_tree(df, id, parent_col = "not-there"), class = "vctrs_error_subscript_oob")
      )
    Output
      <error/vctrs_error_subscript_oob>
      Error in `nest_tree()`:
      ! Can't select columns that don't exist.
      x Column `not-there` doesn't exist.
    Code
      (expect_error(nest_tree(df, id, parent_col = 1:2), class = "tibblify-error-invalid_column_selection")
      )
    Output
      <error/tibblify-error-invalid_column_selection>
      Error in `nest_tree()`:
      ! `parent_col` must select 1 column, not 2.
    Code
      (expect_error(nest_tree(df, id, parent_col = id), class = "tibblify-error-args_same_value")
      )
    Output
      <error/tibblify-error-args_same_value>
      Error in `nest_tree()`:
      ! `parent_col` must be different from `id_col`.
    Code
      (expect_error(nest_tree(df, id, parent, children_to = 1L), class = "vctrs_error_cast")
      )
    Output
      <error/vctrs_error_cast>
      Error in `nest_tree()`:
      ! Can't convert `children_to` <integer> to <character>.
    Code
      (expect_error(nest_tree(df, id, parent, children_to = c("a", "b")), class = "vctrs_error_assert_size")
      )
    Output
      <error/vctrs_error_assert_size>
      Error in `nest_tree()`:
      ! `children_to` must have size 1, not size 2.
    Code
      (expect_error(nest_tree(df, id, parent, children_to = "id"), class = "tibblify-error-args_same_value")
      )
    Output
      <error/tibblify-error-args_same_value>
      Error in `nest_tree()`:
      ! `children_to` must be different from `id_col`.
    Code
      (expect_error(nest_tree(df, id, parent, children_to = "parent"), class = "tibblify-error-args_same_value")
      )
    Output
      <error/tibblify-error-args_same_value>
      Error in `nest_tree()`:
      ! `children_to` must be different from `parent_col`.

# nest_tree checks that ids are valid (#163)

    Code
      (expect_error(nest_tree(df, id, parent, children_to = "children")))
    Output
      <error/rlang_error>
      Error in `nest_tree()`:
      ! Each value of column id must be non-missing.
      i Element 2 is missing.

---

    Code
      (expect_error(nest_tree(df, id, parent, children_to = "children")))
    Output
      <error/rlang_error>
      Error in `nest_tree()`:
      ! Each value of column id must be unique.
      i The elements at locations 1 and 2 are duplicated.

# nest_tree checks column ids and parents have compatible types (#163)

    Code
      (expect_error(nest_tree(df, id, parent, children_to = "children")))
    Output
      <error/vctrs_error_cast>
      Error in `nest_tree()`:
      ! Can't convert `x$parent` <character> to match type of `x$id` <integer>.

# nest_tree errors if not all parent ids found (#163)

    Code
      (expect_error(nest_tree(df, id, parent, children_to = "children")))
    Output
      <error/rlang_error>
      Error in `nest_tree()`:
      ! The parent of each element must be found.
      i The parent ids 4 and 5 are not found.
    Code
      (expect_error(nest_tree(df[1:2, ], id, parent, children_to = "children")))
    Output
      <error/rlang_error>
      Error in `nest_tree()`:
      ! The parent of each element must be found.
      i The parent id 4 is not found.

# nest_tree errors if parent references to itself (#163)

    Code
      (expect_error(nest_tree(df, id, parent, children_to = "children")))
    Output
      <error/rlang_error>
      Error in `nest_tree()`:
      ! An element must not be its own parent
      i Element 2 refers to itself as parent.

# nest_tree errors if there are no root elements (#163)

    Code
      (expect_error(nest_tree(df, id, parent, children_to = "children")))
    Output
      <error/rlang_error>
      Error in `nest_tree()`:
      ! There must be root elements.
      i A root element is an elements whose parent id is missing.

# nest_tree errors if there are detached parts of the tree (#163)

    Code
      (expect_error(nest_tree(df, id, parent, children_to = "children"), class = "tibblify-error-detached_tree_parts")
      )
    Output
      <error/tibblify-error-detached_tree_parts>
      Error in `nest_tree()`:
      ! Each element must be connected to a root element.
      i The elements 2 and 3 are not connected.


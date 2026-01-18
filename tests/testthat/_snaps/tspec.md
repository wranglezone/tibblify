# tspec_df errors on invalid names

    Code
      (expect_error(tspec_df(x = tib_int("x"), x = tib_int("y"))))
    Output
      <error/vctrs_error_names_must_be_unique>
      Error in `tspec_df()`:
      ! Names must be unique.
      x These names are duplicated:
        * "x" at locations 1 and 2.

# tspec_df errors if element is not a tib collector

    Code
      (expect_error(tspec_df(1)))
    Output
      <error/rlang_error>
      Error in `tspec_df()`:
      ! ..1 must be a tib collector, not the number 1.
    Code
      (expect_error(tspec_df(x = tib_int("x"), y = "a")))
    Output
      <error/rlang_error>
      Error in `tspec_df()`:
      ! y must be a tib collector, not the string "a".

# tspec_df can infer name from key

    Code
      (expect_error(tspec_df(tib_int(c("a", "b")))))
    Output
      <error/rlang_error>
      Error in `tspec_df()`:
      ! In field 1.
      Caused by error:
      ! `key` must be a single string to infer name.
      x `key` has length 2.
    Code
      (expect_error(tspec_df(y = tib_int("x"), tib_int("y"))))
    Output
      <error/vctrs_error_names_must_be_unique>
      Error in `tspec_df()`:
      ! Names must be unique.
      x These names are duplicated:
        * "y" at locations 1 and 2.

# tspec_df errors on invalid `.names_to`

    Code
      (expect_error(tspec_df(.names_to = NA_character_)))
    Output
      <error/rlang_error>
      Error in `tspec_df()`:
      ! `.names_to` must be a single string or `NULL`, not a character `NA`.
    Code
      (expect_error(tspec_df(.names_to = 1)))
    Output
      <error/rlang_error>
      Error in `tspec_df()`:
      ! `.names_to` must be a single string or `NULL`, not the number 1.

# tspec_df errors if `.names_to` column name is not unique

    Code
      (expect_error(tspec_df(x = tib_int("x"), .names_to = "x")))
    Output
      <error/rlang_error>
      Error in `tspec_df()`:
      ! The column name of `.names_to` is already specified in `...`.

# tspec_df errors if `.names_to` is used with colmajor

    Code
      (expect_error(tspec_df(.names_to = "x", .input_form = "colmajor")))
    Output
      <error/rlang_error>
      Error in `tspec_df()`:
      ! Can't use `.names_to` with `.input_form = "colmajor"`.

# tspec_df errors if `vector_allows_empty_list` is invalid

    Code
      (expect_error(tspec_df(.vector_allows_empty_list = NA)))
    Output
      <error/rlang_error>
      Error in `tspec_df()`:
      ! `.vector_allows_empty_list` must be `TRUE` or `FALSE`, not `NA`.
    Code
      (expect_error(tspec_df(.vector_allows_empty_list = "a")))
    Output
      <error/rlang_error>
      Error in `tspec_df()`:
      ! `.vector_allows_empty_list` must be `TRUE` or `FALSE`, not the string "a".

# tspec_* can nest specifications

    Code
      (expect_error(tspec_df(spec1, spec1)))
    Output
      <error/vctrs_error_names_must_be_unique>
      Error in `tspec_df()`:
      ! Names must be unique.
      x These names are duplicated:
        * "a" at locations 1 and 3.
        * "b" at locations 2 and 4.

# tspec_recursive errors for bad .children and .children_to

    Code
      (expect_error(tspec_recursive(.children = 1L)))
    Output
      <error/rlang_error>
      Error in `tspec_recursive()`:
      ! `.children` must be a single string, not the number 1.
    Code
      (expect_error(tspec_recursive(.children = "a", .children_to = 1L)))
    Output
      <error/rlang_error>
      Error in `tspec_recursive()`:
      ! `.children_to` must be a single string, not the number 1.


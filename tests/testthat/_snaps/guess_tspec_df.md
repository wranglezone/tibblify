# gives nice errors

    Code
      (expect_error(guess_tspec_df(list(a = 1))))
    Output
      <error/tibblify-error-not_object_list>
      Error in `guess_tspec_df()`:
      ! `list(a = 1)` must be a list of objects.
    Code
      (expect_error(guess_tspec_df(1:3)))
    Output
      <error/rlang_error>
      Error in `guess_tspec_df()`:
      ! `1:3` must be a list, not an integer vector.

# inform about unspecified elements

    Code
      guess_tspec_df(tibble(lgl = NA), inform_unspecified = TRUE)
    Message
      The spec contains 1 unspecified field:
      * lgl
    Output
      tspec_df(
        tib_unspecified("lgl"),
      )


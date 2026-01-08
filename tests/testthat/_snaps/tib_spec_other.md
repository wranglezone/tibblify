# tib_df() checks arguments

    Code
      (expect_error(tib_df("x", .names_to = 1)))
    Output
      <error/rlang_error>
      Error in `tib_df()`:
      ! `.names_to` must be a single string, not the number 1.


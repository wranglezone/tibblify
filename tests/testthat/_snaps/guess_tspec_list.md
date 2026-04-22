# guess_tspec_list errors informatively for empty input

    Code
      (expect_error(guess_tspec_list(list())))
    Output
      <error/rlang_error>
      Error in `guess_tspec_list()`:
      ! `list()` must not be empty.

# guess_tspec_list errors informatively for bad objects

    Code
      (expect_error(guess_tspec_list(list(a = 1, 1))))
    Output
      <error/tibblify-error-untibblifiable_object>
      Error in `guess_tspec_list()`:
      ! `list(a = 1, 1)` is neither an object nor a list of objects.
      An object
      v is a list,
      x is fully named,
      v and has unique names.
      A list of objects is
      x a data frame or
      v a list and
      x each element is `NULL` or an object.
    Code
      (expect_error(guess_tspec_list(list(a = 1, a = 1))))
    Output
      <error/tibblify-error-untibblifiable_object>
      Error in `guess_tspec_list()`:
      ! `list(a = 1, a = 1)` is neither an object nor a list of objects.
      An object
      v is a list,
      v is fully named,
      x and has unique names.
      A list of objects is
      x a data frame or
      v a list and
      x each element is `NULL` or an object.


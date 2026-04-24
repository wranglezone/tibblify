# .apply_spec_renaming() errors on nested key

    Code
      (expect_error(untibblify(tibble(x = 1), spec)))
    Output
      <error/purrr_error_indexed>
      Error in `purrr::map()`:
      i In index: 1.
      Caused by error in `untibblify()`:
      ! `untibblify()` does not support specs with nested keys

# .apply_spec_renaming() errors on non-character key

    Code
      (expect_error(untibblify(tibble(x = 1), spec)))
    Output
      <error/purrr_error_indexed>
      Error in `purrr::map()`:
      i In index: 1.
      Caused by error in `untibblify()`:
      ! `untibblify()` does not support specs with non-character keys

# untibblify checks input (#49)

    Code
      (expect_error(untibblify(1:3)))
    Output
      <error/tibblify_error>
      Error in `untibblify()`:
      ! `x` must be a list. Instead, it is an integer vector.
    Code
      (expect_error(untibblify(new_rational(1, 1:3))))
    Output
      <error/tibblify_error>
      Error in `untibblify()`:
      ! `x` must be a list. Instead, it is a <vctrs_rational> object.

# .check_key_length_1() errors on zero-length key

    Code
      (expect_error(.check_key_length_1(key = character(0))))
    Output
      <error/tibblify_error>
      Error:
      ! `untibblify()` does not support specs with empty keys


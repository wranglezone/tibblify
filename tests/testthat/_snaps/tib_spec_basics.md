# errors on invalid `.key`

    Code
      (expect_error(tib_scalar(character(), logical())))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! `.key` must not be empty.
    Code
      (expect_error(tib_scalar(NA_character_, logical())))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! `.key` must not be "NA".
    Code
      (expect_error(tib_scalar("", logical())))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! `.key` must not be an empty string.
    Code
      (expect_error(tib_scalar(1L, logical())))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! `.key` must be a character vector, not the number 1.
    Code
      (expect_error(tib_scalar(c("x", NA), logical())))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! `.key[2] must not be NA.
    Code
      (expect_error(tib_scalar(c("x", ""), logical())))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! `.key[2] must not be an empty string.

# errors on invalid `.required`

    Code
      (expect_error(tib_scalar("x", logical(), .required = logical())))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! `.required` must be `TRUE` or `FALSE`, not an empty logical vector.
    Code
      (expect_error(tib_scalar("x", logical(), .required = NA)))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! `.required` must be `TRUE` or `FALSE`, not `NA`.
    Code
      (expect_error(tib_scalar("x", logical(), .required = 1L)))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! `.required` must be `TRUE` or `FALSE`, not the number 1.
    Code
      (expect_error(tib_scalar("x", logical(), .required = c(TRUE, FALSE))))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! `.required` must be `TRUE` or `FALSE`, not a logical vector.

# errors if dots are not empty

    Code
      (expect_error(tib_scalar("x", logical(), TRUE)))
    Output
      <error/rlib_error_dots_nonempty>
      Error in `tib_scalar()`:
      ! `...` must be empty.
      x Problematic argument:
      * ..1 = TRUE
      i Did you forget to name an argument?

# tib_scalar checks arguments

    Code
      (expect_error(tib_scalar("x", model)))
    Output
      <error/vctrs_error_scalar_type>
      Error in `tib_scalar()`:
      ! `.ptype` must be a vector, not a <lm> object.
      x Detected incompatible scalar S3 list. To be treated as a vector, the object must explicitly inherit from <list> or should implement a `vec_proxy()` method. Class: <lm>.
      i If this object comes from a package, please report this error to the package author.
      i Read our FAQ about creating vector types (`?vctrs::howto_faq_fix_scalar_type_error`) to learn more.

---

    Code
      (expect_error(tib_scalar("x", character(), .ptype_inner = model)))
    Output
      <error/vctrs_error_scalar_type>
      Error in `tib_scalar()`:
      ! `.ptype_inner` must be a vector, not a <lm> object.
      x Detected incompatible scalar S3 list. To be treated as a vector, the object must explicitly inherit from <list> or should implement a `vec_proxy()` method. Class: <lm>.
      i If this object comes from a package, please report this error to the package author.
      i Read our FAQ about creating vector types (`?vctrs::howto_faq_fix_scalar_type_error`) to learn more.

---

    Code
      (expect_error(tib_scalar("x", integer(), .fill = integer())))
    Output
      <error/vctrs_error_assert_size>
      Error in `tib_scalar()`:
      ! `.fill` must have size 1, not size 0.
    Code
      (expect_error(tib_scalar("x", integer(), .fill = 1:2)))
    Output
      <error/vctrs_error_assert_size>
      Error in `tib_scalar()`:
      ! `.fill` must have size 1, not size 2.
    Code
      (expect_error(tib_scalar("x", integer(), .fill = "a")))
    Output
      <error/vctrs_error_cast>
      Error in `tib_scalar()`:
      ! Can't convert `.fill` <character> to match type of `.ptype_inner` <integer>.

---

    Code
      (expect_error(tib_scalar("x", character(), .fill = 0L, .ptype_inner = character()))
      )
    Output
      <error/vctrs_error_cast>
      Error in `tib_scalar()`:
      ! Can't convert `.fill` <integer> to match type of `.ptype_inner` <character>.

---

    Code
      (expect_error(tib_scalar("x", integer(), .transform = integer())))
    Output
      <error/rlang_error>
      Error in `tib_scalar()`:
      ! Can't convert `.transform`, an integer vector, to a function.

# tib_vector checks arguments

    Code
      (expect_error(tib_vector("x", integer(), .input_form = "v")))
    Output
      <error/rlang_error>
      Error in `tib_vector()`:
      ! `.input_form` must be one of "vector", "scalar_list", or "object", not "v".
      i Did you mean "vector"?

---

    Code
      (expect_error(tib_vector("x", .ptype = model)))
    Output
      <error/vctrs_error_scalar_type>
      Error in `tib_vector()`:
      ! `.ptype` must be a vector, not a <lm> object.
      x Detected incompatible scalar S3 list. To be treated as a vector, the object must explicitly inherit from <list> or should implement a `vec_proxy()` method. Class: <lm>.
      i If this object comes from a package, please report this error to the package author.
      i Read our FAQ about creating vector types (`?vctrs::howto_faq_fix_scalar_type_error`) to learn more.

---

    Code
      (expect_error(tib_vector("x", character(), .ptype_inner = model)))
    Output
      <error/vctrs_error_scalar_type>
      Error in `tib_vector()`:
      ! `.ptype_inner` must be a vector, not a <lm> object.
      x Detected incompatible scalar S3 list. To be treated as a vector, the object must explicitly inherit from <list> or should implement a `vec_proxy()` method. Class: <lm>.
      i If this object comes from a package, please report this error to the package author.
      i Read our FAQ about creating vector types (`?vctrs::howto_faq_fix_scalar_type_error`) to learn more.

---

    Code
      (expect_error(tib_vector("x", integer(), .values_to = NA)))
    Output
      <error/rlang_error>
      Error in `tib_vector()`:
      ! `.values_to` must be a single string, not `NA`.
    Code
      (expect_error(tib_vector("x", integer(), .values_to = 1)))
    Output
      <error/rlang_error>
      Error in `tib_vector()`:
      ! `.values_to` must be a single string, not the number 1.
    Code
      (expect_error(tib_vector("x", integer(), .values_to = c("a", "b"))))
    Output
      <error/rlang_error>
      Error in `tib_vector()`:
      ! `.values_to` must be a single string, not a character vector.

---

    Code
      (expect_error(tib_vector("x", integer(), .input_form = "scalar_list",
      .values_to = "val", .names_to = "name")))
    Output
      <error/rlang_error>
      Error in `tib_vector()`:
      ! `.names_to` can't be used for `.input_form = "scalar_list"`.
    Code
      (expect_error(tib_vector("x", integer(), .input_form = "object", .names_to = "name"))
      )
    Output
      <error/rlang_error>
      Error in `tib_vector()`:
      ! `.names_to` can only be used if `.values_to` is not `NULL`.
    Code
      (expect_error(tib_vector("x", integer(), .input_form = "object", .values_to = "val",
      .names_to = "val")))
    Output
      <error/rlang_error>
      Error in `tib_vector()`:
      ! `.names_to` must be different from `.values_to`.
    Code
      (expect_error(tib_vector("x", integer(), .input_form = "object", .values_to = "val",
      .names_to = 1)))
    Output
      <error/rlang_error>
      Error in `tib_vector()`:
      ! `.names_to` must be a single string, not the number 1.
    Code
      (expect_error(tib_vector("x", integer(), .input_form = "object", .values_to = "val",
      .names_to = c("a", "b"))))
    Output
      <error/rlang_error>
      Error in `tib_vector()`:
      ! `.names_to` must be a single string, not a character vector.


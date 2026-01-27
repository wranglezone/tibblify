# tibblify spec argument is checked

    Code
      (expect_error(tibblify(list(), "x")))
    Output
      <error/rlang_error>
      Error in `tibblify()`:
      ! `spec` must be a tibblify spec, not the string "x".
    Code
      (expect_error(tibblify(list(), tib_int("x"))))
    Output
      <error/rlang_error>
      Error in `tibblify()`:
      ! `spec` must be a tibblify spec, not a <tib_scalar_integer> object.

# tibblify checks object names

    Code
      (expect_error(tibblify(list(1, 2), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! An object must be named.
      x `x` is not named.
    Code
      (expect_error(tibblify(list(x = 1, 2), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! The names of an object can't be empty.
      x `x` has an empty name at location 2.
    Code
      (expect_error(tibblify(list(1, x = 2), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! The names of an object can't be empty.
      x `x` has an empty name at location 1.
    Code
      (expect_error(tibblify(list(z = 1, y = 2, 3, a = 4), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! The names of an object can't be empty.
      x `x` has an empty name at location 3.
    Code
      (expect_error(tibblify(set_names(list(1, 2), c("x", NA)), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! The names of an object can't be empty.
      x `x` has an empty name at location 2.
    Code
      (expect_error(tibblify(list(x = 1, x = 2), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! The names of an object must be unique.
      x `x` has the duplicated name "x".

---

    Code
      (expect_error(tibblify(list(row = list(1, 2)), spec2)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! An object must be named.
      x `x$row` is not named.
    Code
      (expect_error(tibblify(list(row = list(x = 1, 2)), spec2)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! The names of an object can't be empty.
      x `x$row` has an empty name at location 2.
    Code
      (expect_error(tibblify(list(row = list(1, x = 2)), spec2)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! The names of an object can't be empty.
      x `x$row` has an empty name at location 1.
    Code
      (expect_error(tibblify(list(row = list(z = 1, y = 2, 3, a = 4)), spec2)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! The names of an object can't be empty.
      x `x$row` has an empty name at location 3.
    Code
      (expect_error(tibblify(list(row = set_names(list(1, 2), c("x", NA))), spec2)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! The names of an object can't be empty.
      x `x$row` has an empty name at location 2.
    Code
      (expect_error(tibblify(list(row = list(x = 1, x = 2)), spec2)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! The names of an object must be unique.
      x `x$row` has the duplicated name "x".

# tibblify errors if required fields are absent

    Code
      (expect_error(tib(list(a = 1), tib_lgl("x"))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Field x is required but does not exist in `x[[1]]`.
      i Use `required = FALSE` if the field is optional.
    Code
      (expect_error(tib(list(a = 1), tib_scalar("x", dtt))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Field x is required but does not exist in `x[[1]]`.
      i Use `required = FALSE` if the field is optional.

---

    Code
      (expect_error(tib(list(a = 1), tib_lgl_vec("x"))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Field x is required but does not exist in `x[[1]]`.
      i Use `required = FALSE` if the field is optional.
    Code
      (expect_error(tib(list(a = 1), tib_vector("x", dtt))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Field x is required but does not exist in `x[[1]]`.
      i Use `required = FALSE` if the field is optional.

# tibblify errors if type is bad

    Code
      (expect_error(tib(list(x = "a"), tib_lgl_vec("x"))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Problem while tibblifying `x[[1]]$x`
      Caused by error:
      ! Can't convert `"a"` <character> to <logical>.

---

    Code
      (expect_error(tib(list(x = "a"), tib_lgl("x"))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Problem while tibblifying `x[[1]]$x`
      Caused by error:
      ! Can't convert `"a"` <character> to <logical>.
    Code
      (expect_error(tib(list(x = 1), tib_scalar("x", dtt))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Problem while tibblifying `x[[1]]$x`
      Caused by error:
      ! Can't convert `1` <double> to <datetime<local>>.

# tibblify errors if size is bad

    Code
      (expect_error(tib(list(x = c(TRUE, TRUE)), tib_lgl("x"))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! `x[[1]]$x` must have size 1, not size 2.
      i You specified that the field is a scalar.
      i Use `tib_vector()` if the field is a vector instead.
    Code
      (expect_error(tib(list(x = logical()), tib_lgl("x"))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! `x[[1]]$x` must have size 1, not size 0.
      i You specified that the field is a scalar.
      i Use `tib_vector()` if the field is a vector instead.
    Code
      (expect_error(tib(list(x = c(dtt, dtt)), tib_scalar("x", dtt))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! `x[[1]]$x` must have size 1, not size 2.
      i You specified that the field is a scalar.
      i Use `tib_vector()` if the field is a vector instead.

# tibblify: tib_vector respects .vector_allows_empty_list

    Code
      (expect_error(tibblify(x, tspec_df(tib_int_vec("x")))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Problem while tibblifying `x[[2]]$x`
      Caused by error:
      ! Can't convert `<list>` <list> to <integer>.

# tibblify: tib_vector can parse scalar list

    Code
      (expect_error(tib(list(x = 1), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! `x[[1]]$x` must be a list, not the number 1.
      x `input_form = "scalar_list"` can only parse lists.
      i Use `input_form = "vector"` (the default) if the field is already a vector.

---

    Code
      (expect_error(tib(list(x = list(1, 1:2)), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! `x[[1]]$x` is not a list of scalars.
      x Element 2 must have size 1, not size 2.
    Code
      (expect_error(tib(list(x = list(integer())), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! `x[[1]]$x` is not a list of scalars.
      x Element 1 must have size 1, not size 0.

---

    Code
      (expect_error(tib(list(x = list(NULL, 1, 1:2)), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! `x[[1]]$x` is not a list of scalars.
      x Element 3 must have size 1, not size 2.

---

    Code
      (expect_error(tib(list(x = list(1, "a")), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Problem while tibblifying `x[[1]]$x`
      Caused by error in `list_unchop()`:
      ! Can't convert `x[[2]]` <character> to <integer>.

# tibblify: tib_vector can parse object

    Code
      (expect_error(tib(list(x = list(1, 2)), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! A vector must be a named list for `input_form = "object."`
      x `x[[1]]$x` is not named.

---

    Code
      (expect_error(tib(list(x = 1), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! `x[[1]]$x` must be a list, not the number 1.
      x `input_form = "object"` can only parse lists.
      i Use `input_form = "vector"` (the default) if the field is already a vector.

---

    Code
      (expect_error(tib(list(x = list(a = 1, b = 1:2)), spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! `x[[1]]$x` is not an object.
      x Element 2 must have size 1, not size 2.

# tib_variant tibblifies

    Code
      (expect_error(tibblify(list(list(x = TRUE), list(zzz = 1)), tspec_df(x = tib_variant(
        "x")))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Field x is required but does not exist in `x[[2]]`.
      i Use `required = FALSE` if the field is optional.

# tib_row tibblifies

    Code
      (expect_error(tibblify(list(list(x = list(a = TRUE)), list()), tspec_df(x = tib_row(
        "x", a = tib_lgl("a"))))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Field x is required but does not exist in `x[[2]]`.
      i Use `required = FALSE` if the field is optional.

# tib_df tibblifies

    Code
      (expect_error(tibblify(list(list(x = list(list(a = TRUE), list(a = FALSE))),
      list(a = 1)), tspec_df(x = tib_df("x", a = tib_lgl("a"))))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Field x is required but does not exist in `x[[2]]`.
      i Use `required = FALSE` if the field is optional.
    Code
      (expect_error(tibblify(list(list(x = list(list(a = TRUE), list()))), tspec_df(
        x = tib_df("x", a = tib_lgl("a"))))))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Field a is required but does not exist in `x[[1]]$x[[2]]`.
      i Use `required = FALSE` if the field is optional.


# .cast_posixlt_ptype ----------------------------------------------------------

test_that(".cast_posixlt_ptype casts POSIXlt to POSIXct", {
  expect_equal(
    .cast_posixlt_ptype(as.POSIXlt(vctrs::new_date())),
    vctrs::new_datetime()
  )
  expect_equal(
    .cast_posixlt_ptype(as.POSIXlt(vctrs::new_datetime())),
    vctrs::new_datetime()
  )
  expect_equal(
    .cast_posixlt_ptype(vctrs::new_datetime()),
    vctrs::new_datetime()
  )
  expect_equal(
    .cast_posixlt_ptype("x"),
    "x"
  )
})

# .is_unspecified --------------------------------------------------------------

test_that(".is_unspecified identifies objects tagged as unspecified", {
  expect_true(.is_unspecified(vctrs::unspecified(1)))
  expect_false(.is_unspecified(1))
})

# .is_vec ----------------------------------------------------------------------

test_that(".is_vec differentiates between lists and other vectors", {
  expect_true(.is_vec(letters))
  expect_true(.is_vec(1:10))
  expect_false(.is_vec(list(1:10)))
  expect_false(.is_vec(data.frame(a = 1:10)))
})

# .get_ptype_common ------------------------------------------------------------
test_that(".get_ptype_common returns common ptype when valid", {
  expect_mapequal(
    .get_ptype_common(list(list(), letters), TRUE),
    list(
      has_common_ptype = TRUE,
      ptype = character(),
      had_empty_lists = TRUE
    )
  )
  expect_mapequal(
    .get_ptype_common(list(list(), letters), FALSE),
    list(has_common_ptype = FALSE)
  )
  expect_mapequal(
    .get_ptype_common(list(LETTERS, letters), FALSE),
    list(
      has_common_ptype = TRUE,
      ptype = character(),
      had_empty_lists = NULL
    )
  )
})

test_that(".get_ptype_common indicates no common ptype for un-ignorable list", {
  expect_mapequal(
    .get_ptype_common(list(list(), letters), empty_list_unspecified = FALSE),
    list(has_common_ptype = FALSE)
  )
})

test_that(".get_ptype_common indicates no common ptype for incompatible type", {
  expect_mapequal(
    .get_ptype_common(list(1L, "a"), empty_list_unspecified = FALSE),
    list(has_common_ptype = FALSE)
  )
})

test_that(".get_ptype_common handles scalar type error (non-vector elements)", {
  expect_mapequal(
    .get_ptype_common(list(mean, sum), empty_list_unspecified = FALSE),
    list(has_common_ptype = FALSE)
  )
})

# .guess_object_list_field_spec ------------------------------------------------

test_that(".guess_object_list_field_spec returns tib_variant for no common ptype", {
  # Incompatible types
  expect_equal(
    .guess_object_list_field_spec(list(TRUE, "a"), "x", FALSE, FALSE),
    tib_variant("x")
  )
  # Non-vector elements (functions trigger scalar type error)
  expect_equal(
    .guess_object_list_field_spec(list(mean, sum), "x", FALSE, FALSE),
    tib_variant("x")
  )
})

test_that(".guess_object_list_field_spec returns tib_unspecified when ptype is NULL", {
  expect_equal(
    .guess_object_list_field_spec(list(NULL, NULL), "x", FALSE, FALSE),
    tib_unspecified("x")
  )
})

test_that(".guess_object_list_field_spec returns tib_scalar/tib_vector for vector ptype", {
  # Scalar (one element per row)
  expect_equal(
    .guess_object_list_field_spec(list(1L, 2L), "x", FALSE, FALSE),
    tib_int("x")
  )
  # Vector (multiple elements per row)
  expect_equal(
    .guess_object_list_field_spec(list(1:2, 3:4), "x", FALSE, FALSE),
    tib_int_vec("x")
  )
})

test_that(".guess_object_list_field_spec errors for a list of dataframes", {
  expect_error(
    .guess_object_list_field_spec(
      list(data.frame(a = 1L), data.frame(a = 2L)),
      "x",
      FALSE,
      FALSE
    ),
    "A list of dataframes is not yet supported"
  )
})

test_that(".guess_object_list_field_spec returns tib_unspecified for all-empty or all-null lists", {
  # All empty lists
  expect_equal(
    .guess_object_list_field_spec(list(list(), list()), "x", FALSE, FALSE),
    tib_unspecified("x")
  )
  # Each element is a list containing only NULLs
  expect_equal(
    .guess_object_list_field_spec(
      list(list(NULL), list(NULL)),
      "x",
      FALSE,
      FALSE
    ),
    tib_unspecified("x")
  )
})

test_that(".guess_object_list_field_spec returns tib_df for a list of object lists", {
  # Unnamed value_flat -> no .names_to
  expect_equal(
    .guess_object_list_field_spec(
      list(list(list(a = 1L), list(a = 2L))),
      "x",
      FALSE,
      FALSE
    ),
    tib_df("x", tib_int("a"))
  )
  # Named value_flat -> .names_to = ".names"
  expect_equal(
    .guess_object_list_field_spec(
      list(list(p = list(a = 1L), q = list(a = 2L))),
      "x",
      FALSE,
      FALSE
    ),
    tib_df("x", tib_int("a"), .names_to = ".names")
  )
})

test_that(".guess_object_list_field_spec returns tib_row when !simplify_list and object", {
  expect_equal(
    .guess_object_list_field_spec(
      list(list(a = 1L, b = "x"), list(a = 2L, b = "y")),
      "x",
      FALSE,
      FALSE
    ),
    tib_row("x", tib_int("a"), tib_chr("b"))
  )
})

test_that(".guess_object_list_field_spec returns tib_variant when !simplify_list and !object", {
  # Unnamed (non-object) lists
  expect_equal(
    .guess_object_list_field_spec(
      list(list(1L, 2L), list(3L, 4L)),
      "x",
      FALSE,
      FALSE
    ),
    tib_variant("x")
  )
})

test_that(".guess_object_list_field_spec simplifies to tib_vector with input_form = 'object'", {
  # Named elements in value_flat -> input_form = "object"
  expect_equal(
    .guess_object_list_field_spec(
      list(list(p = 1L, q = 2L), list(p = 3L, q = 4L)),
      "x",
      FALSE,
      TRUE
    ),
    tib_int_vec("x", .input_form = "object")
  )
})

test_that(".guess_object_list_field_spec simplifies to tib_vector with input_form = 'scalar_list'", {
  # Unnamed single-element lists -> input_form = "scalar_list"
  expect_equal(
    .guess_object_list_field_spec(list(list(1L), list(2L)), "x", FALSE, TRUE),
    tib_int_vec("x", .input_form = "scalar_list")
  )
})

test_that(".guess_object_list_field_spec returns tib_row when simplify_list but not vectorisable", {
  # Mixed-type named elements can't be combined -> falls back to tib_row
  expect_equal(
    .guess_object_list_field_spec(
      list(list(a = 1L, b = "x"), list(a = 2L, b = "y")),
      "x",
      FALSE,
      TRUE
    ),
    tib_row("x", tib_int("a"), tib_chr("b"))
  )
})

test_that(".guess_object_list_field_spec returns tib_variant when simplify_list and !object and not vectorisable", {
  # Unnamed lists with non-scalar sizes
  expect_equal(
    .guess_object_list_field_spec(
      list(list(1L, 1:2), list(3L)),
      "x",
      FALSE,
      TRUE
    ),
    tib_variant("x")
  )
})

test_that(".guess_object_list_field_spec respects empty_list_unspecified for vector ptype", {
  # empty_list_unspecified = TRUE: empty lists are dropped, had_empty_lists is set
  withr::local_options(tibblify.used_empty_list_arg = NULL)
  result <- .guess_object_list_field_spec(
    list(list(), 1L, 2L),
    "x",
    TRUE,
    FALSE
  )
  expect_equal(result, tib_int_vec("x"))
  expect_true(getOption("tibblify.used_empty_list_arg"))
})

# .mark_empty_list_argument ----------------------------------------------------

test_that(".mark_empty_list_argument sets the option when called with TRUE", {
  withr::local_options(tibblify.used_empty_list_arg = NULL)
  .mark_empty_list_argument(TRUE)
  expect_true(getOption("tibblify.used_empty_list_arg"))
})

test_that(".mark_empty_list_argument does nothing when called with non-TRUE", {
  withr::local_options(tibblify.used_empty_list_arg = NULL)
  .mark_empty_list_argument(FALSE)
  expect_null(getOption("tibblify.used_empty_list_arg"))

  .mark_empty_list_argument(NULL)
  expect_null(getOption("tibblify.used_empty_list_arg"))
})

# .tib_type_of -----------------------------------------------------------------

test_that(".tib_type_of returns the correct type string", {
  expect_equal(.tib_type_of(data.frame(a = 1), "x", FALSE), "df")
  expect_equal(.tib_type_of(list(1, 2), "x", FALSE), "list")
  expect_equal(.tib_type_of(1:3, "x", FALSE), "vector")
  expect_equal(.tib_type_of(mean, "x", TRUE), "other")
})

test_that(".tib_type_of errors for non-vector/list/df when other = FALSE", {
  expect_error(
    .tib_type_of(mean, "myfield", FALSE),
    "Column myfield must be a dataframe, a list, or a vector"
  )
})

# .tib_ptype -------------------------------------------------------------------

test_that(".tib_ptype returns the ptype of a vector", {
  expect_equal(.tib_ptype(1:5), integer())
  expect_equal(.tib_ptype(letters), character())
})

test_that(".tib_ptype converts POSIXlt to POSIXct", {
  posixlt_val <- as.POSIXlt(vctrs::new_date(0))
  expect_equal(.tib_ptype(posixlt_val), vctrs::new_datetime(tzone = ""))
})

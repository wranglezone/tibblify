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

# .mark_empty_list_argument ----------------------------------------------------

test_that(".mark_empty_list_argument sets the value in the env when called with TRUE", {
  local_env <- rlang::new_environment(list(empty_list_used = FALSE))
  .mark_empty_list_argument(TRUE, local_env)
  expect_true(.read_empty_list_argument(local_env))
})

test_that(".mark_empty_list_argument does nothing when called with non-TRUE", {
  local_env <- rlang::new_environment(list(empty_list_used = FALSE))
  .mark_empty_list_argument(FALSE, local_env)
  expect_false(.read_empty_list_argument(local_env))
  .mark_empty_list_argument(NULL, local_env)
  expect_false(.read_empty_list_argument(local_env))
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

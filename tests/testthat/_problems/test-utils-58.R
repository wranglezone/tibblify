# Extracted from test-utils.R:58

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "tibblify", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
expect_error(stop_required(list(1L, list("a", "b"))), "required")
expect_error(stop_scalar(list(0L, list("a")), 2), "must have size")
expect_error(stop_duplicate_name(list(0L, list("a")), "nm"), "duplicated")
expect_error(stop_empty_name(list(0L, list("a")), 0L), "empty name")
expect_error(stop_names_is_null(list(0L, list("a"))), "is not named")
expect_error(
    stop_object_vector_names_is_null(list(0L, list("a"))),
    "named list"
  )
expect_error(
    stop_vector_non_list_element(list(0L, list("a")), "object", 1),
    "must be a list"
  )
expect_error(
    stop_vector_wrong_size_element(
      list(0L, list("a")),
      "scalar_list",
      list(1, 1:2, NULL)
    ),
    "is not a list of scalars"
  )
expect_error(
    stop_vector_wrong_size_element(
      list(0L, list("a")),
      "object",
      list(1, 1:2, NULL)
    ),
    "is not an object"
  )
expect_error(stop_colmajor_null(list(0L, list("a"))), "must not be NULL")

test_that(".check_list() accepts lists and NULL when allowed (#noissue)", {
  expect_null(.check_list(list(1, 2, 3)))
  expect_null(.check_list(NULL, allow_null = TRUE))
})

test_that(".check_list() errors for non-lists and missing input (#noissue)", {
  expect_error(.check_list(1), "must be a list")
  expect_error(.check_list(), class = "missingArgError")
})

test_that(".check_arg_different() validates argument values (#noissue)", {
  expect_no_error(.check_arg_different(arg = 1, a = 2, b = 3))
  expect_error(
    .check_arg_different(arg = 1, a = 1),
    "must be different",
    class = "tibblify-error-args_same_value"
  )
})

test_that(".path_to_string() formats root and nested paths (#noissue)", {
  expect_identical(.path_to_string(list(-1L, list())), "x")
  expect_identical(
    .path_to_string(list(2L, list("a", "b", 0L, "c"))),
    "x$a$b[[1]]"
  )
})

test_that("error helpers report contextual path information (#noissue)", {
  expect_error(.stop_required(list(1L, list("a", "b"))), "required")
  expect_error(.stop_scalar(list(0L, list("a")), 2), "must have size")
  expect_error(.stop_duplicate_name(list(0L, list("a")), "nm"), "duplicated")
  expect_error(.stop_empty_name(list(0L, list("a")), 0L), "empty name")
  expect_error(.stop_names_is_null(list(0L, list("a"))), "is not named")
  expect_error(
    .stop_object_vector_names_is_null(list(0L, list("a"))),
    "named list"
  )
  expect_error(
    .stop_vector_non_list_element(list(0L, list("a")), "object", 1),
    "must be a list"
  )
  expect_error(
    .stop_vector_wrong_size_element(
      list(0L, list("a")),
      "scalar_list",
      list(1, 1:2, NULL)
    ),
    "is not a list of scalars"
  )
  expect_error(
    .stop_vector_wrong_size_element(
      list(0L, list("a")),
      "object",
      list(1, 1:2, NULL)
    ),
    "is not an object"
  )
  expect_error(.stop_colmajor_null(list(0L, list("a"))), "must not be")
  expect_error(
    .stop_colmajor_wrong_size_element(
      list(0L, list("a")),
      1,
      list(0L, list("b")),
      2
    ),
    "same size"
  )
  expect_error(
    .stop_required_colmajor(list(1L, list("a", "b"))),
    "every field is required"
  )
  expect_error(.stop_non_list_element(list(0L, list("a")), 1), "must be a list")
})

test_that(".vec_flatten() simplifie lists (#noissue)", {
  expect_identical(
    .vec_flatten(list(1:2, 3:4), ptype = integer()),
    c(1L, 2L, 3L, 4L)
  )
})

test_that(".compat_map_chr() maps to character vectors (#noissue)", {
  expect_identical(.compat_map_chr(1:3, as.character), c("1", "2", "3"))
})

test_that(".with_indexed_errors() rethrows purrr indexed errors (#noissue)", {
  ok <- .with_indexed_errors(
    purrr::map(1:2, \(x) x + 1),
    "bad at {cnd$location}"
  )
  expect_identical(ok, list(2, 3))

  expect_error(
    .with_indexed_errors(
      purrr::map(1:2, \(x) if (x == 2) rlang::abort("boom") else x),
      "bad at {cnd$location}"
    ),
    "bad at 2"
  )
})

test_that(".is_url_string() detects http and https URLs (#noissue)", {
  expect_true(.is_url_string("https://example.com"))
  expect_true(.is_url_string("http://example.com"))
  expect_false(.is_url_string("ftp://example.com"))
  expect_false(.is_url_string(c("https://example.com", "https://example.org")))
})

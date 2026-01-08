test_that("tib_variant produces the expected spec", {
  expect_equal(tib_variant("x")$type, "variant")
})

test_that("tib_recursive produces the expected spec", {
  test_result <- tib_recursive(
    "data",
    .children = "children",
    tib_int("id"),
    tib_chr("name"),
  )
  expect_equal(test_result$child, "children")
  expect_equal(test_result$children_to, "children")
})

test_that("empty dots create empty list", {
  # TODO: These should be in tspec.
  # expect_equal(tspec_df()$fields, list())
  # expect_equal(tspec_row()$fields, list())
  # expect_equal(tspec_object()$fields, list())

  expect_equal(tib_df("x")$fields, list())
  expect_equal(tib_row("x")$fields, list())
})

test_that("tib_df() checks arguments", {
  expect_snapshot({
    (expect_error(tib_df("x", .names_to = 1)))
  })
})

test_that("tib_df() drops NULL", {
  expect_equal(
    tib_df("df", tib_int("a"), NULL, if (FALSE) tib_chr("b")),
    tib_df("df", tib_int("a"))
  )
})

test_that("Unexported predicate functions work as expected", {
  test_variant <- tib_variant("x")
  test_row <- tib_row("x")

  # .is_tib_variant
  expect_false(.is_tib_variant(test_row))
  expect_true(.is_tib_variant(test_variant))

  # .is_tib_row
  expect_false(.is_tib_row(test_variant))
  expect_true(.is_tib_row(test_row))
})

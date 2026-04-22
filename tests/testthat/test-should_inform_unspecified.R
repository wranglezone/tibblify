test_that("should_inform_unspecified defaults to TRUE", {
  withr::local_options(tibblify.show_unspecified = NULL)
  expect_true(should_inform_unspecified())
})

test_that("should_inform_unspecified respects the option", {
  withr::local_options(tibblify.show_unspecified = TRUE)
  expect_true(should_inform_unspecified())
  withr::local_options(tibblify.show_unspecified = FALSE)
  expect_false(should_inform_unspecified())
})

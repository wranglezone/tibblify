test_that("check_list works for allowed NULL", {
  expect_null(check_list(NULL, allow_null = TRUE))
})

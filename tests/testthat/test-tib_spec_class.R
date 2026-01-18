test_that("tib_chr_date works", {
  expect_equal(
    tib_chr_date("a"),
    .tib_scalar_impl(
      "a",
      .ptype = vctrs::new_date(),
      .ptype_inner = character(),
      .format = "%Y-%m-%d",
      .transform = ~ as.Date(.x, format = .format),
      .class = "tib_scalar_chr_date"
    ),
    ignore_function_env = TRUE
  )

  expect_equal(
    tib_chr_date_vec("a"),
    .tib_vector_impl(
      "a",
      .ptype = vctrs::new_date(),
      .ptype_inner = character(),
      .format = "%Y-%m-%d",
      .transform = ~ as.Date(.x, format = .format),
      .class = "tib_vector_chr_date"
    ),
    ignore_function_env = TRUE
  )
})

test_that("tib_*() and tib_*_vec() return the expected objects", {
  expect_type(tib_lgl("x")$ptype, "logical")
  expect_type(tib_lgl_vec("x")$ptype, "logical")
  expect_type(tib_int("x")$ptype, "integer")
  expect_type(tib_int_vec("x")$ptype, "integer")
  expect_type(tib_dbl("x")$ptype, "double")
  expect_type(tib_dbl_vec("x")$ptype, "double")
  expect_type(tib_chr("x")$ptype, "character")
  expect_type(tib_chr_vec("x")$ptype, "character")
  expect_s3_class(tib_date("x")$ptype, "Date")
  expect_s3_class(tib_date_vec("x")$ptype, "Date")
})

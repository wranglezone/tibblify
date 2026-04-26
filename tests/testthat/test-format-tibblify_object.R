test_that("correctly print results of tspec_object()", {
  expect_snapshot(tibblify(list(a = 1L), tspec_object(tib_int("a"))))
})

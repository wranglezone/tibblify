test_that("can print tspecs", {
  expect_snapshot(
    tspec_df(tib_int("id"), tib_chr("name"), tib_chr_vec("aliases"))
  )
})

test_that("prints non-canonical names", {
  expect_snapshot({
    tspec_df(b = tib_int("a")) |> format()
    tspec_df(b = tib_int(c("a", "b"))) |> format()
  })
})

test_that("can force to print canonical names (#98)", {
  withr::local_options(list(tibblify.print_names = TRUE))
  expect_snapshot({
    tspec_df(
      a = tib_int("a"),
      b = tib_df(
        "b",
        x = tib_int("x")
      )
    ) |>
      format()
  })
})

test_that("format for empty tspec_* works", {
  expect_equal(format(tspec_df()), "tspec_df()")
  expect_equal(format(tspec_row()), "tspec_row()")
  expect_equal(format(tspec_object()), "tspec_object()")
})

test_that("prints arguments of spec_* (#95)", {
  expect_equal(
    format(tspec_df(tib_int("a"), .input_form = "colmajor")),
    'tspec_df(\n  .input_form = "colmajor",\n  tib_int("a"),\n)'
  )

  expect_equal(
    format(tspec_df(tib_int("a"), .names_to = "nms")),
    'tspec_df(\n  .names_to = "nms",\n  tib_int("a"),\n)'
  )

  expect_equal(
    format(tspec_df(tib_int("a"), .vector_allows_empty_list = TRUE)),
    'tspec_df(\n  .vector_allows_empty_list = TRUE,\n  tib_int("a"),\n)'
  )

  expect_equal(
    format(tspec_row(tib_int("a"), .vector_allows_empty_list = TRUE)),
    'tspec_row(\n  .vector_allows_empty_list = TRUE,\n  tib_int("a"),\n)'
  )

  expect_equal(
    format(tspec_object(tib_int("a"), .vector_allows_empty_list = TRUE)),
    'tspec_object(\n  .vector_allows_empty_list = TRUE,\n  tib_int("a"),\n)'
  )
})

test_that("prints arguments of tspec_recursive (#155)", {
  expect_equal(
    format(tspec_recursive(tib_int("a"), .children = "children")),
    'tspec_recursive(\n  .children = "children",\n  tib_int("a"),\n)'
  )

  expect_equal(
    format(tspec_recursive(
      tib_int("a"),
      .children = "children",
      .vector_allows_empty_list = TRUE
    )),
    'tspec_recursive(\n  .children = "children",\n  .vector_allows_empty_list = TRUE,\n  tib_int("a"),\n)'
  )
})

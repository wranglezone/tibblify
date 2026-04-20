test_that("informing about unspecified looks good (#38)", {
  spec <- tspec_df(
    tib_int("1int"),
    tib_unspecified("1un"),
    tib_df(
      "1df",
      tib_int("2int"),
      tib_unspecified("2un"),
      tib_row(
        "2row",
        `3un` = tib_unspecified("key"),
        `3un2` = tib_unspecified("key2"),
      )
    ),
    tib_row(
      "1row",
      tib_unspecified("2un2"),
      `2un3` = tib_unspecified("key")
    )
  )
  expect_snapshot({
    .spec_inform_unspecified(spec)
  })
  expect_snapshot(
    {
      .spec_inform_unspecified(spec, "error")
    },
    error = TRUE
  )
})

test_that(".spec_inform_unspecified is silent when nothing unspecified (#38)", {
  spec <- tspec_df(tib_int("1int"))
  .spec_inform_unspecified(spec) |>
    expect_identical(spec) |>
    expect_no_message()
})

test_that(".maybe_inform_unspecified handles informing", {
  spec <- tspec_df(tib_int("1int"), tib_unspecified("1un"))
  .maybe_inform_unspecified(spec, FALSE) |>
    expect_identical(spec) |>
    expect_no_message()
  .maybe_inform_unspecified(spec, TRUE) |>
    expect_identical(spec) |>
    expect_message("1 unspecified")
})

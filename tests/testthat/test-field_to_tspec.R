test_that("field_to_tspec_df works (#346)", {
  spec <- tspec_df(
    tib_int("id"),
    tib_df(
      "address",
      tib_chr("street"),
      tib_chr("city")
    )
  )

  expect_equal(
    field_to_tspec_df(spec, "address"),
    tspec_df(
      tib_chr("street"),
      tib_chr("city")
    )
  )
})

test_that("field_to_tspec_df preserves .names_to (#346)", {
  spec <- tspec_df(
    tib_df(
      "items",
      .names_to = "name",
      tib_int("value")
    )
  )

  expect_equal(
    field_to_tspec_df(spec, "items"),
    tspec_df(
      tib_int("value"),
      .names_to = "name"
    )
  )
})

test_that("field_to_tspec_df preserves .vector_allows_empty_list (#346)", {
  spec <- tspec_df(
    tib_df("items", tib_int("value")),
    .vector_allows_empty_list = TRUE
  )

  expect_equal(
    field_to_tspec_df(spec, "items"),
    tspec_df(tib_int("value"), .vector_allows_empty_list = TRUE)
  )
})

test_that("field_to_tspec_row works (#346)", {
  spec <- tspec_df(
    tib_row(
      "location",
      tib_dbl("lat"),
      tib_dbl("lng")
    )
  )

  expect_equal(
    field_to_tspec_row(spec, "location"),
    tspec_row(
      tib_dbl("lat"),
      tib_dbl("lng")
    )
  )
})

test_that("field_to_tspec_row preserves .vector_allows_empty_list (#346)", {
  spec <- tspec_df(
    tib_row("location", tib_dbl("lat")),
    .vector_allows_empty_list = TRUE
  )

  expect_equal(
    field_to_tspec_row(spec, "location"),
    tspec_row(tib_dbl("lat"), .vector_allows_empty_list = TRUE)
  )
})

test_that("field_to_tspec_recursive works (#346)", {
  spec <- tspec_df(
    tib_int("id"),
    tib_recursive(
      "children",
      tib_chr("name"),
      .children = "children"
    )
  )

  expect_equal(
    field_to_tspec_recursive(spec, "children"),
    tspec_recursive(
      tib_chr("name"),
      .children = "children"
    )
  )
})

test_that("field_to_tspec_recursive preserves .children_to (#346)", {
  spec <- tspec_df(
    tib_recursive(
      "nodes",
      tib_chr("label"),
      .children = "nodes",
      .children_to = "kids"
    )
  )

  expect_equal(
    field_to_tspec_recursive(spec, "nodes"),
    tspec_recursive(
      tib_chr("label"),
      .children = "nodes",
      .children_to = "kids"
    )
  )
})

test_that("field_to_tspec dispatches on tib_df (#346)", {
  spec <- tspec_df(
    tib_df("items", tib_chr("name"))
  )
  expect_equal(field_to_tspec(spec, "items"), field_to_tspec_df(spec, "items"))
})

test_that("field_to_tspec dispatches on tib_row (#346)", {
  spec <- tspec_df(
    tib_row("loc", tib_dbl("x"))
  )
  expect_equal(field_to_tspec(spec, "loc"), field_to_tspec_row(spec, "loc"))
})

test_that("field_to_tspec dispatches on tib_recursive (#346)", {
  spec <- tspec_df(
    tib_recursive("nodes", tib_chr("label"), .children = "nodes")
  )
  expect_equal(
    field_to_tspec(spec, "nodes"),
    field_to_tspec_recursive(spec, "nodes")
  )
})

test_that("field_to_tspec errors on non-nested field types (#346)", {
  spec <- tspec_df(tib_int("id"))
  expect_snapshot({
    (expect_error(field_to_tspec(spec, "id")))
  })
})

test_that("field_to_tspec_df errors on wrong field type (#346)", {
  spec <- tspec_df(tib_row("loc", tib_dbl("x")))
  expect_snapshot({
    (expect_error(field_to_tspec_df(spec, "loc")))
  })
})

test_that("field_to_tspec_row errors on wrong field type (#346)", {
  spec <- tspec_df(tib_df("items", tib_chr("name")))
  expect_snapshot({
    (expect_error(field_to_tspec_row(spec, "items")))
  })
})

test_that("field_to_tspec_recursive errors on wrong field type (#346)", {
  spec <- tspec_df(tib_int("id"))
  expect_snapshot({
    (expect_error(field_to_tspec_recursive(spec, "id")))
  })
})

test_that("field_to_tspec errors if field doesn't exist (#346)", {
  spec <- tspec_df(tib_int("id"))
  expect_snapshot({
    (expect_error(field_to_tspec(spec, "missing")))
    (expect_error(field_to_tspec_df(spec, "missing")))
    (expect_error(field_to_tspec_row(spec, "missing")))
    (expect_error(field_to_tspec_recursive(spec, "missing")))
  })
})

test_that("field_to_tspec errors if spec is not a tspec (#346)", {
  expect_snapshot({
    (expect_error(field_to_tspec(list(), "x")))
    (expect_error(field_to_tspec_df(list(), "x")))
    (expect_error(field_to_tspec_row(list(), "x")))
    (expect_error(field_to_tspec_recursive(list(), "x")))
  })
})

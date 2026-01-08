test_that("tspec_df errors on invalid names", {
  expect_snapshot({
    # duplicated name
    (expect_error(tspec_df(x = tib_int("x"), x = tib_int("y"))))
  })
})

test_that("tspec_df errors if element is not a tib collector", {
  expect_snapshot({
    (expect_error(tspec_df(1)))
    (expect_error(tspec_df(x = tib_int("x"), y = "a")))
  })
})

test_that("tspec_df can infer name from key", {
  expect_equal(tspec_df(tib_int("x")), tspec_df(x = tib_int("x")))

  expect_equal(
    tspec_df(tib_row("x", tib_int("a"))),
    tspec_df(x = tib_row("x", a = tib_int("a")))
  )

  expect_snapshot({
    (expect_error(tspec_df(tib_int(c("a", "b")))))

    # auto name creates duplicated name
    (expect_error(tspec_df(y = tib_int("x"), tib_int("y"))))
  })
})

test_that("tspec_df errors on invalid `.names_to`", {
  expect_snapshot({
    (expect_error(tspec_df(.names_to = NA_character_)))
    (expect_error(tspec_df(.names_to = 1)))
  })
})

test_that("tspec_df errors if `.names_to` column name is not unique", {
  expect_snapshot((expect_error(tspec_df(x = tib_int("x"), .names_to = "x"))))
})

test_that("tspec_df errors if `.names_to` is used with colmajor", {
  expect_snapshot({
    (expect_error(tspec_df(.names_to = "x", .input_form = "colmajor")))
  })
})

test_that("tspec_df errors if `vector_allows_empty_list` is invalid", {
  expect_snapshot({
    (expect_error(tspec_df(.vector_allows_empty_list = NA)))
    (expect_error(tspec_df(.vector_allows_empty_list = "a")))
  })
})

test_that("empty dots create empty list", {
  expect_equal(tspec_df()$fields, list())
  expect_equal(tspec_row()$fields, list())
  expect_equal(tspec_object()$fields, list())
})

test_that("tspec_* can nest specifications", {
  spec1 <- tspec_row(
    a = tib_int("a"),
    b = tib_int("b")
  )
  spec2 <- tspec_row(
    c = tib_chr("c"),
    d = tib_row("d", x = tib_int("x"))
  )

  expect_equal(
    tspec_df(spec1),
    tspec_df(!!!spec1$fields)
  )

  expect_equal(
    tspec_df(spec1, spec2),
    tspec_df(!!!spec1$fields, !!!spec2$fields)
  )

  expect_snapshot((expect_error(tspec_df(spec1, spec1))))
})

test_that("tspec_row drops NULL", {
  expect_equal(
    tspec_row(tib_int("a"), NULL, if (FALSE) tib_chr("b")),
    tspec_row(tib_int("a"))
  )
})

test_that("tspec_recursive errors for bad .children and .children_to", {
  expect_snapshot({
    (expect_error(
      tspec_recursive(.children = 1L)
    ))
    (expect_error(
      tspec_recursive(.children = "a", .children_to = 1L)
    ))
  })
})

test_that("tspec_recursive creates the expected spec", {
  expect_equal(
    tspec_recursive(
      tib_int("id"),
      tib_chr("name", .required = FALSE),
      .children = "children"
    ),
    structure(
      list(
        type = "recursive",
        fields = list(
          id = tib_int("id"),
          name = tib_chr("name", .required = FALSE)
        ),
        child = "children",
        children_to = "children",
        input_form = "rowmajor",
        vector_allows_empty_list = FALSE
      ),
      class = c("tspec_recursive", "tspec")
    )
  )
})

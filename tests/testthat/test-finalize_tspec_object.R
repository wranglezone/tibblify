test_that("tspec_object() works", {
  x <- list(a = 1, b = 1:3)
  spec <- tspec_row(a = tib_int("a"), b = tib_int_vec("b"))

  expect_equal(
    tibblify(x, spec),
    tibble(a = 1L, b = vctrs::list_of(1:3))
  )
  expect_equal(
    tibblify(x, tspec_object(spec)),
    structure(list(a = 1L, b = 1:3), class = "tibblify_object")
  )

  model <- lm(Sepal.Length ~ Sepal.Width, data = iris)
  expect_equal(
    tibblify(
      list(x = model, y = NULL),
      tspec_object(tib_variant("x"), tib_unspecified("y")),
      unspecified = "list"
    ),
    structure(list(x = model, y = NULL), class = "tibblify_object")
  )

  x2 <- list(
    a = list(
      x = 1,
      y = list(a = 1),
      z = list(
        list(b = 1),
        list(b = 2)
      )
    )
  )

  spec2 <- tspec_row(
    a = tib_row(
      "a",
      x = tib_int("x"),
      y = tib_row("y", a = tib_int("a")),
      z = tib_df("z", b = tib_int("b"))
    )
  )

  expect_equal(
    tibblify(x2, spec2),
    tibble(
      a = tibble(
        x = 1L,
        y = tibble(a = 1L),
        z = vctrs::list_of(tibble(b = 1:2))
      )
    )
  )
  expect_equal(
    tibblify(x2, tspec_object(spec2)),
    structure(
      list(
        a = list(
          x = 1L,
          y = list(a = 1L),
          z = tibble(b = 1:2)
        )
      ),
      class = "tibblify_object"
    )
  )

  # can handle sub collector + different order
  spec3 <- tspec_object(
    tib_chr("c"),
    bb = tib_chr(c("b", "b")),
    tib_chr("a"),
    ba = tib_chr(c("b", "a")),
  )
  expect_equal(
    tibblify(
      list(a = "a", c = "c", b = list(a = "ba", b = "bb")),
      spec3
    ),
    structure(
      list(c = "c", bb = "bb", a = "a", ba = "ba"),
      class = "tibblify_object"
    )
  )
})

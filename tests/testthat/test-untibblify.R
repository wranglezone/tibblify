test_that("can untibblify a scalar column (#49)", {
  expect_equal(
    untibblify(tibble(x = 1:2)),
    list(list(x = 1), list(x = 2))
  )
  expect_equal(
    untibblify(tibble(x = new_rational(1, 1:2))),
    list(list(x = new_rational(1, 1)), list(x = new_rational(1, 2)))
  )
})

test_that("can untibblify a vector column (#49)", {
  expect_equal(
    untibblify(tibble(x = list(NULL, 1:3))),
    list(list(x = NULL), list(x = 1:3))
  )
})

test_that("can untibblify a list column (#49)", {
  expect_equal(
    untibblify(tibble(x = list("a", 1))),
    list(list(x = "a"), list(x = 1))
  )
  model <- lm(Sepal.Length ~ Sepal.Width, data = iris)
  expect_equal(
    untibblify(tibble(x = list(model, 1))),
    list(list(x = model), list(x = 1))
  )
})

test_that("can untibblify a tibble column (#49)", {
  x <- tibble(
    x = tibble(
      int = 1:2,
      chr_vec = list("a", NULL),
      df = tibble(chr = c("a", "b"))
    )
  )
  expect_equal(
    untibblify(x),
    list(
      list(x = list(int = 1L, chr_vec = "a", df = list(chr = "a"))),
      list(x = list(int = 2L, chr_vec = NULL, df = list(chr = "b")))
    )
  )
})

test_that("can untibblify a list of tibble column (#49)", {
  x <- tibble(
    x = list(
      tibble(
        int = 1:2,
        chr_vec = list("a", NULL),
        df = tibble(chr = c("a", "b"))
      ),
      tibble(
        int = 3,
        chr_vec = list("c"),
        df = tibble(chr = NA_character_)
      )
    )
  )
  expect_equal(
    untibblify(x),
    list(
      list(
        x = list(
          list(int = 1L, chr_vec = "a", df = list(chr = "a")),
          list(int = 2L, chr_vec = NULL, df = list(chr = "b"))
        )
      ),
      list(
        x = list(list(int = 3L, chr_vec = "c", df = list(chr = NA_character_)))
      )
    )
  )
})

test_that("can rename according to tspec_df (#49)", {
  spec <- tspec_df(
    x2 = tib_df(
      "x",
      int2 = tib_int("int"),
      chr_vec2 = tib_chr("chr_vec"),
      df2 = tib_row(
        "df",
        chr2 = tib_chr("chr")
      )
    )
  )
  x_tibbed <- tibble(
    x2 = list(
      tibble(
        int2 = 1:2,
        chr_vec2 = list("a", NULL),
        df2 = tibble(chr2 = c("a", "b"))
      ),
      tibble(
        int2 = 3,
        chr_vec2 = list("c"),
        df2 = tibble(chr2 = NA_character_)
      )
    )
  )
  expect_equal(
    untibblify(x_tibbed, spec),
    list(
      list(
        x = list(
          list(int = 1L, chr_vec = "a", df = list(chr = "a")),
          list(int = 2L, chr_vec = NULL, df = list(chr = "b"))
        )
      ),
      list(
        x = list(list(int = 3L, chr_vec = "c", df = list(chr = NA_character_)))
      )
    )
  )
})

test_that("can untibblify object (#49)", {
  model <- lm(Sepal.Length ~ Sepal.Width, data = iris)
  expect_equal(
    untibblify(
      list(
        int = 1,
        chr_vec = c("a", "b"),
        model = model,
        df = tibble(x = 1:2, y = c(TRUE, FALSE))
      )
    ),
    list(
      int = 1,
      chr_vec = c("a", "b"),
      model = model,
      df = list(list(x = 1, y = TRUE), list(x = 2, y = FALSE))
    )
  )
})

test_that("can rename according to spec (#49)", {
  expect_equal(
    untibblify(list(x = 1), tspec_object(x = tib_int("a"))),
    list(a = 1)
  )
  x <- list(x = list(a = 1, b = 2))
  spec <- tspec_object(
    x2 = tib_row("x", a2 = tib_dbl("a"), b2 = tib_dbl("b"))
  )
  x_tibbed <- list(x2 = list(a2 = 1, b2 = 2))
  expect_equal(untibblify(x_tibbed, spec), x)
})

test_that("untibblify uses tib_spec attribute when no spec provided (#235)", {
  input <- list(list(x = 1, y = "a"), list(x = 2, y = "b"))
  spec <- tspec_df(x2 = tib_int("x"), y2 = tib_chr("y"))
  tibbed <- tibblify(input, spec)
  expect_equal(untibblify(tibbed), input)
})

test_that(".apply_spec_renaming() errors on nested key", {
  spec <- structure(
    list(
      fields = list(
        x = structure(list(key = c("a", "b")), class = "tib_collector")
      )
    ),
    class = "tspec_df"
  )
  expect_snapshot({
    (expect_error(untibblify(tibble(x = 1), spec)))
  })
})

test_that(".apply_spec_renaming() errors on non-character key", {
  spec <- structure(
    list(fields = list(x = structure(list(key = 1L), class = "tib_collector"))),
    class = "tspec_df"
  )
  expect_snapshot({
    (expect_error(untibblify(tibble(x = 1), spec)))
  })
})

test_that("untibblify checks input (#49)", {
  expect_snapshot({
    (expect_error(untibblify(1:3)))
    (expect_error(untibblify(new_rational(1, 1:3))))
  })
})

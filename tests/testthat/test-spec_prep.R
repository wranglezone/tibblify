# rowmajor ----------------------------------------------------------------

test_that("fill is used as-is when there isn't a names column", {
  expect_equal(
    tib(list(x = NULL), tib_int_vec("x", .fill = 1:2)),
    tibble(x = vctrs::list_of(NULL, .ptype = integer()))
  )
})

test_that("fill is populated properly with names_to", {
  spec <- tib_int_vec(
    "x",
    .fill = c(x = 1L, y = 2L),
    .required = FALSE,
    .input_form = "object",
    .values_to = "val",
    .names_to = "name"
  )
  expect_equal(
    tib(list(a = 1), spec),
    tibble(x = vctrs::list_of(tibble(name = c("x", "y"), val = c(1L, 2L))))
  )
})

test_that("ptype is dealt with when names_to used", {
  expect_equal(
    tib(
      list(x = c(a = 1L, b = 2L)),
      tib_int_vec("x", .names_to = "name", .values_to = "val")
    ),
    tibble(
      x = vctrs::list_of(
        tibble(name = c("a", "b"), val = c(a = 1L, b = 2L)),
        .ptype = tibble(name = character(), val = integer())
      )
    )
  )
})

test_that("default for same key collector works", {
  expect_equal(
    tibblify(
      list(list(x = list(a = 1, b = 2)), list()),
      tspec_df(
        a = tib_int(c("x", "a"), .required = FALSE),
        b = tib_int(c("x", "b"), .required = FALSE),
      )
    ),
    tibble(a = c(1L, NA), b = c(2L, NA))
  )
})

# colmajor ----------------------------------------------------------------

test_that("colmajor works", {
  dtt <- vctrs::new_datetime(1, tzone = "UTC")
  x_rcrd <- as.POSIXlt(Sys.time(), tz = "UTC")

  spec <- tspec_df(
    .input_form = "colmajor",
    tib_lgl("lgl"),
    tib_scalar("dtt", dtt),
    tib_scalar("rcrd", x_rcrd),
    tib_lgl_vec("lgl_vec"),
    tib_variant("variant"),
    tib_row("row", a = tib_lgl("a")),
    tib_df("df", tib_int("int"))
  )

  input <- list(
    lgl = c(TRUE, FALSE),
    dtt = c(dtt, dtt + 1),
    rcrd = c(x_rcrd, x_rcrd + 1),
    lgl_vec = list(c(TRUE, FALSE), TRUE),
    variant = list(TRUE, 1),
    row = list(a = c(TRUE, FALSE)),
    df = list(
      list(int = 1:2),
      list(int = integer())
    )
  )

  expect_equal(
    tibblify(input, spec),
    tibble(
      lgl = c(TRUE, FALSE),
      dtt = c(dtt, dtt + 1),
      rcrd = c(x_rcrd, x_rcrd + 1),
      lgl_vec = vctrs::list_of(c(TRUE, FALSE), TRUE),
      variant = list(TRUE, 1),
      row = tibble(a = c(TRUE, FALSE)),
      df = vctrs::list_of(tibble(int = 1:2), tibble(int = integer()))
    )
  )
})

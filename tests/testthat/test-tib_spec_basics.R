test_that("errors on invalid `.key`", {
  expect_snapshot({
    (expect_error(tib_scalar(character(), logical())))

    (expect_error(tib_scalar(NA_character_, logical())))
    (expect_error(tib_scalar("", logical())))
    (expect_error(tib_scalar(1L, logical())))

    (expect_error(tib_scalar(c("x", NA), logical())))
    (expect_error(tib_scalar(c("x", ""), logical())))
  })
})

test_that("errors on invalid `.required`", {
  expect_snapshot({
    (expect_error(tib_scalar("x", logical(), .required = logical())))

    (expect_error(tib_scalar("x", logical(), .required = NA)))
    (expect_error(tib_scalar("x", logical(), .required = 1L)))
    (expect_error(tib_scalar("x", logical(), .required = c(TRUE, FALSE))))
  })
})

test_that("errors if dots are not empty", {
  expect_snapshot({
    (expect_error(tib_scalar("x", logical(), TRUE)))
  })
})

test_that("tib_scalar checks arguments", {
  model <- lm(Sepal.Length ~ Sepal.Width, data = iris)
  # .ptype
  expect_snapshot({
    (expect_error(tib_scalar("x", model)))
  })

  # .ptype_inner
  expect_snapshot({
    (expect_error(tib_scalar("x", character(), .ptype_inner = model)))
  })

  # .fill
  expect_snapshot({
    (expect_error(tib_scalar("x", integer(), .fill = integer())))
    (expect_error(tib_scalar("x", integer(), .fill = 1:2)))
    (expect_error(tib_scalar("x", integer(), .fill = "a")))
  })

  # .ptype_inner + .fill
  expect_snapshot({
    (expect_error(tib_scalar(
      "x",
      character(),
      .fill = 0L,
      .ptype_inner = character()
    )))
  })

  # .transform
  expect_snapshot({
    (expect_error(tib_scalar("x", integer(), .transform = integer())))
  })
})

test_that("tib_vector checks arguments", {
  # .input_form
  expect_snapshot({
    (expect_error(tib_vector("x", integer(), .input_form = "v")))
  })

  model <- lm(Sepal.Length ~ Sepal.Width, data = iris)
  # .ptype
  expect_snapshot({
    (expect_error(tib_vector("x", .ptype = model)))
  })

  # .ptype_inner
  expect_snapshot({
    (expect_error(tib_vector("x", character(), .ptype_inner = model)))
  })

  # .values_to
  expect_snapshot({
    (expect_error(tib_vector("x", integer(), .values_to = NA)))
    (expect_error(tib_vector("x", integer(), .values_to = 1)))
    (expect_error(tib_vector("x", integer(), .values_to = c("a", "b"))))
  })

  # .names_to
  expect_snapshot({
    # .input_form != "object"
    (expect_error(tib_vector(
      "x",
      integer(),
      .input_form = "scalar_list",
      .values_to = "val",
      .names_to = "name"
    )))
    # .values_to = NULL
    (expect_error(tib_vector(
      "x",
      integer(),
      .input_form = "object",
      .names_to = "name"
    )))
    # .values_to = .names_to
    (expect_error(tib_vector(
      "x",
      integer(),
      .input_form = "object",
      .values_to = "val",
      .names_to = "val"
    )))

    (expect_error(tib_vector(
      "x",
      integer(),
      .input_form = "object",
      .values_to = "val",
      .names_to = 1
    )))
    (expect_error(tib_vector(
      "x",
      integer(),
      .input_form = "object",
      .values_to = "val",
      .names_to = c("a", "b")
    )))
  })
})

test_that("special ptypes are not incorrectly recognized", {
  check_native <- function(.ptype, .class) {
    expect_s3_class(
      tib_scalar("a", .ptype = .ptype),
      c(paste0("tib_scalar_", .class), "tib_scalar", "tib_collector"),
      exact = TRUE
    )

    class(.ptype) <- c("a", class(.ptype))
    expect_s3_class(
      tib_scalar("a", .ptype = .ptype),
      c("tib_scalar", "tib_collector"),
      exact = TRUE
    )
  }

  check_native(logical(), "logical")
  check_native(character(), "character")
  check_native(integer(), "integer")
  check_native(numeric(), "numeric")
  check_native(vctrs::new_date(), "date")
})

test_that("tib_scalar warns for deprecated ptype_inner", {
  skip_on_covr()
  withr::local_options(
    lifecycle_verbosity = "warning"
  )
  expect_warning(
    {
      expect_warning(
        {
          test_result <- tib_scalar("x", ptype = integer())
        },
        "\\.ptype"
      )
    },
    ".ptype_inner"
  )
})

test_that("tib_scalar deals with deprecated ptype_inner", {
  suppressWarnings({
    test_result <- tib_scalar("x", ptype = integer())
  })
  expect_equal(
    test_result$ptype_inner,
    test_result$ptype
  )
})

test_that(".fill arg of tib_vector() is used properly", {
  expect_equal(
    tib_vector("x", character(), .fill = "missing")$fill,
    "missing"
  )
})

test_that("tib_unspecified() creates the expected spec", {
  test_result <- tib_unspecified("x")
  expect_s3_class(
    test_result,
    c("tib_unspecified", "tib_collector")
  )
})

test_that("Unexported predicate functions work as expected", {
  test_unspecified <- tib_unspecified("x")
  test_scalar <- tib_scalar("x", integer())
  test_vector <- tib_vector("x", integer())

  # .is_tib
  expect_false(.is_tib("not a spec"))
  expect_true(.is_tib(test_unspecified))
  expect_true(.is_tib(test_scalar))
  expect_true(.is_tib(test_vector))

  # .is_tib_scalar
  expect_false(.is_tib_scalar(test_vector))
  expect_true(.is_tib_scalar(test_scalar))

  # .is_tib_vector
  expect_false(.is_tib_vector(test_scalar))
  expect_true(.is_tib_vector(test_vector))

  # .is_tib_unspecified
  expect_false(.is_tib_unspecified(test_scalar))
  expect_true(.is_tib_unspecified(test_unspecified))
})

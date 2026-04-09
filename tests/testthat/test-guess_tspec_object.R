test_that("guess_tspec_object gives nice errors", {
  expect_snapshot({
    (expect_error(guess_tspec_object(tibble(a = 1))))
    (expect_error(guess_tspec_object(1:3)))
  })

  expect_snapshot({
    (expect_error(guess_tspec_object(list(1, a = 1))))
    (expect_error(guess_tspec_object(list(a = 1, a = 1))))
  })
})

test_that("guess_tspec_object can guess scalar elements", {
  expect_equal(
    guess_tspec_object(list(x = TRUE)),
    tspec_object(x = tib_lgl("x"))
  )

  expect_equal(
    guess_tspec_object(list(x = vctrs::new_datetime(1))),
    tspec_object(x = tib_scalar("x", vctrs::new_datetime()))
  )

  # also for record types
  x_rat <- new_rational(1, 2)
  expect_equal(
    guess_tspec_object(list(x = x_rat)),
    tspec_object(x = tib_scalar("x", .ptype = x_rat))
  )
})

test_that("guess_tspec_object can handle non-vector elements (#76, #84)", {
  model <- lm(Sepal.Length ~ Sepal.Width, data = iris)
  expect_equal(
    guess_tspec_object(list(x = model)),
    tspec_object(x = tib_variant("x"))
  )
})

test_that("guess_tspec_object can guess vector elements", {
  expect_equal(
    guess_tspec_object(list(x = c(TRUE, FALSE))),
    tspec_object(x = tib_lgl_vec("x"))
  )

  expect_equal(
    guess_tspec_object(list(
      x = c(vctrs::new_datetime(1), vctrs::new_datetime(2))
    )),
    tspec_object(x = tib_vector("x", vctrs::new_datetime()))
  )

  # also for record types
  x_rat <- new_rational(1, 2)
  expect_equal(
    guess_tspec_object(list(x = c(x_rat, x_rat))),
    tspec_object(x = tib_vector("x", .ptype = x_rat))
  )
})

test_that("guess_tspec_object can guess tib_vector for a scalar list (#94)", {
  expect_equal(
    guess_tspec_object(list(x = list(TRUE, TRUE, NULL)), simplify_list = FALSE),
    tspec_object(x = tib_variant("x"))
  )

  expect_equal(
    guess_tspec_object(list(x = list(TRUE, TRUE, NULL)), simplify_list = TRUE),
    tspec_object(x = tib_lgl_vec("x", .input_form = "scalar_list"))
  )

  expect_equal(
    guess_tspec_object(
      list(x = list(vctrs::new_datetime(1))),
      simplify_list = TRUE
    ),
    tspec_object(
      x = tib_vector("x", vctrs::new_datetime(), .input_form = "scalar_list")
    )
  )

  # checks size
  expect_equal(
    guess_tspec_object(list(x = list(1, 1:2)), simplify_list = TRUE),
    tspec_object(x = tib_variant("x"))
  )

  expect_equal(
    guess_tspec_object(list(x = list(1, integer())), simplify_list = TRUE),
    tspec_object(x = tib_variant("x"))
  )
})

test_that("guess_tspec_object can guess tib_vector for input form = object (#94)", {
  expect_equal(
    guess_tspec_object(
      list(x = list(a = TRUE, b = TRUE)),
      simplify_list = TRUE
    ),
    tspec_object(x = tib_lgl_vec("x", .input_form = "object"))
  )
})

test_that("guess_tspec_object falls back to tib_variant for rcrd ptype with simplify_list (#noissue)", {
  x_rat <- new_rational(1, 2)
  expect_equal(
    guess_tspec_object(list(x = list(x_rat, x_rat)), simplify_list = TRUE),
    tspec_object(x = tib_variant("x"))
  )
})

test_that("guess_tspec_object can guess mixed elements", {
  expect_equal(
    guess_tspec_object(list(x = list(TRUE, "a"))),
    tspec_object(x = tib_variant("x"))
  )
})

test_that("guess_tspec_object can handle non-vector elements in list (#76, #84)", {
  model <- lm(Sepal.Length ~ Sepal.Width, data = iris)
  expect_equal(
    guess_tspec_object(list(x = list(model, model))),
    tspec_object(x = tib_variant("x"))
  )
})

test_that("guess_tspec_object can guess df element (#81)", {
  expect_equal(
    guess_tspec_object(list(x = tibble(a = 1L))),
    tspec_object(x = tib_df("x", a = tib_int("a")))
  )
})

test_that("guess_tspec_object can guess tib_row", {
  expect_equal(
    guess_tspec_object(list(x = list(a = 1L, b = "a"))),
    tspec_object(x = tib_row("x", a = tib_int("a"), b = tib_chr("b")))
  )
})

test_that("guess_tspec_object can guess tib_row with a scalar list (#94)", {
  expect_equal(
    guess_tspec_object(
      list(x = list(a = list(1L, 2L), b = "a")),
      simplify_list = TRUE
    ),
    tspec_object(
      x = tib_row(
        "x",
        a = tib_int_vec("a", .input_form = "scalar_list"),
        b = tib_chr("b")
      )
    )
  )
})

test_that("guess_tspec_object can guess tib_df", {
  expect_equal(
    guess_tspec_object(
      list(
        x = list(
          list(a = 1L),
          list(a = 2L)
        )
      )
    ),
    tspec_object(x = tib_df("x", a = tib_int("a")))
  )

  expect_equal(
    guess_tspec_object(
      list(
        x = list(
          list(a = 1:2L),
          list(a = 2L)
        )
      )
    ),
    tspec_object(x = tib_df("x", a = tib_int_vec("a")))
  )

  expect_equal(
    guess_tspec_object(
      list(
        x = list(
          list(a = "a"),
          list(a = 1L)
        )
      )
    ),
    tspec_object(x = tib_df("x", a = tib_variant("a")))
  )
})

test_that("guess_tspec_object respects empty_list_unspecified for list of object elements (#83)", {
  x <- list(
    x = list(
      list(a = 1L, b = 1:2),
      list(a = list(), b = list())
    )
  )

  expect_equal(
    guess_tspec_object(x, empty_list_unspecified = FALSE),
    tspec_object(
      x = tib_df(
        "x",
        a = tib_variant("a"),
        b = tib_variant("b")
      )
    )
  )

  expect_equal(
    guess_tspec_object(x, empty_list_unspecified = TRUE),
    tspec_object(
      .vector_allows_empty_list = TRUE,
      x = tib_df(
        "x",
        a = tib_int_vec("a"),
        b = tib_int_vec("b")
      )
    )
  )
})

test_that("guess_tspec_object can guess required for tib_df", {
  expect_equal(
    guess_tspec_object(
      list(
        x = list(
          list(a = 1L, b = "a"),
          list(a = 2L)
        )
      )
    ),
    tspec_object(
      x = tib_df(
        "x",
        a = tib_int("a"),
        b = tib_chr("b", .required = FALSE)
      )
    )
  )
})

test_that("order of fields for tib_df does not matter", {
  expect_equal(
    guess_tspec_object(
      list(
        x = list(
          list(a = 1L, b = "a"),
          list(c = 1:3, b = "c", a = 2L)
        )
      )
    ),
    tspec_object(
      x = tib_df(
        "x",
        a = tib_int("a"),
        b = tib_chr("b"),
        c = tib_int_vec("c", .required = FALSE)
      )
    )
  )
})

test_that("guess_tspec_object can guess tib_unspecified for an object (#83)", {
  withr::local_options(tibblify.show_unspecified = FALSE)
  # `NULL` is the missing element in lists
  expect_equal(
    guess_tspec_object(list(x = NULL)),
    tspec_object(x = tib_unspecified("x"))
  )

  # empty lists could be object or list of object -> unspecified
  expect_equal(
    guess_tspec_object(list(x = list()), empty_list_unspecified = FALSE),
    tspec_object(x = tib_unspecified("x"))
  )

  # NA could be any scalar value
  expect_equal(
    guess_tspec_object(list(x = NA)),
    tspec_object(x = tib_unspecified("x"))
  )

  # TODO not yet decided
  # expect_equal(
  #   guess_tspec_object(list(x = list(NULL, NULL))),
  #   tspec_object(x = tib_unspecified("x"))
  # )

  # in a row
  expect_equal(
    guess_tspec_object(list(x = list(a = NULL))),
    tspec_object(x = tib_unspecified("x"))
  )

  # TODO undecided
  # expect_equal(
  #   guess_tspec_object(list(x = list(a = list()))),
  #   tspec_object(x = tib_row("x", tib_unspecified("a")))
  # )

  # TODO undecided
  # expect_equal(
  #   guess_tspec_object(list(x = list(a = list())), empty_list_unspecified = FALSE),
  #   tspec_object(x = tib_row("x", tib_unspecified("a")))
  # )

  # in a df
  expect_equal(
    guess_tspec_object(
      list(
        x = list(
          list(a = NULL),
          list(a = NULL)
        )
      )
    ),
    tspec_object(x = tib_df("x", a = tib_unspecified("a")))
  )
})

test_that("guess_tspec_object informs about unspecified elements", {
  local_mocked_bindings(
    format.tspec_object = function(...) "object omitted"
  )
  x <- read_sample_json("citm_catalog.json")
  guess_tspec_object(x, inform_unspecified = TRUE) |>
    expect_snapshot()
})

test_that("guess_tspec_object returns an empty spec for an empty list", {
  expect_equal(
    guess_tspec_object(list()),
    tspec_object()
  )
})

test_that("guess_vector_input_form can guess input form for a list of NULLs", {
  # This path is likely unreachable, but this way it still works if this helper
  # is used in another context.
  expect_equal(
    guess_vector_input_form(list(a = NULL, b = NULL), name = NULL),
    list(can_simplify = FALSE)
  )
  expect_equal(
    guess_vector_input_form(list(NULL, NULL), name = "c"),
    list(
      can_simplify = TRUE,
      tib_spec = tib_unspecified("c", .required = TRUE)
    )
  )
})

# specific cases ----

test_that("guess_tspec_object can guess spec for citm_catalog", {
  withr::local_options(tibblify.show_unspecified = FALSE)
  x <- read_sample_json("citm_catalog.json")
  x$areaNames <- x$areaNames[1:3]
  x$events <- x$events[1:3]
  x$performances <- x$performances[1:3]
  x$seatCategoryNames <- x$seatCategoryNames[1:3]
  x$subTopicNames <- x$subTopicNames[1:3]
  guess_tspec_object(x, simplify_list = FALSE) |>
    expect_snapshot()
})

test_that("guess_tspec_object can guess spec for twitter", {
  withr::local_options(tibblify.show_unspecified = FALSE)
  read_sample_json("twitter.json") |>
    guess_tspec_object() |>
    expect_snapshot()
})

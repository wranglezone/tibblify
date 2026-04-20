test_that("respect empty_list_unspecified for object elements (#95)", {
  x <- list(list(x = list(y = 1:2)), list(x = list(y = list())))
  expect_equal(
    guess_tspec_object_list(x, empty_list_unspecified = FALSE),
    tspec_df(x = tib_row("x", y = tib_variant("y")))
  )

  expect_equal(
    guess_tspec_object_list(x, empty_list_unspecified = TRUE),
    tspec_df(
      .vector_allows_empty_list = TRUE,
      x = tib_row("x", y = tib_int_vec("y"))
    )
  )
})

test_that("can guess tib_df", {
  expect_equal(
    guess_tspec_object_list(
      list(
        list(
          x = list(
            list(a = 1L),
            list(a = 2L)
          )
        ),
        list(
          x = list(
            list(a = 1.5)
          )
        )
      )
    ),
    tspec_df(x = tib_df("x", a = tib_dbl("a")))
  )
})

test_that("can guess tib_unspecified", {
  withr::local_options(tibblify.show_unspecified = FALSE)
  expect_equal(
    guess_tspec_object_list(list(list(x = NULL), list(x = NULL))),
    tspec_df(x = tib_unspecified("x"))
  )
  expect_equal(
    guess_tspec_object_list(
      list(
        list(x = list(NULL, NULL)),
        list(x = list(NULL))
      )
    ),
    tspec_df(x = tib_unspecified("x"))
  )

  # in a row
  # TODO
  # expect_equal(
  #   guess_tspec_object_list(list(list(x = list(a = NULL)), list(x = list(a = NULL)))),
  #   tspec_df(x = tib_row("x", a = tib_unspecified("a")))
  # )

  # in a df
  expect_equal(
    guess_tspec_object_list(
      list(
        list(
          x = list(
            list(a = NULL),
            list(a = NULL)
          )
        ),
        list(
          x = list(
            list(a = NULL),
            list(a = NULL)
          )
        )
      )
    ),
    tspec_df(x = tib_df("x", a = tib_unspecified("a")))
  )
})

test_that("order of fields does not matter", {
  expect_equal(
    guess_tspec_object_list(list(
      list(x = TRUE, y = 1:3),
      list(z = "a", y = 2L, x = FALSE)
    )),
    tspec_df(
      x = tib_lgl("x"),
      y = tib_int_vec("y"),
      z = tib_chr("z", .required = FALSE)
    )
  )

  expect_equal(
    guess_tspec_object_list(
      list(
        list(x = list(a = 1L, b = "a")),
        list(x = list(b = "b", a = 2L))
      )
    ),
    tspec_df(x = tib_row("x", a = tib_int("a"), b = tib_chr("b")))
  )
})

test_that("can guess object_list of length one (#50)", {
  expect_equal(
    guess_tspec_object_list(list(list(x = 1, y = 2))),
    tspec_df(
      x = tib_dbl("x"),
      y = tib_dbl("y"),
    )
  )
})

test_that("guess_tspec_object_list errors informatively for list of tibbles of dfs", {
  expect_error(
    {
      guess_tspec_object_list(
        list(
          a = tibble::tibble(
            b = data.frame(w = 1:3),
            c = data.frame(w = 4:6),
            d = data.frame(w = 7:9)
          )
        )
      )
    },
    "list of dataframes is not yet supported",
    class = "purrr_error_indexed"
  )
})

# specific cases ----

test_that("guess_tspec_object_list can guess spec for discog", {
  expect_snapshot(guess_tspec_object_list(discog))
})

test_that("guess_tspec_object_list can guess spec for gh_users", {
  expect_snapshot(guess_tspec_object_list(gh_users))
})

test_that("guess_tspec_object_list can guess spec for gsoc-2018", {
  read_sample_json("gsoc-2018.json") |>
    guess_tspec_object_list() |>
    expect_snapshot()
})

test_that("guess_tspec_list errors informatively for empty input", {
  expect_snapshot({
    (expect_error(guess_tspec_list(list())))
  })
})

test_that("guess_tspec_list errors informatively for bad objects", {
  expect_snapshot({
    # not fully named
    (expect_error(guess_tspec_list(list(a = 1, 1))))
    # not unique names
    (expect_error(guess_tspec_list(list(a = 1, a = 1))))
  })
})

test_that("guess_tspec_list dispatches appropriately", {
  local_mocked_bindings(
    guess_tspec_object_list = function(x, ...) {
      cli::cli_inform("object_list", class = "object_list")
    },
    guess_tspec_object = function(x, ...) {
      cli::cli_inform("object", class = "object")
    }
  )
  # guess_tpsec_object()
  read_sample_json("citm_catalog.json") |>
    guess_tspec_list() |>
    expect_message(class = "object")
  read_sample_json("twitter.json") |>
    guess_tspec_list() |>
    expect_message(class = "object")

  # guess_tspec_object_list()
  guess_tspec_list(discog) |>
    expect_message(class = "object_list")
  guess_tspec_list(gh_users) |>
    expect_message(class = "object_list")
  read_sample_json("gsoc-2018.json") |>
    guess_tspec_list() |>
    expect_message(class = "object_list")
})

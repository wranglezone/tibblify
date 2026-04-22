# `guess_tspec()` is really just a dispatcher. Keep tests simple.

test_that("guess_tspec errors informatively when x is neither df nor list", {
  expect_snapshot({
    expect_error(guess_tspec("a"))
  })
})

test_that("guess_tspec dispatches correctly for object lists", {
  local_mocked_bindings(
    guess_tspec_list = function(x, ...) {
      expect_type(x, "list")
      cli::cli_inform("list", class = "list-called")
    }
  )
  expect_message(guess_tspec(discog), class = "list-called")
  expect_message(guess_tspec(gh_users), class = "list-called")
  expect_message(guess_tspec(got_chars), class = "list-called")
})

test_that("guess_tspec dispatches correctly for objects", {
  local_mocked_bindings(
    guess_tspec_list = function(x, ...) {
      expect_type(x, "list")
      cli::cli_inform("list", class = "list-called")
    }
  )
  x <- read_sample_json("citm_catalog.json")
  expect_message(guess_tspec(x), class = "list-called")
  x <- read_sample_json("twitter.json")
  expect_message(guess_tspec(x), class = "list-called")
})

test_that("guess_tspec dispatches correctly for dfs", {
  local_mocked_bindings(
    guess_tspec_df = function(x, ...) {
      expect_type(x, "list")
      expect_s3_class(x, "data.frame")
      cli::cli_inform("df", class = "df-called")
    }
  )
  x <- data.frame(a = 1:3, b = 2:4)
  expect_message(guess_tspec(x), class = "df-called")

  x <- tibble::tibble(a = 1:3, b = 2:4)
  expect_message(guess_tspec(x), class = "df-called")
})

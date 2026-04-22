test_that(".is_object() works", {
  # must be a list
  expect_false(.is_object(structure(list(x = 1), class = "dummy")))

  # must be fully named
  expect_false(.is_object(list(1)))
  expect_false(.is_object(list(x = 1, 1)))

  # names must not be NA
  expect_false(.is_object(purrr::set_names(list(1, 1), c(NA, "x"))))

  # must not have duplicate names
  expect_false(.is_object(list(x = 1, x = 1)))

  # valid objects
  expect_true(.is_object(list()))
  expect_true(.is_object(list(x = 1)))
  expect_true(.is_object(list(x = 1, y = "a")))

  listy_list <- list()
  class(listy_list) <- "list"
  expect_true(.is_object(listy_list))
})

test_that(".is_object_list() works", {
  # must be a list
  expect_false(.is_object_list(structure(list(x = 1), class = "dummy")))

  # must be a list of objects
  dummy <- structure(list(x = 1), class = "dummy")
  expect_false(.is_object_list(list(dummy)))
  expect_false(.is_object_list(list(x = 1)))

  # valid object lists
  expect_true(.is_object_list(list()))
  expect_true(.is_object_list(mtcars))
  expect_true(.is_object_list(tibble::tibble()))

  expect_true(.is_object_list(list(list(x = 1), list(x = 2))))
  expect_true(.is_object_list(list(list(x = 1), list(x = "a"))))

  # can handle NULL
  expect_true(.is_object_list(list(list(x = 1), NULL)))
})

test_that(".check_object_list() checks that x is a list of objects", {
  expect_error(
    .check_object_list(structure(list(x = 1), class = "dummy")),
    "must be a list of objects",
    class = "tibblify-error-not_object_list"
  )
  expect_error(
    .check_object_list(list(structure(list(x = 1), class = "dummy"))),
    "must be a list of objects",
    class = "tibblify-error-not_object_list"
  )
  expect_error(
    .check_object_list(list(x = 1)),
    "must be a list of objects",
    class = "tibblify-error-not_object_list"
  )
  expect_equal(
    .check_object_list(list(list(x = 1), NULL)),
    list(list(x = 1), NULL)
  )
})

test_that("detect lists of length 1 (#50)", {
  expect_true(.is_object_list(list(list(x = 1, y = 2))))
})

test_that(".is_list_of_object_lists works", {
  expect_true(.is_list_of_object_lists(list(
    list(list(x = 1, y = 2)),
    list(list(x = 1, y = 2))
  )))
  expect_false(.is_list_of_object_lists(list(
    list(list(x = 1, y = 2)),
    list(x = 1, y = 2)
  )))
  expect_true(.is_list_of_object_lists(list(
    list(list(x = 1, y = 2)),
    NULL
  )))
})

test_that(".is_list_of_null() works", {
  expect_true(.is_list_of_null(list()))
  expect_true(.is_list_of_null(list(NULL)))
  expect_true(.is_list_of_null(list(NULL, NULL)))

  expect_false(.is_list_of_null(list(NULL, 1)))

  expect_error(.is_list_of_null("not a list"), "is not a list")
})

test_that(".list_is_list_of_null() works", {
  expect_true(.list_is_list_of_null(list()))
  expect_true(.list_is_list_of_null(list(NULL)))
  expect_true(.list_is_list_of_null(list(NULL, list())))
  expect_true(.list_is_list_of_null(list(list(NULL))))

  expect_false(.list_is_list_of_null(list(list(NULL, 1))))

  expect_error(.list_is_list_of_null("not a list"), "is not a list")
})

test_that(".lgl_to_bullet converts lgl vectors to bullets", {
  expect_equal(
    .lgl_to_bullet(c(TRUE, FALSE, FALSE, TRUE)),
    c("v", "x", "x", "v")
  )
})

test_that(".abort_not_tibblifiable throws informative errors", {
  stbl::expect_pkg_error_snapshot(
    .abort_not_tibblifiable(letters),
    package = "tibblify",
    "untibblifiable_object"
  )
  stbl::expect_pkg_error_snapshot(
    .abort_not_tibblifiable(list(1, 2, 3)),
    package = "tibblify",
    "untibblifiable_object"
  )
  stbl::expect_pkg_error_snapshot(
    .abort_not_tibblifiable(list(a = 1, a = 2)),
    package = "tibblify",
    "untibblifiable_object"
  )
  stbl::expect_pkg_error_snapshot(
    .abort_not_tibblifiable(list(list(a = 1), letters)),
    package = "tibblify",
    "untibblifiable_object"
  )
})

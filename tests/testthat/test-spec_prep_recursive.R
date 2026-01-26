test_that("recursive: works", {
  spec <- tspec_recursive(
    tib_int("id"),
    tib_chr("name"),
    .children = "children"
  )
  spec2 <- tspec_object(
    tib_recursive(
      "data",
      tib_int("id"),
      tib_chr("name"),
      .children = "children"
    )
  )

  expected <- tibble(id = 1L, name = "a", children = list(NULL))
  expect_equal(
    tibblify(list(list(id = 1, name = "a")), spec),
    expected
  )

  expect_equal(
    tibblify(list(data = list(list(id = 1, name = "a"))), spec2),
    structure(list(data = expected), class = "tibblify_object")
  )

  expect_equal(
    tibblify(list(list(id = 1, name = "a", children = NULL)), spec),
    tibble(id = 1L, name = "a", children = list(NULL))
  )

  # TODO not quite sure
  expect_equal(
    tibblify(list(list(id = 1, name = "a", children = list())), spec),
    tibble(
      id = 1L,
      name = "a",
      children = list(tibble(
        id = integer(),
        name = character(),
        children = list()
      ))
    )
  )

  # deeply nested works
  x <- list(
    list(
      id = 1,
      name = "a",
      children = list(
        list(id = 11, name = "aa"),
        list(
          id = 12,
          name = "ab",
          children = list(
            list(id = 121, name = "aba")
          )
        )
      )
    ),
    list(
      id = 2,
      name = "b",
      children = list(
        list(
          id = 21,
          name = "ba",
          children = list(
            list(
              id = 121,
              name = "bba",
              children = list(
                list(id = 1211, name = "bbaa")
              )
            )
          )
        ),
        list(id = 22, name = "bb")
      )
    )
  )

  expected <- tibble(
    id = 1:2,
    name = c("a", "b"),
    children = list(
      tibble(
        id = 11:12,
        name = c("aa", "ab"),
        children = list(
          NULL,
          tibble(id = 121, name = "aba", children = list(NULL))
        )
      ),
      tibble(
        id = 21:22,
        name = c("ba", "bb"),
        children = list(
          tibble(
            id = 121,
            name = "bba",
            children = list(
              tibble(id = 1211, name = "bbaa", children = list(NULL))
            )
          ),
          NULL
        )
      )
    )
  )

  expect_equal(tibblify(x, spec), expected)
  expect_equal(
    tibblify(list(data = x), spec2),
    structure(list(data = expected), class = "tibblify_object")
  )

  # tibble input
  expect_equal(tibblify(expected, spec), expected)
  # colmajor
  spec_colmajor <- tspec_recursive(
    tib_int("id"),
    tib_chr("name"),
    .children = "children",
    .input_form = "colmajor"
  )

  x_cm <- list(
    id = 1:2,
    name = c("a", "b"),
    children = list(
      list(
        id = 11:12,
        name = c("aa", "ab"),
        children = list(
          NULL,
          list(id = 121, name = "aba", children = list(NULL))
        )
      ),
      list(
        id = 21:22,
        name = c("ba", "bb"),
        children = list(
          list(
            id = 121,
            name = "bba",
            children = list(
              list(id = 1211, name = "bbaa", children = list(NULL))
            )
          ),
          NULL
        )
      )
    )
  )
  expect_equal(tibblify(x_cm, spec_colmajor), expected)

  x2 <- x
  x2[[1]]$children[[2]]$children[[1]]$id <- "does not work"
  expect_snapshot(
    (expect_error(tibblify(x2, spec)))
  )
})

test_that("recursive: empty input works", {
  spec <- tspec_recursive(
    tib_int("id"),
    tib_chr("name"),
    .children = "children"
  )

  expect_equal(
    tibblify(list(), spec),
    tibble(id = integer(), name = character(), children = list())
  )
})

test_that("recursive: empty spec works", {
  expect_equal(
    tibblify(list(), tspec_recursive(.children = "children")),
    tibble(children = list())
  )
})

test_that("recursive: .children_to works", {
  expect_equal(
    tibblify(
      list(),
      tspec_recursive(.children = "children", .children_to = "child_col")
    ),
    tibble(child_col = list())
  )
})

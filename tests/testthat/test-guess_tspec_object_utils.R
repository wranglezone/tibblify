# .guess_object_list_field_spec() ------------------------------------------

test_that("can guess scalar elements", {
  expect_equal(
    guess_ol_field(list(TRUE, FALSE)),
    tib_lgl("x")
  )

  expect_equal(
    guess_ol_field(list(vctrs::new_datetime(1), vctrs::new_datetime(2))),
    tib_scalar("x", vctrs::new_datetime())
  )

  # also for record types
  x_rat <- new_rational(1, 2)
  expect_equal(
    guess_ol_field(list(x = x_rat, x_rat)),
    tib_scalar("x", x_rat)
  )
})

test_that("can guess scalar elements with NULL", {
  expect_equal(
    guess_ol_field(list(1L, NULL)),
    tib_int("x")
  )
})

test_that("POSIXlt is converted to POSIXct", {
  x_posixlt <- as.POSIXlt(vctrs::new_date(0))
  expect_equal(
    guess_ol_field(list(x_posixlt, x_posixlt)),
    tib_scalar("x", vctrs::new_datetime(tzone = "UTC"))
  )
})

test_that("respect empty_list_unspecified for scalar elements (#83, #95)", {
  x <- list(x = 1L, list())
  expect_equal(
    guess_ol_field(x, empty_list_unspecified = FALSE),
    tib_variant("x")
  )

  # this should be `tib_vector` because a list cannot occur for a scalar
  x <- list(list(x = 1L), list(x = list()))
  expect_equal(
    guess_tspec_object_list(x, empty_list_unspecified = TRUE),
    tspec_df(
      .vector_allows_empty_list = TRUE,
      tib_int_vec("x")
    )
  )
})

test_that("can guess vector elements", {
  expect_equal(
    guess_ol_field(list(c(TRUE, FALSE), FALSE)),
    tib_lgl_vec("x")
  )

  expect_equal(
    guess_ol_field(
      list(
        vctrs::new_datetime(1),
        c(vctrs::new_datetime(2), vctrs::new_datetime(3))
      )
    ),
    tib_vector("x", vctrs::new_datetime())
  )

  expect_equal(
    guess_ol_field(list(x = 1L, integer())),
    tib_int_vec("x")
  )
})

test_that("respect empty_list_unspecified for vector elements (#95)", {
  expect_equal(
    guess_ol_field(list(x = 1:2, list()), empty_list_unspecified = FALSE),
    tib_variant("x")
  )

  x <- list(list(x = 1:2), list(x = list()))
  expect_equal(
    guess_tspec_object_list(x, empty_list_unspecified = TRUE),
    tspec_df(
      .vector_allows_empty_list = TRUE,
      x = tib_int_vec("x")
    )
  )
})

test_that("can guess vector input form (#94)", {
  expect_equal(
    guess_ol_field(
      list(list(1, 2), list()),
      simplify_list = TRUE,
      empty_list_unspecified = FALSE
    ),
    tib_dbl_vec("x", .input_form = "scalar_list")
  )

  # checks size
  expect_equal(
    guess_ol_field(
      list(list(1, 1:2)),
      simplify_list = TRUE,
      empty_list_unspecified = FALSE
    ),
    tib_variant("x")
  )

  expect_equal(
    guess_ol_field(
      list(list(1, integer())),
      simplify_list = TRUE,
      empty_list_unspecified = FALSE
    ),
    tib_variant("x")
  )
})

test_that("can guess object input form", {
  x <- list(
    list(x = list(a = 1, b = 2)),
    list(x = list(c = 1, d = 1, e = 1, f = 1)),
    list(x = list(g = 1, h = 1, i = 1, j = 1))
  )
  expect_equal(
    guess_tspec_object_list(
      x,
      simplify_list = TRUE,
      empty_list_unspecified = FALSE
    ),
    tspec_df(x = tib_dbl_vec("x", .input_form = "object"))
  )
})

test_that("can guess tib_variant", {
  expect_equal(
    guess_ol_field(list(list(TRUE, "a"), list(FALSE, "b"))),
    tib_variant("x")
  )

  expect_equal(
    guess_ol_field(list("a", 1)),
    tib_variant("x")
  )
})

test_that("can handle non-vector elements (#76, #84)", {
  model <- lm(Sepal.Length ~ Sepal.Width, data = iris)
  expect_equal(
    guess_ol_field(list(model, 1L)),
    tib_variant("x")
  )
})

test_that("can guess object elements", {
  expect_equal(
    guess_ol_field(list(list(a = 1L, b = "a"), list(a = 2L, b = "b"))),
    tib_row("x", a = tib_int("a"), b = tib_chr("b"))
  )

  expect_equal(
    guess_ol_field(list(list(a = 1L), list(a = 2:3))),
    tib_row("x", a = tib_int_vec("a"))
  )

  expect_equal(
    guess_ol_field(list(list(a = 1L), list(a = "a"))),
    tib_row("x", a = tib_variant("a"))
  )
})

test_that(".guess_object_list_field_spec returns tib_variant for no common ptype", {
  # Incompatible types
  expect_equal(
    .guess_object_list_field_spec(list(TRUE, "a"), "x", FALSE, FALSE),
    tib_variant("x")
  )
  # Non-vector elements (functions trigger scalar type error)
  expect_equal(
    .guess_object_list_field_spec(list(mean, sum), "x", FALSE, FALSE),
    tib_variant("x")
  )
})

test_that(".guess_object_list_field_spec returns tib_unspecified when ptype is NULL", {
  expect_equal(
    .guess_object_list_field_spec(list(NULL, NULL), "x", FALSE, FALSE),
    tib_unspecified("x")
  )
})

test_that(".guess_object_list_field_spec returns tib_scalar/tib_vector for vector ptype", {
  # Scalar (one element per row)
  expect_equal(
    .guess_object_list_field_spec(list(1L, 2L), "x", FALSE, FALSE),
    tib_int("x")
  )
  # Vector (multiple elements per row)
  expect_equal(
    .guess_object_list_field_spec(list(1:2, 3:4), "x", FALSE, FALSE),
    tib_int_vec("x")
  )
})

test_that(".guess_object_list_field_spec errors for a list of dataframes", {
  expect_error(
    .guess_object_list_field_spec(
      list(data.frame(a = 1L), data.frame(a = 2L)),
      "x",
      FALSE,
      FALSE
    ),
    "A list of dataframes is not yet supported"
  )
})

test_that(".guess_object_list_field_spec returns tib_unspecified for all-empty or all-null lists", {
  # All empty lists
  expect_equal(
    .guess_object_list_field_spec(list(list(), list()), "x", FALSE, FALSE),
    tib_unspecified("x")
  )
  # Each element is a list containing only NULLs
  expect_equal(
    .guess_object_list_field_spec(
      list(list(NULL), list(NULL)),
      "x",
      FALSE,
      FALSE
    ),
    tib_unspecified("x")
  )
})

test_that(".guess_object_list_field_spec returns tib_df for a list of object lists", {
  # Unnamed value_flat -> no .names_to
  expect_equal(
    .guess_object_list_field_spec(
      list(list(list(a = 1L), list(a = 2L))),
      "x",
      FALSE,
      FALSE
    ),
    tib_df("x", tib_int("a"))
  )
  # Named value_flat -> .names_to = ".names"
  expect_equal(
    .guess_object_list_field_spec(
      list(list(p = list(a = 1L), q = list(a = 2L))),
      "x",
      FALSE,
      FALSE
    ),
    tib_df("x", tib_int("a"), .names_to = ".names")
  )
})

test_that(".guess_object_list_field_spec returns tib_row when !simplify_list and object", {
  expect_equal(
    .guess_object_list_field_spec(
      list(list(a = 1L, b = "x"), list(a = 2L, b = "y")),
      "x",
      FALSE,
      FALSE
    ),
    tib_row("x", tib_int("a"), tib_chr("b"))
  )
})

test_that(".guess_object_list_field_spec returns tib_variant when !simplify_list and !object", {
  # Unnamed (non-object) lists
  expect_equal(
    .guess_object_list_field_spec(
      list(list(1L, 2L), list(3L, 4L)),
      "x",
      FALSE,
      FALSE
    ),
    tib_variant("x")
  )
})

test_that(".guess_object_list_field_spec simplifies to tib_vector with input_form = 'object'", {
  # Named elements in value_flat -> input_form = "object"
  expect_equal(
    .guess_object_list_field_spec(
      list(list(p = 1L, q = 2L), list(p = 3L, q = 4L)),
      "x",
      FALSE,
      TRUE
    ),
    tib_int_vec("x", .input_form = "object")
  )
})

test_that(".guess_object_list_field_spec simplifies to tib_vector with input_form = 'scalar_list'", {
  # Unnamed single-element lists -> input_form = "scalar_list"
  expect_equal(
    .guess_object_list_field_spec(list(list(1L), list(2L)), "x", FALSE, TRUE),
    tib_int_vec("x", .input_form = "scalar_list")
  )
})

test_that(".guess_object_list_field_spec returns tib_row when simplify_list but not vectorisable", {
  # Mixed-type named elements can't be combined -> falls back to tib_row
  expect_equal(
    .guess_object_list_field_spec(
      list(list(a = 1L, b = "x"), list(a = 2L, b = "y")),
      "x",
      FALSE,
      TRUE
    ),
    tib_row("x", tib_int("a"), tib_chr("b"))
  )
})

test_that(".guess_object_list_field_spec returns tib_variant when simplify_list and !object and not vectorisable", {
  # Unnamed lists with non-scalar sizes
  expect_equal(
    .guess_object_list_field_spec(
      list(list(1L, 1:2), list(3L)),
      "x",
      FALSE,
      TRUE
    ),
    tib_variant("x")
  )
})

test_that(".guess_object_list_field_spec respects empty_list_unspecified for vector ptype", {
  # empty_list_unspecified = TRUE: empty lists are dropped, had_empty_lists is set
  local_env <- rlang::new_environment(list(empty_list_used = FALSE))
  result <- .guess_object_list_field_spec(
    list(list(), 1L, 2L),
    "x",
    TRUE,
    FALSE,
    local_env
  )
  expect_equal(result, tib_int_vec("x"))
  expect_true(.read_empty_list_argument(local_env))
})

# .get_required() ----------------------------------------------------------

test_that(".get_required subsamples when x is larger than sample_size", {
  x <- list(
    list(a = 1, b = 2),
    list(a = 3, b = 4),
    list(a = 5, b = 6)
  )
  result <- .get_required(x, sample_size = 2)
  expect_named(result, c("a", "b"), ignore.order = TRUE)
  expect_type(result, "logical")
})

test_that(".get_required returns all FALSE when any record is empty", {
  x <- list(
    list(a = 1, b = 2),
    list()
  )
  result <- .get_required(x)
  expect_equal(result, c(a = FALSE, b = FALSE))
})

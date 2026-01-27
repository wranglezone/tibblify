test_that("tibblify spec argument is checked", {
  expect_snapshot({
    (expect_error(tibblify(list(), "x")))
    (expect_error(tibblify(list(), tib_int("x"))))
  })
})

test_that("tibblify guesses spec by default", {
  expect_equal(
    tibblify(
      list(
        list(a = 1L),
        list(a = 2L)
      )
    ),
    tibble(a = 1:2)
  )
})

test_that("tibblify checks object names", {
  spec <- tspec_object(x = tib_int("x", .required = FALSE))

  expect_snapshot({
    # no names
    (expect_error(tibblify(list(1, 2), spec)))

    # partial names
    (expect_error(tibblify(list(x = 1, 2), spec)))
    (expect_error(tibblify(list(1, x = 2), spec)))
    (expect_error(tibblify(list(z = 1, y = 2, 3, a = 4), spec)))

    # `NA` name
    (expect_error(tibblify(set_names(list(1, 2), c("x", NA)), spec)))

    # duplicate name
    (expect_error(tibblify(list(x = 1, x = 2), spec)))
  })

  spec2 <- tspec_object(
    tib_row("row", tib_int("x"), .required = FALSE)
  )

  expect_snapshot({
    # no names
    (expect_error(tibblify(list(row = list(1, 2)), spec2)))

    # partial names
    (expect_error(tibblify(list(row = list(x = 1, 2)), spec2)))
    (expect_error(tibblify(list(row = list(1, x = 2)), spec2)))
    (expect_error(tibblify(list(row = list(z = 1, y = 2, 3, a = 4)), spec2)))

    # `NA` name
    (expect_error(tibblify(
      list(row = set_names(list(1, 2), c("x", NA))),
      spec2
    )))

    # duplicate name
    (expect_error(tibblify(list(row = list(x = 1, x = 2)), spec2)))
  })
})

test_that("tibblify errors if required fields are absent", {
  dtt <- vctrs::new_datetime(1)
  expect_snapshot({
    (expect_error(tib(list(a = 1), tib_lgl("x"))))
    (expect_error(tib(list(a = 1), tib_scalar("x", dtt))))
  })
  expect_snapshot({
    (expect_error(tib(list(a = 1), tib_lgl_vec("x"))))
    (expect_error(tib(list(a = 1), tib_vector("x", dtt))))
  })
})

test_that("tibblify errors if type is bad", {
  dtt <- vctrs::new_datetime(1)
  expect_snapshot((expect_error(tib(list(x = "a"), tib_lgl_vec("x")))))
  expect_snapshot({
    (expect_error(tib(list(x = "a"), tib_lgl("x"))))
    (expect_error(tib(list(x = 1), tib_scalar("x", dtt))))
  })
})

test_that("tibblify errors if size is bad", {
  dtt <- vctrs::new_datetime(1)
  expect_snapshot({
    (expect_error(tib(list(x = c(TRUE, TRUE)), tib_lgl("x"))))
    # empty element
    (expect_error(tib(list(x = logical()), tib_lgl("x"))))
    (expect_error(tib(list(x = c(dtt, dtt)), tib_scalar("x", dtt))))
  })
})

test_that("can tibblify empty objects (#204)", {
  spec <- tspec_df(tib_chr("id"))
  expect_equal(
    tibblify(list(), spec),
    tibble(id = character())
  )
  expect_equal(
    tibblify(data.frame(), spec),
    tibble(id = character())
  )
  expect_equal(
    tibblify(tibble(), spec),
    tibble(id = character())
  )
})

test_that("can tibblify discog", {
  row1 <- tibble(
    instance_id = 354823933L,
    date_added = "2019-02-16T17:48:59-08:00",
    basic_information = tibble(
      labels = vctrs::list_of(
        tibble(
          name = "Tobi Records (2)",
          entity_type = "1",
          catno = "TOB-013",
          resource_url = "https://api.discogs.com/labels/633407",
          id = 633407L,
          entity_type_name = "Label"
        )
      ),
      year = 2015L,
      master_url = NA_character_,
      artists = vctrs::list_of(
        tibble(
          join = "",
          name = "Mollot",
          anv = "",
          tracks = "",
          role = "",
          resource_url = "https://api.discogs.com/artists/4619796",
          id = 4619796L
        )
      ),
      id = 7496378L,
      thumb = "https://img.discogs.com/vEVegHrMNTsP6xG_K6OuFXz4h_U=/fit-in/150x150/filters:strip_icc():format(jpeg):mode_rgb():quality(40)/discogs-images/R-7496378-1442692247-1195.jpeg.jpg",
      title = "Demo",
      formats = vctrs::list_of(
        tibble(
          descriptions = vctrs::list_of("Numbered"),
          text = "Black",
          name = "Cassette",
          qty = "1"
        )
      ),
      cover_image = "https://img.discogs.com/EmbMh7vsElksjRgoXLFSuY1sjRQ=/fit-in/500x499/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-7496378-1442692247-1195.jpeg.jpg",
      resource_url = "https://api.discogs.com/releases/7496378",
      master_id = 0L
    ),
    id = 7496378L,
    rating = 0L
  )

  spec_collection <- tspec_df(
    tib_int("instance_id"),
    tib_chr("date_added"),
    tib_row(
      "basic_information",
      tib_df(
        "labels",
        tib_chr("name"),
        tib_chr("entity_type"),
        tib_chr("catno"),
        tib_chr("resource_url"),
        tib_int("id"),
        tib_chr("entity_type_name"),
      ),
      tib_int("year"),
      tib_chr("master_url"),
      tib_df(
        "artists",
        tib_chr("join"),
        tib_chr("name"),
        tib_chr("anv"),
        tib_chr("tracks"),
        tib_chr("role"),
        tib_chr("resource_url"),
        tib_int("id"),
      ),
      tib_int("id"),
      tib_chr("thumb"),
      tib_chr("title"),
      tib_df(
        "formats",
        tib_chr_vec(
          "descriptions",
          .required = FALSE,
          .input_form = "scalar_list",
        ),
        tib_chr("text", .required = FALSE),
        tib_chr("name"),
        tib_chr("qty"),
      ),
      tib_chr("cover_image"),
      tib_chr("resource_url"),
      tib_int("master_id"),
    ),
    tib_int("id"),
    tib_int("rating"),
  )

  expect_equal(tibblify(discog[1], spec_collection), row1)
  spec_collection2 <- spec_collection
  spec_collection2$fields$basic_information$fields$formats$fields$descriptions <-
    tib_chr_vec("descriptions", .required = FALSE)
  expect_equal(tibblify(row1, spec_collection2), row1)

  specs_object <- tspec_row(!!!spec_collection$fields)
  expect_equal(tibblify(discog[[1]], specs_object), row1)
  expect_equal(tibblify(row1, specs_object), row1)
})

test_that("get_spec works", {
  df <- tibblify(list(list(x = 1, y = "a"), list(x = 2)))
  expect_equal(get_spec(df), attr(df, "tib_spec"))
})

test_that("Can tibblify with tspec_object", {
  x <- list(id = 1, name = "Tyrion Lannister")
  spec <- tspec_object(
    id = tib_int("id"),
    name = tib_chr("name")
  )
  test_result <- tibblify(x, spec)
  expect_s3_class(test_result, "tibblify_object")
  expect_identical(attr(test_result, "tib_spec"), spec)
  expect_identical(
    unclass(test_result),
    list(id = 1L, name = "Tyrion Lannister")
  )
})

# tib_*() specific tests

test_that("tib_scalar tibblifies", {
  dtt <- vctrs::new_datetime(1)

  # can parse
  expect_equal(tib(list(x = TRUE), tib_lgl("x")), tibble(x = TRUE))
  expect_equal(tib(list(x = dtt), tib_scalar("x", dtt)), tibble(x = dtt))

  # fallback default works
  expect_equal(tib(list(), tib_lgl("x", .required = FALSE)), tibble(x = NA))
  expect_equal(
    tib(list(), tib_int("x", .required = FALSE)),
    tibble(x = NA_integer_)
  )
  expect_equal(
    tib(list(), tib_dbl("x", .required = FALSE)),
    tibble(x = NA_real_)
  )
  expect_equal(
    tib(list(), tib_chr("x", .required = FALSE)),
    tibble(x = NA_character_)
  )
  expect_equal(
    tib(list(), tib_scalar("x", dtt, .required = FALSE)),
    tibble(x = vctrs::new_datetime(NA_real_))
  )

  # use NA if NULL
  expect_equal(
    tib(list(x = NULL), tib_lgl("x", .required = FALSE, .fill = FALSE)),
    tibble(x = NA)
  )
  expect_equal(
    tib(
      list(x = NULL),
      tib_scalar("x", vctrs::vec_ptype(dtt), .required = FALSE, .fill = dtt)
    ),
    tibble(x = vctrs::vec_init(dtt))
  )

  # specified default works
  expect_equal(
    tib(list(), tib_lgl("x", .required = FALSE, .fill = FALSE)),
    tibble(x = FALSE)
  )
  expect_equal(
    tib(
      list(),
      tib_scalar("x", vctrs::vec_ptype(dtt), .required = FALSE, .fill = dtt)
    ),
    tibble(x = dtt)
  )

  # transform works
  expect_equal(
    tib(list(x = TRUE), tib_lgl("x", .transform = ~ !.x)),
    tibble(x = FALSE)
  )
  expect_equal(
    tib(list(x = dtt), tib_scalar("x", dtt, .transform = ~ .x + 1)),
    tibble(x = vctrs::new_datetime(2))
  )
})

test_that("tib_scalar with record objects tibblify", {
  skip_on_cran()
  # skip due to issue:
  # `attr(actual$x, 'balanced')`:   <NA>
  # `attr(expected$x, 'balanced')`: TRUE
  x_rcrd <- as.POSIXlt(Sys.time(), tz = "UTC")

  expect_equal(
    tibblify(
      list(
        list(x = x_rcrd),
        list(x = x_rcrd + 1)
      ),
      tspec_df(
        x = tib_scalar("x", .ptype = x_rcrd)
      )
    ),
    tibble(x = c(x_rcrd, x_rcrd + 1))
  )

  now <- Sys.time()
  td1 <- now - (now - 100)
  td2 <- now - (now - 200)

  expect_equal(
    tibblify(
      list(
        list(timediff = td1),
        list(timediff = td2)
      ),
      tspec_df(
        timediff = tib_scalar("timediff", .ptype = td1)
      )
    ),
    tibble(timediff = c(td1, td2))
  )
})

test_that("tibblify: tib_scalar respect ptype_inner", {
  withr::local_timezone("UTC")
  f <- function(x) {
    stopifnot(is.character(x))
    as.Date(x)
  }
  spec <- tspec_df(
    tib_scalar(
      "x",
      Sys.Date(),
      .required = FALSE,
      .ptype_inner = character(),
      .fill = "2000-01-01",
      .transform = f,
    ),
  )

  expect_equal(
    tibblify(
      list(list(x = "2022-06-01"), list(x = "2022-06-02"), list()),
      spec
    ),
    tibble(x = as.Date(c("2022-06-01", "2022-06-02", "2000-01-01")))
  )

  spec2 <- tspec_df(
    tib_scalar(
      "x",
      Sys.Date(),
      .required = FALSE,
      .ptype_inner = Sys.time(),
      .fill = as.POSIXct("2000-01-01", tz = "UTC"),
      .transform = as.Date
    ),
  )
  x <- as.POSIXct("2022-06-02") + c(-60, 60)

  expect_equal(
    tibblify(
      list(list(x = x[[1]]), list(x = x[[2]]), list()),
      spec2
    ),
    tibble(x = as.Date(c("2022-06-01", "2022-06-02", "2000-01-01")))
  )
})

test_that("tib_vector tibblifies", {
  dtt <- vctrs::new_datetime(1)

  # can parse
  expect_equal(
    tib(list(x = c(TRUE, FALSE)), tib_lgl_vec("x")),
    tibble(x = vctrs::list_of(c(TRUE, FALSE)))
  )
  expect_equal(
    tib(list(x = c(dtt, dtt + 1)), tib_vector("x", dtt)),
    tibble(x = vctrs::list_of(c(dtt, dtt + 1)))
  )

  # fallback default works
  expect_equal(
    tib(list(), tib_lgl_vec("x", .required = FALSE)),
    tibble(x = vctrs::list_of(NULL, .ptype = logical()))
  )
  expect_equal(
    tib(list(), tib_vector("x", dtt, .required = FALSE)),
    tibble(x = vctrs::list_of(NULL, .ptype = vctrs::new_datetime()))
  )

  # specified default works
  expect_equal(
    tib(list(), tib_lgl_vec("x", .required = FALSE, .fill = c(TRUE, FALSE))),
    tibble(x = vctrs::list_of(c(TRUE, FALSE)))
  )
  expect_equal(
    tib(
      list(),
      tib_vector("x", dtt, .required = FALSE, .fill = c(dtt, dtt + 1))
    ),
    tibble(x = vctrs::list_of(c(dtt, dtt + 1)))
  )

  # uses NULL for NULL
  expect_equal(
    tib(list(x = NULL), tib_int_vec("x", .fill = 1:2)),
    tibble(x = vctrs::list_of(NULL, .ptype = integer()))
  )

  # elt_transform works
  expect_equal(
    tib(list(x = c(TRUE, FALSE)), tib_lgl_vec("x", .elt_transform = ~ !.x)),
    tibble(x = vctrs::list_of(c(FALSE, TRUE)))
  )
  expect_equal(
    tib(
      list(x = c(dtt - 1, dtt)),
      tib_vector("x", dtt, .elt_transform = ~ .x + 1)
    ),
    tibble(x = vctrs::list_of(c(dtt, dtt + 1)))
  )

  # transform works
  expect_equal(
    tib(
      list(x = c(TRUE, FALSE)),
      tib_lgl_vec(
        "x",
        .transform = ~ vctrs::new_list_of(
          purrr::map(.x, `!`),
          ptype = logical()
        )
      )
    ),
    tibble(x = vctrs::list_of(c(FALSE, TRUE)))
  )

  # keeps names
  expect_equal(
    tib(list(x = c(a = 1L, b = 2L)), tib_int_vec("x")),
    tibble(x = vctrs::list_of(c(a = 1L, b = 2L), .ptype = integer()))
  )
})

test_that("tibblify: tib_vector respect ptype_inner", {
  spec <- tspec_df(
    tib_vector(
      "x",
      Sys.Date(),
      .required = FALSE,
      .ptype_inner = character(),
      .fill = as.Date("2000-01-01"),
      .elt_transform = as.Date
    ),
  )

  expect_equal(
    tibblify(
      list(
        list(x = "2022-06-01"),
        list(x = c("2022-06-02", "2022-06-03")),
        list()
      ),
      spec
    ),
    tibble(
      x = vctrs::list_of(
        as.Date("2022-06-01"),
        as.Date(c("2022-06-02", "2022-06-03")),
        as.Date("2000-01-01")
      )
    )
  )
})

test_that("explicit NULL tibblifies", {
  x <- list(
    list(x = NULL),
    list(x = 3L),
    list()
  )

  expect_equal(
    tibblify(x, tspec_df(tib_int("x", .required = FALSE))),
    tibble(x = c(NA, 3L, NA))
  )
})

test_that("tibblify: tib_vector respects .vector_allows_empty_list", {
  x <- list(
    list(x = 1),
    list(x = list()),
    list(x = 1:3)
  )

  expect_snapshot({
    (expect_error(tibblify(x, tspec_df(tib_int_vec("x")))))
  })

  expect_equal(
    tibblify(x, tspec_df(tib_int_vec("x"), .vector_allows_empty_list = TRUE)),
    tibble(x = vctrs::list_of(1, integer(), 1:3))
  )
})

test_that("tibblify: tib_vector creates tibble with values_to", {
  spec <- tib_int_vec("x", .values_to = "val")
  expect_equal(
    tib(list(x = 1:2), spec),
    tibble(x = vctrs::list_of(tibble(val = 1:2)))
  )

  # can handle NULL
  expect_equal(
    tib(list(x = NULL), spec),
    tibble(x = vctrs::list_of(NULL, .ptype = tibble(val = 1:2)))
  )

  # can handle empty vector
  expect_equal(
    tib(list(x = integer()), spec),
    tibble(x = vctrs::list_of(tibble(val = integer())))
  )

  spec2 <- tib_int_vec(
    "x",
    .required = FALSE,
    .fill = c(1:2),
    .values_to = "val"
  )
  # can use default
  expect_equal(
    tib(list(), spec2),
    tibble(x = vctrs::list_of(tibble(val = 1:2)))
  )
})

test_that("tibblify: tib_vector can parse scalar list", {
  spec <- tib_int_vec("x", .input_form = "scalar_list")
  expect_equal(
    tib(list(x = list(1, NULL, 3)), spec),
    tibble(x = vctrs::list_of(c(1L, NA, 3L)))
  )

  # handles `NULL`
  expect_equal(
    tibblify(
      list(list(x = list(1, 2)), list(x = NULL)),
      tspec_df(x = spec)
    ),
    tibble(x = vctrs::list_of(1:2, NULL))
  )

  # handles empty list
  expect_equal(
    tibblify(
      list(list(x = list(1, 2)), list(x = list())),
      tspec_df(x = spec)
    ),
    tibble(x = vctrs::list_of(1:2, integer()))
  )

  # checks that input is a list
  expect_snapshot({
    (expect_error(tib(list(x = 1), spec)))
  })

  # each element must have size 1
  expect_snapshot({
    (expect_error(tib(list(x = list(1, 1:2)), spec)))
    (expect_error(tib(list(x = list(integer())), spec)))
  })

  # each element must have size 1 also after encountering a NULL
  expect_snapshot({
    (expect_error(tib(list(x = list(NULL, 1, 1:2)), spec)))
  })

  # each element must have the correct type
  expect_snapshot({
    (expect_error(tib(list(x = list(1, "a")), spec)))
  })
})

test_that("tibblify: tib_vector can parse object", {
  spec <- tib_int_vec("x", .input_form = "object")
  expect_equal(
    tib(list(x = list(a = 1, b = NULL, c = 3)), spec),
    tibble(x = vctrs::list_of(c(1L, NA, 3L)))
  )

  expect_snapshot(
    (expect_error(tib(list(x = list(1, 2)), spec)))
  )

  # partial or duplicate names are not checked (#103)
  expect_equal(
    tib(list(x = list(a = 1, 2)), spec),
    tibble(x = vctrs::list_of(c(1L, 2L)))
  )

  expect_equal(
    tib(list(x = list(a = 1, a = 2)), spec),
    tibble(x = vctrs::list_of(c(1L, 2L)))
  )

  # must be a list
  expect_snapshot({
    (expect_error(tib(list(x = 1), spec)))
  })

  # each element must have size 1
  expect_snapshot({
    (expect_error(tib(list(x = list(a = 1, b = 1:2)), spec)))
  })
})

test_that("tibblify: tib_vector creates tibble with names_to", {
  # TODO not quite sure whether `val` should be named
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

  # can handle missing names
  expect_equal(
    tib(
      list(x = 1:2),
      tib_int_vec("x", .names_to = "name", .values_to = "val")
    ),
    tibble(x = vctrs::list_of(tibble(name = NA_character_, val = 1:2)))
  )

  spec <- tib_int_vec(
    "x",
    .input_form = "object",
    .values_to = "val",
    .names_to = "name"
  )
  expect_equal(
    tib(list(x = list(a = 1, b = NULL)), spec),
    tibble(x = vctrs::list_of(tibble(name = c("a", "b"), val = c(1L, NA))))
  )

  # # names of default value are used
  spec2 <- tib_int_vec(
    "x",
    .fill = c(x = 1L, y = 2L),
    .required = FALSE,
    .input_form = "object",
    .values_to = "val",
    .names_to = "name"
  )
  expect_equal(
    tib(list(a = 1), spec2),
    tibble(x = vctrs::list_of(tibble(name = c("x", "y"), val = c(1L, 2L))))
  )

  spec3 <- tib_int_vec("x", .values_to = "val", .names_to = "name")
  expect_equal(
    tib(list(x = c(a = 1, b = NA)), spec3),
    tibble(x = vctrs::list_of(tibble(name = c("a", "b"), val = c(1L, NA))))
  )
})

test_that("tib_variant tibblifies", {
  # can parse
  expect_equal(
    tibblify(
      list(list(x = TRUE), list(x = 1)),
      tspec_df(x = tib_variant("x"))
    ),
    tibble(x = list(TRUE, 1))
  )

  expect_equal(
    tibblify(
      list(x = TRUE),
      tspec_row(x = tib_variant("x"))
    ),
    tibble(x = list(TRUE))
  )

  # errors if required but absent
  expect_snapshot(
    (expect_error(tibblify(
      list(list(x = TRUE), list(zzz = 1)),
      tspec_df(x = tib_variant("x"))
    )))
  )

  # fallback default works
  expect_equal(
    tibblify(
      list(list(), list(x = 1)),
      tspec_df(x = tib_variant("x", .required = FALSE))
    ),
    tibble(x = list(NULL, 1))
  )

  # specified default works
  expect_equal(
    tibblify(
      list(list()),
      tspec_df(x = tib_variant("x", .required = FALSE, .fill = 1))
    ),
    tibble(x = list(1))
  )

  # can handle NULL
  expect_equal(
    tibblify(
      list(list(x = NULL)),
      tspec_df(x = tib_variant("x", .fill = 1))
    ),
    tibble(x = list(NULL))
  )

  # transform works
  expect_equal(
    tibblify(
      list(list(x = c(TRUE, FALSE)), list(x = 1)),
      tspec_df(x = tib_variant("x", .required = FALSE, .transform = lengths))
    ),
    tibble(x = c(2L, 1L))
  )

  # elt_transform works
  expect_equal(
    tibblify(
      list(list(x = c(TRUE, FALSE)), list(x = 1)),
      tspec_df(
        x = tib_variant("x", .required = FALSE, .elt_transform = ~ length(.x))
      )
    ),
    tibble(x = list(2, 1))
  )
})

test_that("tib_row tibblifies", {
  # can parse
  expect_equal(
    tibblify(
      list(
        list(x = list(a = TRUE)),
        list(x = list(a = FALSE))
      ),
      tspec_df(x = tib_row("x", a = tib_lgl("a")))
    ),
    tibble(x = tibble(a = c(TRUE, FALSE)))
  )

  # errors if required but absent
  expect_snapshot(
    (expect_error(tibblify(
      list(
        list(x = list(a = TRUE)),
        list()
      ),
      tspec_df(x = tib_row("x", a = tib_lgl("a")))
    )))
  )

  # fallback default works
  expect_equal(
    tibblify(
      list(
        list(x = list(a = 1)),
        list(x = list()),
        list()
      ),
      tspec_df(
        x = tib_row(
          "x",
          .required = FALSE,
          a = tib_int("a", .required = FALSE, .fill = -1)
        )
      )
    ),
    tibble(x = tibble(a = c(1L, -1L, -1L)))
  )

  # can handle NULL
  # TODO not quite sure about this
  expect_equal(
    tibblify(
      list(
        list(x = NULL)
      ),
      tspec_df(
        x = tib_row(
          "x",
          .required = FALSE,
          a = tib_int("a", .required = FALSE, .fill = -1)
        )
      )
    ),
    tibble(x = tibble(a = -1L))
  )
})

test_that("tib_df tibblifies", {
  # can parse
  expect_equal(
    tibblify(
      list(
        list(
          x = list(
            list(a = TRUE),
            list(a = FALSE)
          )
        )
      ),
      tspec_df(x = tib_df("x", a = tib_lgl("a")))
    ),
    tibble(x = vctrs::list_of(tibble(a = c(TRUE, FALSE))))
  )

  # errors if required but absent
  expect_snapshot({
    (expect_error(tibblify(
      list(
        list(
          x = list(
            list(a = TRUE),
            list(a = FALSE)
          )
        ),
        list(a = 1)
      ),
      tspec_df(x = tib_df("x", a = tib_lgl("a")))
    )))

    # correct path `[[1]]$x[[2]]$a`
    (expect_error(tibblify(
      list(
        list(
          x = list(
            list(a = TRUE),
            list()
          )
        )
      ),
      tspec_df(x = tib_df("x", a = tib_lgl("a")))
    )))
  })

  # fallback default works
  expect_equal(
    tibblify(
      list(
        list(
          x = list(
            list(a = TRUE),
            list(a = FALSE)
          )
        ),
        list(x = list()),
        list()
      ),
      tspec_df(
        x = tib_df("x", .required = FALSE, a = tib_lgl("a", .required = FALSE))
      )
    ),
    tibble(
      x = vctrs::list_of(
        tibble(a = c(TRUE, FALSE)),
        tibble(a = logical()),
        NULL
      )
    )
  )

  # can handle NULL
  expect_equal(
    tibblify(
      list(list(x = NULL)),
      tspec_df(tib_df("x", tib_lgl("a")))
    ),
    tibble(x = vctrs::list_of(NULL, .ptype = tibble(a = logical())))
  )

  # can handle every `tib_*()`
  dtt <- vctrs::new_datetime(1)
  x <- list(
    atomic_scalar = 1L,
    scalar = dtt,
    vector = 1:2,
    variant = list(1L, "a"),
    row = list(a = 1, b = "b"),
    df = list(list(x = 1))
  )
  spec <- tspec_df(
    tib_df(
      "df",
      tib_int("atomic_scalar"),
      tib_scalar("scalar", dtt),
      tib_int_vec("vector"),
      tib_variant("variant"),
      tib_row("row", tib_int("a"), tib_chr("b")),
      tib_df("df", tib_int("x")),
    )
  )

  # This also tests whether the ptypes are calculated correctly
  expect_equal(
    tibblify(list(list(df = list(x))), spec),
    structure(
      tibble(
        df = vctrs::list_of(
          tibble(
            atomic_scalar = 1L,
            scalar = dtt,
            vector = vctrs::list_of(1:2),
            variant = list(list(1L, "a")),
            row = tibble(a = 1L, b = "b"),
            df = vctrs::list_of(tibble(x = 1L))
          )
        )
      )
    )
  )
})

test_that("tibblify: tib_df can use names_to", {
  spec <- tspec_df(x = tib_df("x", a = tib_lgl("a"), .names_to = "name"))
  expect_equal(
    tibblify(
      list(
        list(
          x = list(
            a = list(a = TRUE),
            b = list(a = FALSE)
          )
        )
      ),
      spec
    ),
    tibble(x = vctrs::list_of(tibble(name = c("a", "b"), a = c(TRUE, FALSE))))
  )
})

test_that("tibblify: names_to works", {
  # can parse
  expect_equal(
    tibblify(
      list(
        a = list(x = TRUE),
        b = list(x = FALSE)
      ),
      tspec_df(x = tib_lgl("x"), .names_to = "nms")
    ),
    tibble(nms = c("a", "b"), x = c(TRUE, FALSE))
  )

  # works with partial names
  expect_equal(
    tibblify(
      list(
        a = list(x = TRUE),
        list(x = FALSE)
      ),
      tspec_df(x = tib_lgl("x"), .names_to = "nms")
    ),
    tibble(nms = c("a", ""), x = c(TRUE, FALSE))
  )

  # works for missing names
  expect_equal(
    tibblify(
      list(
        list(x = TRUE),
        list(x = FALSE)
      ),
      tspec_df(x = tib_lgl("x"), .names_to = "nms")
    ),
    tibble(nms = c("", ""), x = c(TRUE, FALSE))
  )
})

test_that("tibble input tibblifies", {
  df <- tibble(x = 1:2, y = c("a", "b"))

  expect_equal(
    tibblify(
      df,
      tspec_df(
        x = tib_int("x"),
        y = tib_chr("y")
      )
    ),
    df
  )

  df2 <- tibble(x = 1:2, y = c("a", "b"), df = tibble(z = 3:4))

  expect_equal(
    tibblify(
      df2,
      tspec_df(
        x = tib_int("x"),
        y = tib_chr("y"),
        df = tib_row(
          "df",
          z = tib_int("z"),
        )
      )
    ),
    df2
  )
})

test_that("tibble with list columns tibblify (#43)", {
  x <- tibble::tibble(x = list(1:3, NULL, 1:2))
  expect_equal(
    tibblify(x, tspec_df(x = tib_int_vec("x"))),
    tibble(x = vctrs::list_of(1:3, NULL, 1:2))
  )

  y <- tibble::tibble(x = list(tibble(a = 1:2), NULL, tibble(a = 1)))
  spec <- tspec_df(x = tib_df("x", tib_dbl("a"), .required = FALSE))
  expect_equal(
    tibblify(y, tspec_df(x = tib_df("x", tib_dbl("a")))),
    tibble(x = vctrs::list_of(tibble(a = 1:2), NULL, tibble(a = 1)))
  )
})

test_that("nested keys tibblify", {
  expect_equal(
    tibblify(
      list(list(x = list(y = list(z = 1)))),
      tspec_df(xyz = tib_int(c("x", "y", "z")))
    ),
    tibble(xyz = 1)
  )

  spec <- tspec_df(
    afk = tib_chr(c("a", "f", "k")),
    ael = tib_int(c("a", "e", "l")),
    aek = tib_dbl(c("a", "e", "k"))
  )

  out <- tibblify(
    list(
      list(
        a = list(
          e = list(k = -0.1, l = 1L),
          f = list(k = "a")
        )
      ),
      list(
        a = list(
          e = list(k = +0.2, l = 2L),
          f = list(k = "b")
        )
      )
    ),
    spec
  )
  expect_equal(
    out,
    tibble(afk = c("a", "b"), ael = 1:2, aek = c(-0.1, +0.2))
  )
})

test_that("empty spec tibblifies", {
  expect_equal(
    tibblify(
      list(list(), list()),
      tspec_df()
    ),
    tibble(.rows = 2)
  )

  expect_equal(
    tibblify(
      list(),
      tspec_df()
    ),
    tibble()
  )

  expect_equal(
    tibblify(
      list(list(x = list()), list(x = list())),
      tspec_df(x = tib_row("x"))
    ),
    tibble(x = tibble(.rows = 2), .rows = 2)
  )

  expect_equal(
    tibblify(
      list(),
      tspec_df(x = tib_row("x", .required = FALSE))
    ),
    tibble(x = tibble())
  )
})

test_that("tibblify does not confuse key order due to case (#96)", {
  skip_on_cran()
  withr::local_locale(c(LC_COLLATE = "en_US"))
  spec <- tspec_object(
    B = tib_int("B", .required = FALSE),
    a = tib_int("a", .required = FALSE),
  )
  expect_equal(
    tibblify::tibblify(list(B = 1), spec),
    structure(list(B = 1, a = NA_integer_), class = "tibblify_object")
  )
})

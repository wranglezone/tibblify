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

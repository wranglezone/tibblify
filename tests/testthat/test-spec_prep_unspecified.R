test_that(".spec_replace_unspecified works with drop", {
  spec <- tspec_df(
    tib_int("1int"),
    tib_unspecified("1un"),
    tib_df(
      "1df",
      tib_int("2int"),
      tib_unspecified("2un"),
      tib_row(
        "2row",
        `3un` = tib_unspecified("key"),
        `3un2` = tib_unspecified("key2"),
      )
    ),
    tib_row(
      "1row",
      tib_unspecified("2un2"),
      `2un3` = tib_unspecified("key")
    )
  )
  spec_dropped <- spec
  spec_dropped$fields$`1un` <- NULL
  spec_dropped$fields$`1df`$fields$`2un` <- NULL
  spec_dropped$fields$`1df`$fields$`2row`$fields <- list()
  spec_dropped$fields$`1row`$fields <- list()
  expect_equal(
    .spec_prep_unspecified(spec, unspecified = "drop", current_call()),
    spec_dropped,
    ignore_attr = "names"
  )
})

test_that(".spec_replace_unspecified works with list", {
  spec <- tspec_df(
    tib_int("1int"),
    tib_unspecified("1un"),
    tib_df(
      "1df",
      tib_int("2int"),
      tib_unspecified("2un"),
      tib_row(
        "2row",
        `3un` = tib_unspecified("key"),
        `3un2` = tib_unspecified("key2"),
      )
    ),
    tib_row(
      "1row",
      tib_unspecified("2un2"),
      `2un3` = tib_unspecified("key")
    )
  )
  spec_listified <- tspec_df(
    tib_int("1int"),
    tib_variant("1un"),
    tib_df(
      "1df",
      tib_int("2int"),
      tib_variant("2un"),
      tib_row(
        "2row",
        `3un` = tib_variant("key"),
        `3un2` = tib_variant("key2"),
      )
    ),
    tib_row(
      "1row",
      tib_variant("2un2"),
      `2un3` = tib_variant("key")
    )
  )

  expect_equal(
    .spec_prep_unspecified(spec, unspecified = "list"),
    spec_listified
  )
})

test_that(".spec_replace_unspecified errors with error", {
  spec <- tspec_df(
    tib_unspecified("1un")
  )
  local_mocked_bindings(
    .spec_inform_unspecified = function(spec, unspecified, call) {
      stop("unspecified fields found")
    },
  )
  expect_error(
    .spec_prep_unspecified(spec, unspecified = "error", current_call()),
    "unspecified fields found"
  )
})

test_that(".spec_replace_unspecified informs with inform", {
  spec <- tspec_df(
    tib_unspecified("1un")
  )
  local_mocked_bindings(
    .spec_inform_unspecified = function(spec, unspecified, call) {
      message("unspecified fields found")
    },
  )
  expect_message(
    .spec_prep_unspecified(spec, unspecified = "inform", current_call()),
    "unspecified fields found"
  )
})

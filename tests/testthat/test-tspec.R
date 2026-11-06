test_that("tspec_df errors on invalid names", {
  expect_snapshot({
    # duplicated name
    (expect_error(tspec_df(x = tib_int("x"), x = tib_int("y"))))
  })
})

test_that("tspec_df errors if element is not a tib collector", {
  expect_snapshot({
    (expect_error(tspec_df(1)))
    (expect_error(tspec_df(x = tib_int("x"), y = "a")))
  })
})

test_that("tspec_df can infer name from key", {
  expect_equal(tspec_df(tib_int("x")), tspec_df(x = tib_int("x")))

  expect_equal(
    tspec_df(tib_row("x", tib_int("a"))),
    tspec_df(x = tib_row("x", a = tib_int("a")))
  )

  expect_snapshot({
    (expect_error(tspec_df(tib_int(c("a", "b")))))

    # auto name creates duplicated name
    (expect_error(tspec_df(y = tib_int("x"), tib_int("y"))))
  })
})

test_that("tspec_df errors on invalid `.names_to`", {
  expect_snapshot({
    (expect_error(tspec_df(.names_to = NA_character_)))
    (expect_error(tspec_df(.names_to = 1)))
  })
})

test_that("tspec_df errors if `.names_to` column name is not unique", {
  expect_snapshot((expect_error(tspec_df(x = tib_int("x"), .names_to = "x"))))
})

test_that("tspec_df errors if `.names_to` is used with colmajor", {
  expect_snapshot({
    (expect_error(tspec_df(.names_to = "x", .input_form = "colmajor")))
  })
})

test_that("empty dots create empty list", {
  expect_equal(tspec_df()$fields, list())
  expect_equal(tspec_row()$fields, list())
  expect_equal(tspec_object()$fields, list())
})

test_that("tspec_* can nest specifications", {
  spec1 <- tspec_row(
    a = tib_int("a"),
    b = tib_int("b")
  )
  spec2 <- tspec_row(
    c = tib_chr("c"),
    d = tib_row("d", x = tib_int("x"))
  )

  expect_equal(
    tspec_df(spec1),
    tspec_df(!!!spec1$fields)
  )

  expect_equal(
    tspec_df(spec1, spec2),
    tspec_df(!!!spec1$fields, !!!spec2$fields)
  )

  expect_snapshot((expect_error(tspec_df(spec1, spec1))))
})

test_that("tspec_row drops NULL", {
  expect_equal(
    tspec_row(tib_int("a"), NULL, if (FALSE) tib_chr("b")),
    tspec_row(tib_int("a"))
  )
})

test_that("tspec_recursive errors for bad .children and .children_to", {
  expect_snapshot({
    (expect_error(
      tspec_recursive(.children = 1L)
    ))
    (expect_error(
      tspec_recursive(.children = "a", .children_to = 1L)
    ))
  })
})

test_that("tspec_recursive creates the expected spec", {
  expect_equal(
    tspec_recursive(
      tib_int("id"),
      tib_chr("name", .required = FALSE),
      .children = "children"
    ),
    structure(
      list(
        type = "recursive",
        fields = list(
          id = tib_int("id"),
          name = tib_chr("name", .required = FALSE)
        ),
        child = "children",
        children_to = "children",
        input_form = "rowmajor"
      ),
      class = c("tspec_recursive", "tspec")
    )
  )
})

test_that("tspec_*() errors on duplicate keys (#139)", {
  stbl::expect_pkg_error_snapshot(
    tspec_df(
      id1 = tib_int("id"),
      id2 = tib_chr("id"),
      tib_chr("name"),
      tib_chr_vec("aliases")
    ),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
  stbl::expect_pkg_error_classes(
    tspec_row(a = tib_int("x"), b = tib_int("x")),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
  stbl::expect_pkg_error_classes(
    tspec_object(a = tib_int("x"), b = tib_int("x")),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
  stbl::expect_pkg_error_classes(
    tspec_recursive(
      a = tib_int("x"),
      b = tib_int("x"),
      .children = "kids"
    ),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
})

test_that("tspec_*() reports every duplicated key (#139)", {
  stbl::expect_pkg_error_snapshot(
    tspec_df(
      a1 = tib_int("a"),
      a2 = tib_int("a"),
      b1 = tib_int(c("b", "c")),
      b2 = tib_chr(c("b", "c")),
      b3 = tib_dbl(c("b", "c")),
      d = tib_int("d")
    ),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
})

test_that("tspec_*() treats keys as whole vectors (#139)", {
  expect_no_error(
    tspec_df(
      x = tib_int(c("a", "b")),
      y = tib_int(c("a", "c")),
      z = tib_int("a")
    )
  )
})

test_that("tspec_*() checks keys of nested specs and tib_row() fields (#139)", {
  spec1 <- tspec_row(a = tib_int("a"))
  spec2 <- tspec_row(b = tib_int("a"))
  stbl::expect_pkg_error_classes(
    tspec_df(spec1, spec2),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
})

test_that("tib_row(), tib_df(), and tib_recursive() check duplicate keys (#139)", {
  stbl::expect_pkg_error_classes(
    tib_row("r", a = tib_int("x"), b = tib_int("x")),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
  stbl::expect_pkg_error_classes(
    tib_df("r", a = tib_int("x"), b = tib_int("x")),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
  stbl::expect_pkg_error_classes(
    tib_recursive("r", a = tib_int("x"), b = tib_int("x"), .children = "kids"),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
})

test_that("`.duplicate_keys = 'warn'` warns but keeps the fields (#139)", {
  stbl::expect_pkg_warning_snapshot(
    out <- tspec_df(
      id1 = tib_int("id"),
      id2 = tib_chr("id"),
      .duplicate_keys = "warn"
    ),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
  expect_named(out$fields, c("id1", "id2"))
  stbl::expect_pkg_warning_classes(
    tib_row("r", a = tib_int("x"), b = tib_int("x"), .duplicate_keys = "warn"),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
})

test_that("`.duplicate_keys = 'allow'` skips the check (#139)", {
  expect_no_condition(
    out <- tspec_df(
      id1 = tib_int("id"),
      id2 = tib_chr("id"),
      .duplicate_keys = "allow"
    )
  )
  expect_named(out$fields, c("id1", "id2"))
  expect_no_condition(
    tib_df("r", a = tib_int("x"), b = tib_int("x"), .duplicate_keys = "allow")
  )
})

test_that("`.duplicate_keys` must be a valid choice (#139)", {
  expect_error(
    tspec_df(tib_int("a"), .duplicate_keys = "nope"),
    class = "rlang_error"
  )
  expect_error(tib_row("r", .duplicate_keys = "nope"), class = "rlang_error")
})

test_that("`.duplicate_keys` is not stored in the spec (#139)", {
  expect_false(
    any(grepl(
      "duplicate",
      names(tspec_df(tib_int("a"), .duplicate_keys = "warn"))
    ))
  )
})

test_that("tspec_recursive() errors if `.children_to` matches a field name (#139)", {
  stbl::expect_pkg_error_snapshot(
    tspec_recursive(
      tib_chr("label"),
      kids = tib_variant("other"),
      .children = "kids"
    ),
    "tibblify",
    "spec",
    "children_to"
  )
  stbl::expect_pkg_error_classes(
    tspec_recursive(
      tib_chr("label"),
      .children = "kids",
      .children_to = "label"
    ),
    "tibblify",
    "spec",
    "children_to"
  )
  stbl::expect_pkg_error_classes(
    tspec_recursive(
      tib_chr("label"),
      .children = "kids",
      .children_to = "label",
      .duplicate_keys = "allow"
    ),
    "tibblify",
    "spec",
    "children_to"
  )
})

test_that("tspec_recursive() errors if `.children` is also a field key (#139)", {
  stbl::expect_pkg_error_snapshot(
    tspec_recursive(
      tib_chr("label"),
      raw = tib_variant("kids"),
      .children = "kids"
    ),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
  stbl::expect_pkg_warning_classes(
    tspec_recursive(
      tib_chr("label"),
      raw = tib_variant("kids"),
      .children = "kids",
      .duplicate_keys = "warn"
    ),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
  expect_no_condition(
    tspec_recursive(
      tib_chr("label"),
      raw = tib_variant("kids"),
      .children = "kids",
      .duplicate_keys = "allow"
    )
  )
})

test_that("tspec_recursive() reports a field duplicate only once (#139)", {
  n_warnings <- 0
  withCallingHandlers(
    tspec_recursive(
      a = tib_int("x"),
      b = tib_int("x"),
      .children = "kids",
      .duplicate_keys = "warn"
    ),
    warning = function(w) {
      n_warnings <<- n_warnings + 1
      invokeRestart("muffleWarning")
    }
  )
  expect_equal(n_warnings, 1)
})

test_that("tib_recursive() checks `.children` against its fields (#139)", {
  stbl::expect_pkg_error_classes(
    tib_recursive("r", tib_chr("kids"), .children = "kids"),
    "tibblify",
    "spec",
    "children_to"
  )
  stbl::expect_pkg_error_classes(
    tib_recursive(
      "r",
      raw = tib_variant("kids"),
      .children = "kids"
    ),
    "tibblify",
    "spec",
    "duplicate_keys"
  )
  expect_no_condition(
    tib_recursive("r", tib_chr("label"), .children = "kids")
  )
})

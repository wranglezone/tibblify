# .format_fields -------------------------------------------------------------

test_that(".format_fields returns 'f_name()' for empty fields and no args", {
  expect_equal(.format_fields("tspec_df", fields = list(), width = NULL, force_names = FALSE), "tspec_df()")
})

test_that(".format_fields formats non-empty fields without args", {
  fields <- list(a = tib_int("a"))
  result <- .format_fields("tspec_df", fields = fields, width = NULL, force_names = FALSE)
  expect_equal(result, 'tspec_df(\n  tib_int("a"),\n)')
})

test_that(".format_fields prepends args before fields", {
  fields <- list(a = tib_int("a"))
  result <- .format_fields(
    "tspec_df",
    fields = fields,
    width = NULL,
    args = list(.input_form = '"colmajor"'),
    force_names = FALSE
  )
  expect_equal(result, 'tspec_df(\n  .input_form = "colmajor",\n  tib_int("a"),\n)')
})

test_that(".format_fields shows all names when force_names = TRUE", {
  fields <- list(a = tib_int("a"))
  result <- .format_fields("tspec_df", fields = fields, width = NULL, force_names = TRUE)
  expect_equal(result, 'tspec_df(\n  a = tib_int("a"),\n)')
})

test_that(".format_fields hides canonical names when force_names = FALSE", {
  fields <- list(a = tib_int("a"))
  result <- .format_fields("tspec_df", fields = fields, width = NULL, force_names = FALSE)
  # canonical name ("a" == key "a") should be suppressed
  expect_false(grepl("a =", result))
})

test_that(".format_fields shows non-canonical names when force_names = FALSE", {
  # Field name "b" != key "a" → non-canonical, must be shown
  fields <- list(b = tib_int("a"))
  result <- .format_fields("tspec_df", fields = fields, width = NULL, force_names = FALSE)
  expect_true(grepl("b =", result))
})

test_that(".format_fields drops NULL args", {
  fields <- list(a = tib_int("a"))
  result <- .format_fields(
    "tspec_df",
    fields = fields,
    width = NULL,
    args = list(.names_to = NULL),
    force_names = FALSE
  )
  expect_false(grepl(".names_to", result))
})


# .is_tib_name_canonical -----------------------------------------------------

test_that(".is_tib_name_canonical returns TRUE when key matches name", {
  field <- list(key = "x")
  expect_true(.is_tib_name_canonical(field, "x"))
})

test_that(".is_tib_name_canonical returns FALSE when key doesn't match name", {
  field <- list(key = "x")
  expect_false(.is_tib_name_canonical(field, "y"))
})

test_that(".is_tib_name_canonical returns FALSE for multi-element key", {
  field <- list(key = c("a", "b"))
  expect_false(.is_tib_name_canonical(field, "a"))
})

test_that(".is_tib_name_canonical returns FALSE for non-character key", {
  field <- list(key = 1L)
  expect_false(.is_tib_name_canonical(field, "1"))
})


# .double_tick ----------------------------------------------------------------

test_that(".double_tick wraps string in double quotes", {
  expect_equal(.double_tick("foo"), '"foo"')
})

test_that(".double_tick returns NULL for NULL input", {
  expect_null(.double_tick(NULL))
})


# .tibblify_width -------------------------------------------------------------

test_that(".tibblify_width returns width argument when supplied", {
  expect_equal(.tibblify_width(42L), 42L)
})

test_that(".tibblify_width falls back to getOption('width') when NULL", {
  withr::local_options(width = 77)
  expect_equal(.tibblify_width(NULL), 77)
})


# .is_syntactic ---------------------------------------------------------------

test_that(".is_syntactic identifies syntactic names", {
  expect_true(.is_syntactic("valid_name"))
  expect_true(.is_syntactic(".valid"))
})

test_that(".is_syntactic rejects non-syntactic names", {
  expect_false(.is_syntactic("not-valid"))
  expect_false(.is_syntactic("1starts_with_digit"))
})


# .pad ------------------------------------------------------------------------

test_that(".pad prepends n spaces to each line", {
  expect_equal(.pad("hello", 2), "  hello")
  expect_equal(.pad("hello", 4), "    hello")
})

test_that(".pad indents all lines of a multi-line string", {
  expect_equal(.pad("line1\nline2", 2), "  line1\n  line2")
})


# .name_exprs -----------------------------------------------------------------

test_that(".name_exprs omits name prefix when show_name is FALSE", {
  expect_equal(.name_exprs(c("expr"), c("name"), FALSE), "expr")
})

test_that(".name_exprs prepends syntactic names with ' = '", {
  expect_equal(.name_exprs(c("expr"), c("name"), TRUE), "name = expr")
})

test_that(".name_exprs backtick-wraps non-syntactic names", {
  expect_equal(
    .name_exprs(c("expr"), c("not-valid"), TRUE),
    "`not-valid` = expr"
  )
})

test_that(".name_exprs escapes backticks inside non-syntactic names", {
  expect_equal(
    .name_exprs(c("expr"), c("has`tick"), TRUE),
    "`has\\`tick` = expr"
  )
})

test_that(".name_exprs handles mixed show_name vector", {
  result <- .name_exprs(c("e1", "e2"), c("n1", "n2"), c(TRUE, FALSE))
  expect_equal(result, c("n1 = e1", "e2"))
})


# .collapse_with_pad ----------------------------------------------------------

test_that(".collapse_with_pad returns single-line for short unnamed input", {
  result <- .collapse_with_pad(list("a", "b"), multi_line = FALSE, width = 80)
  expect_equal(result, "a, b")
})

test_that(".collapse_with_pad returns multi-line when multi_line = TRUE", {
  result <- .collapse_with_pad(list("a"), multi_line = TRUE, width = 80)
  expect_equal(result, "\n  a,\n")
})

test_that(".collapse_with_pad returns multi-line when more than 2 elements", {
  result <- .collapse_with_pad(
    list("a", "b", "c"),
    multi_line = FALSE,
    width = 80
  )
  expect_equal(result, "\n  a,\n  b,\n  c,\n")
})

test_that(".collapse_with_pad returns multi-line when line would be too long", {
  long <- paste(rep("x", 60), collapse = "")
  result <- .collapse_with_pad(list(long, long), multi_line = FALSE, width = 80)
  expect_equal(result, paste0("\n  ", long, ",\n  ", long, ",\n"))
})

test_that(".collapse_with_pad uses name = expr format for named elements", {
  result <- .collapse_with_pad(
    list(a = "1", b = "2"),
    multi_line = FALSE,
    width = 80
  )
  expect_equal(result, "a = 1, b = 2")
})

test_that(".collapse_with_pad backtick-wraps non-syntactic names", {
  result <- .collapse_with_pad(
    list(`not-valid` = "1"),
    multi_line = FALSE,
    width = 80
  )
  expect_equal(result, "`not-valid` = 1")
})


# .should_force_names ---------------------------------------------------------

test_that(".should_force_names returns FALSE by default", {
  expect_false(.should_force_names())
})

test_that(".should_force_names returns TRUE when option is set", {
  withr::local_options(tibblify.print_names = TRUE)
  expect_true(.should_force_names())
})


# .check_print_names_arg ------------------------------------------------------

test_that(".check_print_names_arg passes through TRUE and FALSE", {
  expect_true(.check_print_names_arg(TRUE))
  expect_false(.check_print_names_arg(FALSE))
})

test_that(".check_print_names_arg resolves NULL via option", {
  expect_false(.check_print_names_arg(NULL))

  withr::local_options(tibblify.print_names = TRUE)
  expect_true(.check_print_names_arg(NULL))
})

test_that(".check_print_names_arg errors on non-bool input", {
  expect_error(.check_print_names_arg("yes"))
})

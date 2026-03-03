---
name: tdd-workflow
description: Test-driven development workflow for tibblify. Use when writing any R code: writing new features, fixing bugs, refactoring, or reviewing tests.
---

# TDD workflow for tibblify

## Core principle

Write a failing test first, then implement the minimal code to make it pass,
then refactor. Never write implementation code without a failing test driving it.

## File naming

Tests for `R/{name}.R` go in `tests/testthat/test-{name}.R`. Place new tests
next to similar existing ones.

## Running tests

```r
# Full suite
devtools::test(reporter = "check")

# Single file
devtools::test(filter = "name", reporter = "check")

# Quick interactive check (testing functions load code automatically —
# no need to call library() or devtools::load_all() separately)
devtools::load_all()
expect_equal(my_function(1), 1)
```

## Coverage

Goal: **100%** for every edited file. After editing `R/file_name.R`, verify:

```r
covr_res <- devtools:::test_coverage_active_file("R/file_name.R")
which(purrr::map_int(covr_res, "value") == 0)
```

Files excluded from the coverage requirement:
- `R/aaa-shared_params.R`
- `R/tibblify-package.R`
- Files matching `R/import-standalone-*.R`

## Test types

### Unit tests

Test individual functions in isolation:

```r
test_that("tib_chr() accepts a .default argument", {
  spec <- tspec_df(tib_chr("x", .default = "fallback"))
  result <- tibblify(list(list()), spec)
  expect_equal(result$x, "fallback")
})
```

### Integration tests

Test end-to-end pipelines through the full `tibblify()` → output path:

```r
test_that("nested tspec_df works end-to-end", {
  input <- list(list(a = list(b = 1L)))
  spec <- tspec_df(tib_df("a", tspec_df(tib_int("b"))))
  result <- tibblify(input, spec)
  expect_equal(result$a[[1]]$b, 1L)
})
```

### Snapshot tests

For complex outputs that are hard to specify with equality assertions:

```r
test_that("print method is stable (#123)", {
  expect_snapshot(print(tspec_df(tib_chr("x"))))
})

# For errors, wrap expect_error() inside expect_snapshot() so both the error
# class and the message text are captured in the snapshot:
test_that("errors if there are detached parts of the tree (#456)", {
  df <- tibble::tibble(
    id = c(1, 2, 3),
    x = c("a", "b", "c"),
    parent = c(NA, 3, 2)
  )

  expect_snapshot({
    (expect_error(
      nest_tree(df, id, parent, children_to = "children"),
      class = "tibblify-error-detached_tree_parts"
    ))
  })
})
```

When snapshots change intentionally:

```r
testthat::snapshot_review("test_name")
testthat::snapshot_accept("test_name")
```

Snapshots are stored in `tests/testthat/_snaps/`.

## Test design principles

- **Self-sufficient:** each test contains its own setup, execution, and
  assertion. Tests must be runnable in isolation.
- **Duplication over factoring:** repeat setup code rather than extracting it.
  Clarity beats DRY in tests.
- **One concept per test:** a failing test should tell you exactly what broke.
- **Issue reference in description:** the `desc` of every new `test_that()` call
  should end with a parenthetical issue reference:
  ```r
  test_that("tib_chr() accepts a .default argument (#123)", { ... })
  test_that("errors on empty input (#123, #456)", { ... })
  ```

## testthat Edition 3 — deprecated patterns

```r
# Deprecated → Modern
context("Data validation")        # Remove — filename serves this purpose
expect_equivalent(x, y)          # expect_equal(x, y, ignore_attr = TRUE)
with_mock(...)                    # local_mocked_bindings(...)
expect_is(x, "data.frame")       # expect_s3_class(x, "data.frame")
```

## Essential expectations

### Equality & identity

```r
expect_equal(x, y)                        # with numeric tolerance
expect_equal(x, y, tolerance = 0.001)
expect_equal(x, y, ignore_attr = TRUE)
expect_identical(x, y)                    # exact match
```

### Conditions

```r
expect_error(code)
expect_error(code, "pattern")
expect_error(code, class = "tibblify_error")
expect_warning(code)
expect_no_warning(code)
expect_message(code)
expect_no_message(code)
```

### Collections

```r
expect_setequal(x, y)           # same elements, any order
expect_in(element, set)
expect_named(x, c("a", "b"))
```

### Type & structure

```r
expect_type(x, "double")
expect_s3_class(x, "tbl_df")
expect_length(x, 10)
```

### Logical

```r
expect_true(x)
expect_false(x)
expect_null(x)
```

## `withr` patterns for temporary state

```r
withr::local_options(list(tibblify.option = TRUE))
withr::local_envvar(MY_VAR = "value")
withr::local_tempfile(lines = c("a", "b"))
```

## Fixtures

Store static test data in `tests/testthat/fixtures/` and access via:

```r
test_path("fixtures", "sample.rds")
```

## Mocking

```r
local_mocked_bindings(
  external_fn = function(...) "mocked_result"
)
result <- my_function_that_calls_external_fn()
```

## Common mistakes

- **Do not modify tests to make them pass.** Fix the implementation.
- **Do not write tests that depend on other tests' state.** Each test must
  be independently runnable.

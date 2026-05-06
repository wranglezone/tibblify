test_that(".read_spec() errors informatively on unsupported input types", {
  expect_error(.read_spec(123L), "not the number 123")
})

test_that(".read_spec() can read list specs", {
  spec <- list(
    openapi = "3.1.0",
    paths = list("/test" = list(summary = "No methods here"))
  )
  result <- .read_spec(spec)
  expect_identical(result, spec)
})

test_that(".read_schema() can read list specs", {
  spec <- list(
    openapi = "3.1.0",
    paths = list("/test" = list(summary = "No methods here"))
  )
  result <- .read_schema(spec)
  expect_identical(result, spec)
})

test_that(".read_spec() can read specs by filename", {
  file <- test_path("fixtures", "SponsoredProducts_prod_3p.json")
  result <- .read_spec(file)
  expect_length(result, 4)
  expect_named(result, c("info", "paths", "components", "openapi"))
})

test_that(".read_spec() can read character (non-file) specs", {
  file <- "
  openapi: 3.1.0
  paths:
    /test:
      summary: No methods here"
  result <- .read_spec(file)
  spec <- list(
    openapi = "3.1.0",
    paths = list("/test" = list(summary = "No methods here"))
  )
  expect_identical(result, spec)
})

test_that("OpenAPI version < 3 throws an informative error", {
  expect_error(
    .read_spec(list()),
    "OpenAPI versions before 3 are not supported"
  )
  # But not for schemas.
  expect_no_error(
    .read_schema(list())
  )
})

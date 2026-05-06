test_that("parse_openapi_spec() can parse 'Sponsored Products' openapi spec", {
  url <- "https://dtrnk0o2zy01c.cloudfront.net/openapi/en-us/dest/SponsoredProducts_prod_3p.json"
  file <- test_path("fixtures", basename(url))
  # download.file(url, file)
  rds_file <- sub("json$", "rds", file)
  # saveRDS(parse_openapi_spec(file), rds_file)
  expect_equal(parse_openapi_spec(file), readRDS(rds_file))
})

test_that("parse_openapi_spec() can parse slack.com openapi spec", {
  # url <- "https://api.apis.guru/v2/specs/slack.com/1.7.0/openapi.json"
  file <- test_path("fixtures", "slack-openapi.json")
  # download.file(url, file)
  rds_file <- sub("json$", "rds", file)
  # saveRDS(parse_openapi_spec(file), rds_file)
  expect_equal(parse_openapi_spec(file), readRDS(rds_file))
})

test_that("parse_openapi_spec() can parse sportsdata.io openapi spec", {
  # url <- "https://api.apis.guru/v2/specs/sportsdata.io/csgo-v3-scores/1.0/openapi.json"
  file <- test_path("fixtures", "sportsdata-openapi.json")
  # download.file(url, file)
  rds_file <- sub("json$", "rds", file)
  # saveRDS(parse_openapi_spec(file), rds_file)
  expect_equal(parse_openapi_spec(file), readRDS(rds_file))
})

test_that("parse_openapi_spec() can parse brex.io openapi spec", {
  # url <- "https://api.apis.guru/v2/specs/brex.io/2021.12/openapi.json"
  file <- test_path("fixtures", "brex-openapi.json")
  # download.file(url, file)
  rds_file <- sub("json$", "rds", file)
  # saveRDS(parse_openapi_spec(file), rds_file)
  expect_equal(parse_openapi_spec(file), readRDS(rds_file))
})

# parse_openapi_schema() --------------------------------------------------

test_that("parse_openapi_schema() returns tspec_row for object schemas", {
  schema <- list(
    type = "object",
    properties = list(
      name = list(type = "string"),
      age = list(type = "integer")
    ),
    required = "name"
  )
  result <- parse_openapi_schema(schema)
  expect_s3_class(result, "tspec_row")
})

test_that("parse_openapi_schema() returns tspec_df for array schemas", {
  schema <- list(
    type = "array",
    items = list(
      type = "object",
      properties = list(name = list(type = "string"))
    )
  )
  result <- parse_openapi_schema(schema)
  expect_s3_class(result, "tspec_df")
})

test_that("parse_openapi_schema() parses inline multi-line YAML strings", {
  yaml_str <- "
type: object
properties:
  name:
    type: string
"
  result <- parse_openapi_schema(yaml_str)
  expect_s3_class(result, "tspec_row")
})

# parse_openapi_spec() edge cases -----------------------------------------

test_that("path items with no HTTP operations produce empty results", {
  spec <- list(
    openapi = "3.1.0",
    paths = list(
      "/test" = list(summary = "No methods here")
    )
  )
  result <- parse_openapi_spec(spec)
  expect_s3_class(result, "tbl_df")
})

test_that("response objects with links error informatively", {
  spec <- list(
    openapi = "3.1.0",
    paths = list(
      "/test" = list(
        get = list(
          responses = list(
            "200" = list(
              description = "OK",
              links = list(aLink = list(operationId = "doSomething"))
            )
          )
        )
      )
    )
  )
  expect_error(parse_openapi_spec(spec), "do not yet support")
})

# openapi_resolve_reference() edge cases ----------------------------------

test_that("openapi_resolve_reference() fetches URL $ref schemas", {
  local_mocked_bindings(
    read_yaml = function(file, ...) list(type = "string"),
    .package = "yaml"
  )
  spec <- list(
    openapi = "3.1.0",
    paths = list(
      "/test" = list(
        get = list(
          responses = list(
            "200" = list(
              description = "OK",
              content = list(
                "application/json" = list(
                  schema = list("$ref" = "https://example.com/schema.yaml")
                )
              )
            )
          )
        )
      )
    )
  )
  expect_no_error(parse_openapi_spec(spec))
})

test_that("openapi_resolve_reference() errors on $ref not starting with '#'", {
  spec <- list(
    openapi = "3.1.0",
    paths = list(
      "/test" = list(
        get = list(
          responses = list(
            "200" = list(
              description = "OK",
              content = list(
                "application/json" = list(
                  schema = list("$ref" = "components/schemas/Foo")
                )
              )
            )
          )
        )
      )
    )
  )
  expect_error(parse_openapi_spec(spec), "does not start with")
})

test_that("openapi_resolve_reference() errors when the referenced schema is NULL", {
  local_mocked_bindings(
    chuck = function(...) NULL,
    .package = "purrr"
  )
  spec <- list(
    openapi = "3.1.0",
    paths = list(
      "/test" = list(
        get = list(
          responses = list(
            "200" = list(
              description = "OK",
              content = list(
                "application/json" = list(
                  schema = list("$ref" = "#/components/schemas/Foo")
                )
              )
            )
          )
        )
      )
    )
  )
  expect_error(parse_openapi_spec(spec), "No schema found for reference")
})

# schema_to_tspec() edge cases --------------------------------------------

test_that("schema_to_tspec() handles allOf by combining sub-schemas", {
  spec <- list(
    openapi = "3.1.0",
    paths = list(
      "/test" = list(
        get = list(
          responses = list(
            "200" = list(
              description = "OK",
              content = list(
                "application/json" = list(
                  schema = list(
                    allOf = list(
                      list(
                        type = "object",
                        properties = list(a = list(type = "string"))
                      ),
                      list(
                        type = "object",
                        properties = list(b = list(type = "integer"))
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
  expect_no_error(parse_openapi_spec(spec))
})

test_that("schema_to_tspec() handles non-object/array (scalar) schemas", {
  spec <- list(
    openapi = "3.1.0",
    paths = list(
      "/test" = list(
        get = list(
          responses = list(
            "200" = list(
              description = "OK",
              content = list(
                "application/json" = list(
                  schema = list(type = "string")
                )
              )
            )
          )
        )
      )
    )
  )
  expect_no_error(parse_openapi_spec(spec))
})

# parse_schema() edge cases -----------------------------------------------

test_that("parse_schema() handles allOf in property definitions", {
  schema <- list(
    type = "object",
    properties = list(
      data = list(
        allOf = list(
          list(type = "object", properties = list(x = list(type = "string"))),
          list(type = "object", properties = list(y = list(type = "integer")))
        )
      )
    )
  )
  result <- parse_openapi_schema(schema)
  expect_s3_class(result, "tspec_row")
})

test_that("parse_schema() informs and uses tib_variant for arrays with no items", {
  schema <- list(
    type = "object",
    properties = list(
      items_field = list(type = "array")
    )
  )
  expect_message(
    result <- parse_openapi_schema(schema),
    "Array has no items"
  )
  expect_s3_class(result, "tspec_row")
})

test_that("parse_schema() errors on unsupported types", {
  schema <- list(
    type = "object",
    properties = list(
      weird = list(type = "unsupported_type")
    )
  )
  expect_error(parse_openapi_schema(schema), "Unsupported type")
})

test_that("parse_schema() falls back to tib_variant for incompatible oneOf scalar types", {
  schema <- list(
    type = "object",
    properties = list(
      value = list(
        oneOf = list(
          list(type = "string"),
          list(type = "integer")
        )
      )
    )
  )
  result <- parse_openapi_schema(schema)
  expect_s3_class(result, "tspec_row")
})

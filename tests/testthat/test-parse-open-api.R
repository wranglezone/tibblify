test_that("can parse 'Sponsored Products' open api spec", {
  # Spec downloaded locally so tests don't require internet connection.
  url <- "https://dtrnk0o2zy01c.cloudfront.net/openapi/en-us/dest/SponsoredProducts_prod_3p.json"
  file <- test_path("fixtures", basename(url))
  # download.file(url, file)
  expect_no_error({
    test_result <- parse_openapi_spec(file)
  })
  rds_file <- sub("json$", "rds", file)
  # saveRDS(test_result, rds_file)
  expect_equal(test_result, readRDS(rds_file))
})

test_that("can parse slack.com open api spec", {
  # Spec downloaded locally so tests don't require internet connection.
  url <- "https://api.apis.guru/v2/specs/slack.com/1.7.0/openapi.json"
  file <- test_path("fixtures", "slack-openapi.json")
  # download.file(url, file)
  expect_no_error({
    test_result <- parse_openapi_spec(file)
  })
  rds_file <- sub("json$", "rds", file)
  # saveRDS(test_result, rds_file)
  expect_equal(test_result, readRDS(rds_file))
})

test_that("can parse sportsdata.io open api spec", {
  # Spec downloaded locally so tests don't require internet connection.
  url <- "https://api.apis.guru/v2/specs/sportsdata.io/csgo-v3-scores/1.0/openapi.json"
  file <- test_path("fixtures", "sportsdata-openapi.json")
  # download.file(url, file)
  expect_no_error({
    test_result <- parse_openapi_spec(file)
  })
  rds_file <- sub("json$", "rds", file)
  # saveRDS(test_result, rds_file)
  expect_equal(test_result, readRDS(rds_file))
})

test_that("can parse brex.io open api spec", {
  # Spec downloaded locally so tests don't require internet connection.
  url <- "https://api.apis.guru/v2/specs/brex.io/2021.12/openapi.json"
  file <- test_path("fixtures", "brex-openapi.json")
  # download.file(url, file)
  expect_no_error({
    test_result <- parse_openapi_spec(file)
  })
  rds_file <- sub("json$", "rds", file)
  # saveRDS(test_result, rds_file)
  expect_equal(test_result, readRDS(rds_file))
})

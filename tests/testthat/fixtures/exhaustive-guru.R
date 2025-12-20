## Use this file to check all of the APIs on apis.guru, logging whether we can
## parse their spec. This takes a very long time.

# tibblify needs to be *installed* so callr can find it.
library(tibblify)
# library(bit64) # I don't want to library this, but it's used.
library(dplyr)
library(tidyr)
library(purrr)
library(httr2)
library(yaml)
library(callr)

# Some apis.guru URLs are no longer valid. That isn't our problem!
check_url_exists <- purrr::possibly(
  function(url) {
    url <- utils::URLencode(url)
    httr2::request(url) |>
      httr2::req_method("HEAD") |>
      httr2::req_perform() |>
      httr2::resp_status() |>
      {\(status) status < 400}()
  },
  otherwise = FALSE
)

# This function deals with some too-big-for-R numbers that show up in API specs.
# I wrap yaml::read_yaml to deal with this, URL encoding of the URL, and the
# readLines warning.
#
# TODO: Consider integrating this into tibblify. We'd need bit64 in Suggests if
# so.
as_int_or_int64 <- function(x) {
  tryCatch(
    {
      as.integer(x)
    },
    warning = function(w) {
      if (grepl("integer range", conditionMessage(w))) {
        bit64::as.integer64(x)
      } else {
        warning(w) # Re-throw other warnings
      }
    }
  )
}

# It also isn't our problem if something is wrong with the YAML itself.
safe_read_yaml <- purrr::possibly(
  function(url) {
    url <- utils::URLencode(url)
    yaml::read_yaml(
      url,
      readLines.warn = FALSE,
      handlers = list(int = as_int_or_int64)
    )
  },
  otherwise = list("bad spec")
)

# The most common (only?) failure I'm seeing is some sort of recursion in spec
# resolution. We'll try to parse the spec in a separate process, and timeout if
# it runs too long (rather than letting it get stuck in the loop). I ran
# experiments and found that I stopped getting new successes after 10 seconds.
make_limited_parse <- function(timeout = 10) {
  force(timeout)
  function(...) {
    callr::r(
      tibblify::parse_openapi_spec,
      args = list(...),
      package = TRUE,
      timeout = timeout
    )
  }
}

make_check_can_parse <- function(timeout = 10) {
  force(timeout)
  limited_parse <- make_limited_parse(timeout)
  force(limited_parse)
  safe_parse <- purrr::possibly(limited_parse, otherwise = NULL)
  force(safe_parse)
  function(spec) {
    !is.null(safe_parse(spec))
  }
}

check_can_parse <- make_check_can_parse(30)

apisguru_apis <- yaml::read_yaml(
  "https://api.apis.guru/v2/list.json",
  readLines.warn = FALSE
) |>
  tibblify::tibblify(unspecified = "list") |>
  dplyr::select("name" = ".names", "preferred", "versions") |>
  tidyr::unnest("versions") |>
  dplyr::filter(
    .data$preferred == .data$.names,
    as.numeric_version(.data$openapiVer) >= as.numeric_version("3.0.0")
  ) |>
  dplyr::select("name", "updated", "swaggerUrl") |>
  dplyr::mutate(
    url_is_valid = purrr::map_lgl(
      .data$swaggerUrl,
      check_url_exists,
      .progress = "Checking URLs."
    )
  ) |>
  dplyr::filter(.data$url_is_valid) |>
  dplyr::select(-"url_is_valid") |>
  dplyr::mutate(
    spec = purrr::map(
      .data$swaggerUrl,
      safe_read_yaml,
      .progress = "Reading specs."
    )
  ) |>
  dplyr::filter(lengths(.data$spec) > 1) |>
  dplyr::mutate(
    can_parse = purrr::map_lgl(
      .data$spec,
      check_can_parse,
      .progress = "Checking whether tibblify can parse_openapi_spec."
    )
  )

saveRDS(apisguru_apis, testthat::test_path("fixtures", "apisguru_apis.rds"))

apisguru_apis |>
  dplyr::filter(can_parse)

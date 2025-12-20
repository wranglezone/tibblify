## I used this to systematically check all of the guru specs from
## exhaustive-guru.R to figure out what failed and why.

pkgload::load_all()
apisguru_apis <- readRDS(testthat::test_path("fixtures", "apisguru_apis.rds"))
bad_apis <- dplyr::filter(
  apisguru_apis,
  !can_parse,
  #196 Incompatible types ----
  !(name %in%
    c(
      "box.com",
      "digitalocean.com",
      "ideal-postcodes.co.uk",
      "influxdata.com",
      "lgtm.com",
      "pandascore.co",
      "soundcloud.com",
      "wiremock.org:admin",
      "youneedabudget.com"
    )),
  #198 Nested trees/loops ----
  #
  # Note: Sometimes these self-resolve but fail, other times they get stuck. I
  # suspect this is 2-3 bugs.
  !stringr::str_detect(name, "amazonaws"),
  !stringr::str_detect(name, "apideck"),
  !stringr::str_detect(name, "googleapis.com"),
  !stringr::str_detect(name, "microsoft.com"),
  !stringr::str_detect(name, "parliament.uk"),
  !stringr::str_detect(name, "seldon.local"),
  !(name %in%
    c(
      "api.video",
      "api2cart.com",
      "atlassian.com:jira",
      "bigoven.com",
      "britbox.co.uk",
      "bungie.net",
      "bunq.com",
      "canada-holidays.ca",
      "clickmeter.com",
      "configcat.com",
      "corrently.io",
      "daniweb.com",
      "dataflowkit.com",
      "dnd5eapi.co",
      "dracoon.team",
      "envoice.in",
      "groundhog-day.com",
      "id4i.de",
      "jellyfin.local",
      "just-eat.co.uk",
      "keycloak.local",
      "magento.com",
      "mastodon.local",
      "meshery.local",
      "noosh.com",
      "ote-godaddy.com:domains",
      "oxforddictionaries.com",
      "patientview.org",
      "pocketsmith.com",
      "presalytics.io:ooxml",
      "rudder.example.local",
      "sinao.app",
      "smart-me.com",
      "squareup.com",
      "stream-io-api.com",
      "stripe.com",
      "telegram.org",
      "tfl.gov.uk",
      "tl-api.azurewebsites.net",
      "truora.com",
      "tsapi.net",
      "vectara.io",
      "webflow.com",
      "xero.com:xero_accounting"
    )),
  #199 `x-codegen-contextRoot` ----
  !(name %in%
    c(
      "apicurio.local:registry"
    )),
  #201 links in response objects ----
  !(name %in%
    c(
      "cpy.re:peertube",
      "gambitcomm.local:mimic",
      "graphhopper.com",
      "linode.com",
      "listennotes.com",
      "surevoip.co.uk"
    )),
  #202: NULL example ----
  !(name %in%
    c(
      "personio.de:personnel",
      "rebilly.com",
      "viator.com"
    )),
  # Other/uncharacterized ----
  #
  # Some of these have at least one `type` along the lines of c("array",
  # "null"), but I don't think that's the only problem.
  !stringr::str_detect(name, "codat"),
  !(name %in%
    c(
      "discourse.local",
      "mist.com",
      "nic.at:domainfinder",
      "vercel.com"
    )),
  # Resolved ----
  !(name %in%
    c(
      "bbc.com", # Slow (about 55s), but works.
      character()
    ))
)
# Run ----
i <- 0L
i <- i + 1L
spec_url <- bad_apis$swaggerUrl[[i]]
spec_name <- bad_apis$name[[i]]
cli::cli_inform("Spec {i} | {spec_name} | {spec_url}")
file <- bad_apis$spec[[i]]
parse_openapi_spec(file)

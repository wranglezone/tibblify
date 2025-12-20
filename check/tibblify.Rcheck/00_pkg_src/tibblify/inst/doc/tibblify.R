## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------

## -----------------------------------------------------------------------------
library(tibblify)

gh_users_small <- purrr::map(gh_users, ~ .x[c("followers", "login", "url", "name", "location", "email", "public_gists")])

names(gh_users_small[[1]])

## -----------------------------------------------------------------------------
tibblify(gh_users_small)

## -----------------------------------------------------------------------------
guess_tspec(gh_users_small)

## -----------------------------------------------------------------------------
spec <- tspec_df(
  login_name = tib_chr("login"),
  tib_chr("name"),
  tib_int("public_gists")
)

tibblify(gh_users_small, spec)

## -----------------------------------------------------------------------------
tibblify(
  list(
    list(id = 1, name = "Peter"),
    list(id = 2, name = "Lilly")
  ),
  tspec_df(
    tib_int("id"),
    tib_chr("name")
  )
)

## -----------------------------------------------------------------------------
x <- list(
  list(id = 1, duration = vctrs::new_duration(100)),
  list(id = 2, duration = vctrs::new_duration(200))
)
x

## -----------------------------------------------------------------------------
tibblify(
  x,
  tspec_df(
    tib_int("id"),
    tib_scalar("duration", ptype = vctrs::new_duration())
  )
)

## -----------------------------------------------------------------------------
x <- list(
  list(id = 1, children = c("Peter", "Lilly")),
  list(id = 2, children = "James"),
  list(id = 3, children = c("Emma", "Noah", "Charlotte"))
)

tibblify(
  x,
  tspec_df(
    tib_int("id"),
    tib_chr_vec("children")
  )
)

## -----------------------------------------------------------------------------
gh_repos_small <- purrr::map(gh_repos, ~ .x[c("id", "name", "owner")])
gh_repos_small <- purrr::map(
  gh_repos_small,
  function(repo) {
    repo$owner <- repo$owner[c("login", "id", "url")]
    repo
  }
)

gh_repos_small[[1]]

## -----------------------------------------------------------------------------
spec <- guess_tspec(gh_repos_small)
spec

## -----------------------------------------------------------------------------
tibblify(gh_repos_small, spec)

## -----------------------------------------------------------------------------
spec2 <- tspec_df(
  id = tib_int("id"),
  name = tib_chr("name"),
  owner_id = tib_int(c("owner", "id")),
  owner_login = tib_chr(c("owner", "login"))
)
spec2

tibblify(gh_repos_small, spec2)

## ----error=TRUE---------------------------------------------------------------
try({
x <- list(
  list(x = 1, y = "a"),
  list(x = 2)
)

spec <- tspec_df(
  x = tib_int("x"),
  y = tib_chr("y")
)

tibblify(x, spec)
})

## -----------------------------------------------------------------------------
spec <- tspec_df(
  x = tib_int("x"),
  y = tib_chr("y", required = FALSE)
)

tibblify(x, spec)

## -----------------------------------------------------------------------------
spec <- tspec_df(
  x = tib_int("x"),
  y = tib_chr("y", required = FALSE, fill = "missing")
)

tibblify(x, spec)

## -----------------------------------------------------------------------------
api_output <- list(
  status = "success",
  requested_at = "2021-10-26 09:17:12",
  data = list(
    list(x = 1),
    list(x = 2)
  )
)

## -----------------------------------------------------------------------------
row_spec <- tspec_row(
  status = tib_chr("status"),
  data = tib_df(
    "data",
    x = tib_int("x")
  )
)

api_output_df <- tibblify(api_output, row_spec)
api_output_df

## -----------------------------------------------------------------------------
object_spec <- tspec_object(
  status = tib_chr("status"),
  data = tib_df(
    "data",
    x = tib_int("x")
  )
)

api_output_list <- tibblify(api_output, object_spec)
api_output_list

## -----------------------------------------------------------------------------
api_output_list$data


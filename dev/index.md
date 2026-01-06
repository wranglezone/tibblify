# tibblify

The goal of tibblify is to provide an easy way to convert a nested list
into a tibble.

## Installation

Install the released version of tibblify from
[CRAN](https://cran.r-project.org/):

``` r
install.packages("tibblify")
```

Install the development version of tibblify from
[GitHub](https://github.com/):

``` r
# install.packages("pak")
pak::pak("wranglezone/tibblify")
```

## Usage

To illustrate how
[`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md)
works, we’ll start with a list containing information about four GitHub
users.

``` r
library(tibblify)

gh_users_small <- purrr::map(gh_users, ~ .x[c("followers", "login", "url", "name", "location", "email", "public_gists")])

names(gh_users_small[[1]])
#> [1] "followers"    "login"        "url"          "name"         "location"    
#> [6] "email"        "public_gists"
```

We can rectangle `gh_users_small` automatically with
[`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md):

``` r
tibblify(gh_users_small)
#> The spec contains 1 unspecified field:
#> • email
#> # A tibble: 4 × 7
#>   followers login      url                    name  location email  public_gists
#>       <int> <chr>      <chr>                  <chr> <chr>    <list>        <int>
#> 1       780 jennybc    https://api.github.co… Jenn… Vancouv… <NULL>           54
#> 2      3958 jtleek     https://api.github.co… Jeff… Baltimo… <NULL>           12
#> 3       115 juliasilge https://api.github.co… Juli… Salt La… <NULL>            4
#> 4       213 leeper     https://api.github.co… Thom… London,… <NULL>           46
```

We can avoid the note about the unspecified field by formally providing
a spec starting with
[`guess_tspec()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md):

``` r
spec <- guess_tspec(gh_users_small, inform_unspecified = FALSE)
# Drop the unused email specification.
spec$fields$email <- NULL
tibblify(gh_users_small, spec = spec)
#> # A tibble: 4 × 6
#>   followers login      url                           name  location public_gists
#>       <int> <chr>      <chr>                         <chr> <chr>           <int>
#> 1       780 jennybc    https://api.github.com/users… Jenn… Vancouv…           54
#> 2      3958 jtleek     https://api.github.com/users… Jeff… Baltimo…           12
#> 3       115 juliasilge https://api.github.com/users… Juli… Salt La…            4
#> 4       213 leeper     https://api.github.com/users… Thom… London,…           46
```

Learn more in
[`vignette("tibblify")`](https://tibblify.wrangle.zone/dev/articles/tibblify.md).

## Similar packages

- [jsonlite](https://cran.r-project.org/package=jsonlite):
  [`jsonlite::fromJSON()`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)
  is excellent for parsing JSON, but `tibblify` allows for strict
  specifications and can be faster for complex nested lists.
- [tidyr](https://tidyr.tidyverse.org/): `tidyr::hoist()` and
  `tidyr::unnest_longer()` allow for step-by-step rectangling.
  `tibblify` aims to rectangle the data in a single step based on a
  schema.
- [rrapply](https://jorischau.github.io/rrapply/): Provides extended
  functionality for applying functions to nested lists, and can also be
  used to melt or prune lists.
- [tidyjson](https://github.com/colearendt/tidyjson): Offers a grammar
  for manipulating JSON data.

## Code of Conduct

Please note that the tibblify project is released with a [Contributor
Code of Conduct](https://tibblify.wrangle.zone/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.

# tibblify

``` r
library(tibblify)
library(purrr)
library(vctrs)
```

## Introduction

With
[`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md)
you can rectangle deeply nested lists into a tidy tibble. These lists
might come from an API in the form of JSON or from scraping XML.

## Example

Let’s start with `gh_users`, which is a list containing information
about four GitHub users. We’ll select a subset of columns to keep the
example relatively simple.

``` r
gh_users_small <- purrr::map(gh_users, ~ .x[c("followers", "login", "url", "name", "location", "email", "public_gists")])

names(gh_users_small[[1]])
#> [1] "followers"    "login"        "url"          "name"         "location"    
#> [6] "email"        "public_gists"
```

We can quickly rectangle `gh_users_small` with
[`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md).

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

We can now look at the specification
[`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md)
used for rectangling.

``` r
guess_tspec(gh_users_small)
#> The spec contains 1 unspecified field:
#> • email
#> tspec_df(
#>   tib_int("followers"),
#>   tib_chr("login"),
#>   tib_chr("url"),
#>   tib_chr("name"),
#>   tib_chr("location"),
#>   tib_unspecified("email"),
#>   tib_int("public_gists"),
#> )
```

If we are only interested in some of the fields we can easily adapt the
specification.

``` r
spec <- tspec_df(
  login_name = tib_chr("login"),
  tib_chr("name"),
  tib_int("public_gists")
)

tibblify(gh_users_small, spec)
#> # A tibble: 4 × 3
#>   login_name name                   public_gists
#>   <chr>      <chr>                         <int>
#> 1 jennybc    Jennifer (Jenny) Bryan           54
#> 2 jtleek     Jeff L.                          12
#> 3 juliasilge Julia Silge                       4
#> 4 leeper     Thomas J. Leeper                 46
```

## Objects

We refer to lists like `gh_users_small` as *collections*, and each
element of that list is an *object*. Objects and collections are the
typical input for
[`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md).

Basically, an *object* is something that can be converted to a one-row
tibble. This boils down to a condition on the names of the object:

1.  The `object` must have names (the `names` attribute must not be
    `NULL`).
2.  Every element must be named (no name can be `NA` or `""`).
3.  The names must be unique.

In other words, the names must fulfill
`vctrs::vec_as_names(names, repair = "check_unique")`. The name-value
pairs of an object are the *fields*.

For example `list(x = 1, y = "a")` is an object with the fields `(x, 1)`
and `(y, "a")` but `list(1, z = 3)` is not an object because it is not
fully named.

A *collection* is a list of similar objects so that the fields can
become the columns in a tibble.

## Specification

Providing an explicit specification has several advantages:

1.  You can ensure type and shape stability of the resulting tibble in
    automated scripts.
2.  You can give the columns names that are different than their names
    in the source collection.
3.  You can parse only the fields you need (and ignore any others).
4.  You can specify what happens if a value is missing.

To create a specification for a collection, use
[`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md).
Describe the columns of the output tibble with the `tib_*()` functions.
The `tib_*()` functions describe the path to the field to extract and
the output type of the field. Throughout these functions, we use the
concept of `ptype` (prototype) as used in the {vctrs} package (see
[`vignette("type-size", package = "vctrs")`](https://vctrs.r-lib.org/articles/type-size.html)).

There are five main types of `tib_*()` functions:

- `tib_scalar(ptype)`: A length-one vector with type `ptype`. The result
  is a column of that type.
- `tib_vector(ptype)`: A vector of arbitrary length with type `ptype`.
  The result is a list column, with each row containing a vector of that
  type.
- [`tib_variant()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md):
  A vector of arbitrary length and type. The result is a list column,
  with each row containing a list. You should rarely need this function.
- `tib_row(...)`: An object with the fields `...`. The result is a
  tibble column, with each row containing the specified one-row tibble.
- `tib_df(...)`: A collection where the objects have the fields `...`.
  The result is a tibble column, with each row containing a tibble.

There are also two other `tib_*()` functions for special cases:

- [`tib_recursive()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md):
  A collection where objects can themselves be collections of the same
  structure, such as a directory tree. The result is a tibble column,
  with each row containing a tibble of the same structure (until `NULL`
  is reached, terminating recursion).
- [`tib_unspecified()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md):
  An unspecified field where the type and shape is not known in advance.
  The `unspecified` argument of
  [`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md)
  controls how such fields are handled.

For convenience there are shortcuts for
[`tib_scalar()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
and
[`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
for the most common prototypes:

- [`logical()`](https://rdrr.io/r/base/logical.html):
  [`tib_lgl()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  and
  [`tib_lgl_vec()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
- [`integer()`](https://rdrr.io/r/base/integer.html):
  [`tib_int()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  and
  [`tib_int_vec()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
- [`double()`](https://rdrr.io/r/base/double.html):
  [`tib_dbl()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  and
  [`tib_dbl_vec()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
- [`character()`](https://rdrr.io/r/base/character.html):
  [`tib_chr()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  and
  [`tib_chr_vec()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
- `Date`:
  [`tib_date()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  and
  [`tib_date_vec()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
- `Date` encoded as character:
  [`tib_chr_date()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  and
  [`tib_chr_date_vec()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)

### Scalar Elements

Scalar elements are the most common case and result in a normal vector
column.

``` r
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
#> # A tibble: 2 × 2
#>      id name 
#>   <int> <chr>
#> 1     1 Peter
#> 2     2 Lilly
```

With
[`tib_scalar()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md),
you can also provide your own prototype for column types not included in
our shortcuts. For example, let’s say you have a list with durations
(objects with class “difftime”).

``` r
x <- list(
  list(id = 1, duration = vctrs::new_duration(100)),
  list(id = 2, duration = vctrs::new_duration(200))
)
x
#> [[1]]
#> [[1]]$id
#> [1] 1
#> 
#> [[1]]$duration
#> Time difference of 100 secs
#> 
#> 
#> [[2]]
#> [[2]]$id
#> [1] 2
#> 
#> [[2]]$duration
#> Time difference of 200 secs
```

Use
[`tib_scalar()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
with
[`vctrs::new_duration()`](https://vctrs.r-lib.org/reference/new_date.html)
to specify the duration `ptype`.

``` r
tibblify(
  x,
  tspec_df(
    tib_int("id"),
    tib_scalar("duration", .ptype = vctrs::new_duration())
  )
)
#> # A tibble: 2 × 2
#>      id duration
#>   <int> <drtn>  
#> 1     1 100 secs
#> 2     2 200 secs
```

### Vector Elements

If an element does not always have size one then it is a vector element.
If it still always has the same type `ptype` then it produces a list
column with elements of `ptype`.

``` r
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
#> # A tibble: 3 × 2
#>      id    children
#>   <int> <list<chr>>
#> 1     1         [2]
#> 2     2         [1]
#> 3     3         [3]
```

You can use
[`tidyr::unnest()`](https://tidyr.tidyverse.org/reference/nest.html) or
[`tidyr::unnest_longer()`](https://tidyr.tidyverse.org/reference/hoist.html)
to flatten these columns to regular columns.

### Object Elements

In `gh_repos_small`, the field `owner` is an object itself.

``` r
gh_repos_small <- purrr::map(gh_repos, ~ .x[c("id", "name", "owner")])
gh_repos_small <- purrr::map(
  gh_repos_small,
  function(repo) {
    repo$owner <- repo$owner[c("login", "id", "url")]
    repo
  }
)

gh_repos_small[[1]]
#> $id
#> [1] 61160198
#> 
#> $name
#> [1] "after"
#> 
#> $owner
#> $owner$login
#> [1] "gaborcsardi"
#> 
#> $owner$id
#> [1] 660288
#> 
#> $owner$url
#> [1] "https://api.github.com/users/gaborcsardi"
```

The specification to extract it uses
[`tib_row()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

``` r
spec <- guess_tspec(gh_repos_small)
spec
#> tspec_df(
#>   tib_int("id"),
#>   tib_chr("name"),
#>   tib_row(
#>     "owner",
#>     tib_chr("login"),
#>     tib_int("id"),
#>     tib_chr("url"),
#>   ),
#> )
```

This specification results in a tibble column.

``` r
tibblify(gh_repos_small, spec)
#> # A tibble: 30 × 3
#>          id name        owner$login    $id $url                                 
#>       <int> <chr>       <chr>        <int> <chr>                                
#>  1 61160198 after       gaborcsardi 660288 https://api.github.com/users/gaborcs…
#>  2 40500181 argufy      gaborcsardi 660288 https://api.github.com/users/gaborcs…
#>  3 36442442 ask         gaborcsardi 660288 https://api.github.com/users/gaborcs…
#>  4 34924886 baseimports gaborcsardi 660288 https://api.github.com/users/gaborcs…
#>  5 61620661 citest      gaborcsardi 660288 https://api.github.com/users/gaborcs…
#>  6 33907457 clisymbols  gaborcsardi 660288 https://api.github.com/users/gaborcs…
#>  7 37236467 cmaker      gaborcsardi 660288 https://api.github.com/users/gaborcs…
#>  8 67959624 cmark       gaborcsardi 660288 https://api.github.com/users/gaborcs…
#>  9 63152619 conditions  gaborcsardi 660288 https://api.github.com/users/gaborcs…
#> 10 24343686 crayon      gaborcsardi 660288 https://api.github.com/users/gaborcs…
#> # ℹ 20 more rows
```

If you don’t like the tibble column you can unpack it with
`tidyr::unpack()`. Alternatively, if you only want to extract some of
the fields in `owner` you can use a character vector path.

``` r
spec2 <- tspec_df(
  id = tib_int("id"),
  name = tib_chr("name"),
  owner_id = tib_int(c("owner", "id")), # "id" in "owner"
  owner_login = tib_chr(c("owner", "login")) # "login" in "owner"
)
spec2
#> tspec_df(
#>   tib_int("id"),
#>   tib_chr("name"),
#>   owner_id = tib_int(c("owner", "id")),
#>   owner_login = tib_chr(c("owner", "login")),
#> )

tibblify(gh_repos_small, spec2)
#> # A tibble: 30 × 4
#>          id name        owner_id owner_login
#>       <int> <chr>          <int> <chr>      
#>  1 61160198 after         660288 gaborcsardi
#>  2 40500181 argufy        660288 gaborcsardi
#>  3 36442442 ask           660288 gaborcsardi
#>  4 34924886 baseimports   660288 gaborcsardi
#>  5 61620661 citest        660288 gaborcsardi
#>  6 33907457 clisymbols    660288 gaborcsardi
#>  7 37236467 cmaker        660288 gaborcsardi
#>  8 67959624 cmark         660288 gaborcsardi
#>  9 63152619 conditions    660288 gaborcsardi
#> 10 24343686 crayon        660288 gaborcsardi
#> # ℹ 20 more rows
```

## Required and Optional Fields

Objects usually have some fields that always exist and some that are
optional. By default `tib_*()` requires that a field exists.

``` r
x <- list(
  list(x = 1, y = "a"),
  list(x = 2)
)

spec <- tspec_df(
  x = tib_int("x"),
  y = tib_chr("y")
)

tibblify(x, spec)
#> Error in `tibblify()`:
#> ! Field y is required but does not exist in `x[[2]]`.
#> ℹ Use `required = FALSE` if the field is optional.
```

You can mark a field as optional with the argument `.required = FALSE`.

``` r
spec <- tspec_df(
  x = tib_int("x"),
  y = tib_chr("y", .required = FALSE)
)

tibblify(x, spec)
#> # A tibble: 2 × 2
#>       x y    
#>   <int> <chr>
#> 1     1 a    
#> 2     2 NA
```

You can specify the value to use with the `.fill` argument.

``` r
spec <- tspec_df(
  x = tib_int("x"),
  y = tib_chr("y", .required = FALSE, .fill = "missing")
)

tibblify(x, spec)
#> # A tibble: 2 × 2
#>       x y      
#>   <int> <chr>  
#> 1     1 a      
#> 2     2 missing
```

## Converting a Single Object

To rectangle a single object you have two options:
[`tspec_object()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
which produces a list, or
[`tspec_row()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
which produces a tibble with one row.

It often makes more sense to convert such objects to a list. For example
a typical API response might be something like this.

``` r
api_output <- list(
  status = "success",
  requested_at = "2021-10-26 09:17:12",
  data = list(
    list(x = 1),
    list(x = 2)
  )
)
```

Use
[`tspec_row()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
to convert to a one-row tibble.

``` r
row_spec <- tspec_row(
  status = tib_chr("status"),
  data = tib_df(
    "data",
    x = tib_int("x")
  )
)

api_output_df <- tibblify(api_output, row_spec)
api_output_df
#> # A tibble: 1 × 2
#>   status                data
#>   <chr>   <list<tibble[,1]>>
#> 1 success            [2 × 1]
```

To access `data` one has to use `api_output_df$data[[1]]`, which is not
very nice. We can use
[`tspec_object()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
to simplify this situation.

``` r
object_spec <- tspec_object(
  status = tib_chr("status"),
  data = tib_df(
    "data",
    x = tib_int("x")
  )
)

api_output_list <- tibblify(api_output, object_spec)
api_output_list
#> $status
#> [1] "success"
#> 
#> $data
#> # A tibble: 2 × 1
#>       x
#>   <int>
#> 1     1
#> 2     2
```

Now accessing `data` does not require an extra subsetting step.

``` r
api_output_list$data # No [[1]] needed
#> # A tibble: 2 × 1
#>       x
#>   <int>
#> 1     1
#> 2     2
```

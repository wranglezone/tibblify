# Guess the `tibblify()` specification

`guess_tspec()` automatically dispatches to the other `guess_tspec_*()`
functions based on the shape of the input. If you are unhappy with its
output, calling a specific `guess_tspec_*()` function may yield better
results, or at least clearer error messages about why that type isn't
supported.

- Use `guess_tspec_df()` if the input is a data frame.

- Use `guess_tspec_object()` if the input is an object (such as a JSON
  object that has been read into R as a named list).

- Use `guess_tspec_object_list()` if the input is a list of objects
  (such as a JSON object that has been read into R as a list of named
  lists).

- Use `guess_tspec_list()` if the input object is a list but you aren't
  sure how it should be processed.

See `vignette("supported-structures)` for a discussion of the input
types supported by tibblify.

## Usage

``` r
guess_tspec(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  call = rlang::caller_env()
)

guess_tspec_df(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  call = rlang::current_call(),
  arg = rlang::caller_arg(x)
)

guess_tspec_list(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  arg = caller_arg(x),
  call = current_call()
)

guess_tspec_object(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  call = rlang::current_call()
)

guess_tspec_object_list(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  arg = caller_arg(x),
  call = current_call()
)
```

## Arguments

- x:

  (`list`) A nested list.

- ...:

  These dots are for future extensions and must be empty.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- simplify_list:

  (`logical(1)`) Should scalar lists be simplified to vectors?

- inform_unspecified:

  (`logical(1)`) Inform about fields whose type could not be determined?

- call:

  (`environment`) The environment to use for error messages.

- arg:

  (`character(1)`) An argument name. This name will be mentioned in
  error messages as the input that is at the origin of a problem.

## Value

A specification object that can used in
[`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md).

## Examples

``` r
guess_tspec(list(x = 1, y = "a"))
#> tspec_object(
#>   tib_dbl("x"),
#>   tib_chr("y"),
#> )
guess_tspec(list(list(x = 1), list(x = 2)))
#> tspec_df(
#>   tib_dbl("x"),
#> )

guess_tspec(gh_users)
#> The spec contains 1 unspecified field:
#> • email
#> tspec_df(
#>   tib_chr("login"),
#>   tib_int("id"),
#>   tib_chr("avatar_url"),
#>   tib_chr("gravatar_id"),
#>   tib_chr("url"),
#>   tib_chr("html_url"),
#>   tib_chr("followers_url"),
#>   tib_chr("following_url"),
#>   tib_chr("gists_url"),
#>   tib_chr("starred_url"),
#>   tib_chr("subscriptions_url"),
#>   tib_chr("organizations_url"),
#>   tib_chr("repos_url"),
#>   tib_chr("events_url"),
#>   tib_chr("received_events_url"),
#>   tib_chr("type"),
#>   tib_lgl("site_admin"),
#>   tib_chr("name"),
#>   tib_chr("company"),
#>   tib_chr("blog"),
#>   tib_chr("location"),
#>   tib_unspecified("email"),
#>   tib_lgl("hireable"),
#>   tib_chr("bio"),
#>   tib_int("public_repos"),
#>   tib_int("public_gists"),
#>   tib_int("followers"),
#>   tib_int("following"),
#>   tib_chr("created_at"),
#>   tib_chr("updated_at"),
#> )
```

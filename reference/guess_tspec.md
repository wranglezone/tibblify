# Guess the `tibblify()` Specification

Use `guess_tspec()` if you don't know the input type. Use
`guess_tspec_df()` if the input is a data frame or an object list. Use
`guess_tspec_objecte()` is the input is an object.

## Usage

``` r
guess_tspec(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  inform_unspecified = should_inform_unspecified(),
  call = rlang::current_call()
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

guess_tspec_object(
  x,
  ...,
  empty_list_unspecified = FALSE,
  simplify_list = FALSE,
  call = rlang::current_call()
)
```

## Arguments

- x:

  A nested list.

- ...:

  These dots are for future extensions and must be empty.

- empty_list_unspecified:

  Treat empty lists as unspecified?

- simplify_list:

  Should scalar lists be simplified to vectors?

- inform_unspecified:

  Inform about fields whose type could not be determined?

- call:

  The execution environment of a currently running function, e.g.
  `caller_env()`. The function will be mentioned in error messages as
  the source of the error. See the `call` argument of `abort()` for more
  information.

- arg:

  An argument name as a string. This argument will be mentioned in error
  messages as the input that is at the origin of a problem.

## Value

A specification object that can used in
[`tibblify()`](https://mgirlich.github.io/tibblify/reference/tibblify.md).

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

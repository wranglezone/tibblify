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

See
[`vignette("supported-structures")`](https://tibblify.wrangle.zone/dev/articles/supported-structures.md)
for a discussion of the input types supported by tibblify.

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

  (`list` or `data.frame`) A nested list or a data frame.

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

A specification object that can be used in
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
```

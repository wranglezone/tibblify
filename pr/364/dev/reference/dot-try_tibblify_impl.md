# Tibblify implementation with error handling

Tibblify implementation with error handling

## Usage

``` r
.try_tibblify_impl(x, spec, call = caller_env())
```

## Arguments

- x:

  (`list`) A nested list.

- spec:

  (`tspec`) A specification of how to convert `x`. Generated with
  [`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  [`tspec_row()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  [`tspec_object()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  [`tspec_recursive()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  or
  [`guess_tspec()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md).
  If `spec` is `NULL` (the default),
  `guess_tspec(x, inform_unspecified = TRUE)` will be used to guess the
  `spec`.

- call:

  (`environment`) The environment to use for error messages.

## Value

Either a tibble or a list, depending on the specification.

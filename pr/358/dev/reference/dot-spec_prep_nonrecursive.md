# Prepare a non-recursive tibblify specification

Prepare a non-recursive tibblify specification

## Usage

``` r
.spec_prep_nonrecursive(spec)
```

## Arguments

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

## Value

A prepared tibblify specification.

# Prepare a tibblify specification for tibblification

Prepare a tibblify specification for tibblification

## Usage

``` r
.spec_prep(spec)
```

## Arguments

- spec:

  (`tspec`) A specification of how to convert `x`. Generated with
  [`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  [`tspec_row()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  [`tspec_object()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  [`tspec_recursive()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  or (if `NULL`, the default),
  [`guess_tspec()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md).

## Value

A prepared tibblify specification.

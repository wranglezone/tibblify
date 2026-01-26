# Find unspecified fields

Find unspecified fields

## Usage

``` r
.get_unspecified_paths(spec)
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

A list of
[`tib_unspecified()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
objects and objects containing
[`tib_unspecified()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
objects.

# Replace unspecified fields in the specification

Replace unspecified fields in the specification

## Usage

``` r
.spec_replace_unspecified(spec, unspecified)
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

- unspecified:

  (`character(1)`) What to do with
  [`tib_unspecified()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  fields. Can be one of

  - `"error"`: Throw an error.

  - `"inform"`: Inform the user then parse as with
    [`tib_variant()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

  - `"drop"`: Do not parse these fields.

  - `"list"`: Parse unspecified fields into lists as with
    [`tib_variant()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

## Value

A modified tibblify specification.

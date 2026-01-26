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
  or (if `NULL`, the default),
  [`guess_tspec()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md).

- unspecified:

  (`character(1)`) What to do with unspecified fields. Can be one of

  - `"error"`: Throw an error.

  - `"inform"`: Inform the user.

  - `"drop"`: Do not parse these fields.

  - `"list"`: Parse an unspecified field into a list as with
    [`tib_variant()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

## Value

A modified tibblify specification.

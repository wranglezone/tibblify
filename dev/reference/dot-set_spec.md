# Set the tibblify specification attribute

Set the tibblify specification attribute

## Usage

``` r
.set_spec(x, spec)
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
  or (if `NULL`, the default),
  [`guess_tspec()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md).

## Value

The object `x` with the `tib_spec` attribute set.

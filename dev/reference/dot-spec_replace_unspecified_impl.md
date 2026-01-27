# Replace unspecified fields in the specification

Replace unspecified fields in the specification

## Usage

``` r
.spec_replace_unspecified_impl(spec_fields, unspecified)
```

## Arguments

- spec_fields:

  (`list`) Fields from spec\$fields (or a subset thereof).

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

A modified list of `tib_collector` objects.

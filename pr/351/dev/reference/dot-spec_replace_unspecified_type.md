# Replace tib_unspecified fields in the specification

Replace tib_unspecified fields in the specification

## Usage

``` r
.spec_replace_unspecified_type(field_spec, unspecified)
```

## Arguments

- field_spec:

  (`tib_collector`) A field specification.

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

A modified `tib_collector`.

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

  (`character(1)`) What to do with unspecified fields. Can be one of

  - `"error"`: Throw an error.

  - `"inform"`: Inform the user.

  - `"drop"`: Do not parse these fields.

  - `"list"`: Parse an unspecified field into a list as with
    [`tib_variant()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

## Value

A modified list of `tib_collector` objects.

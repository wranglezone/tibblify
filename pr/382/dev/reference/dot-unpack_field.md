# Unpack a single field

Unpack a single field

## Usage

``` r
.unpack_field(
  field_spec,
  recurse,
  name,
  names_sep,
  names_repair,
  names_clean,
  .call
)
```

## Arguments

- field_spec:

  (`tib_collector`) A tibblify field collector.

- recurse:

  (`logical(1)`) Should fields inside other fields be unpacked?

- name:

  (`character(1)`) The name of the field.

- names_sep:

  (`character(1)` or `NULL`) If `NULL`, the default, the inner names of
  fields are used. If a string, the outer and inner names are pasted
  together, separated by `names_sep`.

- names_repair:

  (`character(1)` or `function`) Passed to the `repair` argument of
  [`vctrs::vec_as_names()`](https://vctrs.r-lib.org/reference/vec_as_names.html)
  to check that the output data frame has valid names. Must be one of
  the following options:

  - `"unique"` (the default) or `"unique_quiet"`: make sure names are
    unique and not empty,

  - `"universal"` or `"universal_quiet"`: make the names unique and
    syntactic

  - `"check_unique"`: no name repair, but check they are unique,

  - a function: apply custom name repair.

- names_clean:

  (`function`) A one-argument function to clean names after repairing.
  For example use
  [`camel_case_to_snake_case()`](https://tibblify.wrangle.zone/dev/reference/unpack_tspec.md).

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`list`) A list of unpacked fields.

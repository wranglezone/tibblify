# Unpack and repair fields

Unpack and repair fields

## Usage

``` r
.unpack_fields(
  spec,
  fields,
  recurse,
  names_sep,
  names_repair,
  names_clean,
  .call = caller_env()
)
```

## Arguments

- spec:

  (`tspec`) A tibblify specification.

- fields:

  (`character` or `NULL`) The fields to unpack. If `fields` is `NULL`
  (default), all fields are unpacked.

- recurse:

  (`logical(1)`) Should fields inside other fields be unpacked?

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

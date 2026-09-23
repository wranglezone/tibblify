# Unchop and repair fields

Unchop and repair fields

## Usage

``` r
.unchop_fields(fields, names_repair, names_clean, .call = caller_env())
```

## Arguments

- fields:

  (`character` or `NULL`) The fields to unpack. If `fields` is `NULL`
  (default), all fields are unpacked.

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

(`list`) A list of unchopped and repaired fields.

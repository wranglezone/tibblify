# Combine various specified tib field types

Combine various specified tib field types

## Usage

``` r
.tib_combine_specified(tib_list, type, key, required, .call)
```

## Arguments

- tib_list:

  (`list`) A list of tib fields.

- type:

  (`character(1)`) The target tib type ("variant", "scalar", or
  "vector").

- key:

  (`character(1)`) The key of the field.

- required:

  (`logical(1)`) Whether the field is required.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`tib_variant`, `tib_scalar`, or `tib_vector`) A tibblify field
collector.

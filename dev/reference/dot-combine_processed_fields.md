# Combine processed simple and complex fields

Combine processed simple and complex fields

## Usage

``` r
.combine_processed_fields(
  spec_simple,
  spec_complex,
  coll_locations,
  is_sub,
  first_keys
)
```

## Arguments

- spec_simple:

  (`list`) Processed simple fields.

- spec_complex:

  (`list`) Processed complex fields.

- coll_locations:

  (`integer`) A numeric vector of locations.

- is_sub:

  (`logical`) Which fields are sub-fields?

- first_keys:

  (`character`) First keys of the complex fields.

## Value

A list with fields, locations, and keys.

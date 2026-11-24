# Describe duplicated keys as cli bullets

Describe duplicated keys as cli bullets

## Usage

``` r
.duplicate_keys_bullets(keys, locs, field_names)
```

## Arguments

- keys:

  (`list`) The duplicated keys, each a character vector.

- locs:

  (`list`) For each key, the locations in `field_names` that use it.

- field_names:

  (`character`) Names of the fields with duplicated keys.

## Value

(`character`) A named vector of cli bullets.

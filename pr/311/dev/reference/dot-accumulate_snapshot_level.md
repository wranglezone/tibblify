# Accumulate ancestor chains for a single snapshot level

Accumulate ancestor chains for a single snapshot level

## Usage

``` r
.accumulate_snapshot_level(cur_ancestors, snapshot, id_col, call)
```

## Arguments

- cur_ancestors:

  (`list`) A list of ancestor vectors for the current level, one per
  row.

- snapshot:

  (`list`) A single snapshot object with elements `data`, `ns`,
  `parent_ids`,

- id_col:

  (`character(1)`, `integer(1)`, or `symbol`) The column that uniquely
  identifies each observation.

- call:

  (`environment`) The environment to use for error messages.

## Value

A list of ancestor vectors for the next level, where each vector is the
ancestor vector of the parent row with the parent id appended.

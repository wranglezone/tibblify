# Combine vector tib fields

Combine vector tib fields

## Usage

``` r
.tib_combine_vector(tib_list, key, ptype, required, fill, transform, .call)
```

## Arguments

- tib_list:

  (`list`) A list of tib fields.

- key:

  (`character(1)`) The key of the field.

- ptype:

  (`vector(0)`) The target ptype.

- required:

  (`logical(1)`) Whether the field is required.

- fill:

  (`vector`) The fill value.

- transform:

  (`function` or `NULL`) The transform function.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`tib_vector`) A tibblify vector field collector.

# Check which fields to unpack

Check which fields to unpack

## Usage

``` r
.stabilize_unpack_cols(fields, spec, .call = caller_env())
```

## Arguments

- fields:

  (`character` or `NULL`) The fields to unpack.

- spec:

  (`tspec`) A tibblify specification.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`character`) The names of the fields to unpack.

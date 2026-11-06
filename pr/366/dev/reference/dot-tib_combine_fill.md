# Combine fill values from a list of tibs

Combine fill values from a list of tibs

## Usage

``` r
.tib_combine_fill(tib_list, type, ptype, .call)
```

## Arguments

- tib_list:

  (`list`) A list of tib fields.

- type:

  (`character(1)`) The target tib type (scalar, vector, etc.).

- ptype:

  (`vector(0)`) The target ptype.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`vector`) The combined fill value.

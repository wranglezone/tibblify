# Create a scalar or vector tib spec

Create a scalar or vector tib spec

## Usage

``` r
.tib_scalar_or_vector_spec(name, ptype, is_scalar)
```

## Arguments

- name:

  (`character(1)`) The name of the field.

- ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

- is_scalar:

  (`logical(1)`) If `TRUE`, return a
  [`tib_scalar()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  spec, otherwise a
  [`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  spec.

## Value

A
[`tib_scalar()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
or
[`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
spec.

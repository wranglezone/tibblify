# Cast a fill value using stbl-style friendlier coercion

Cast a fill value using stbl-style friendlier coercion

## Usage

``` r
.cast_fill(fill, ptype, ptype_arg = NULL, call = caller_env())
```

## Arguments

- fill:

  The fill value to coerce.

- ptype:

  The target prototype.

- ptype_arg:

  Argument name for the ptype, used in error messages.

- call:

  (`environment`) The environment to use for error messages.

## Value

The coerced fill value.

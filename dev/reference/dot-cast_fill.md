# Cast a fill value using stbl-style friendlier coercion

Mirrors the lossless-coercion rules applied by the C-level `add_value`
function: stbl's `to_*()` functions are used for plain atomic targets
(lgl/int/dbl/chr) and factor targets; all other targets fall back to
[`vctrs::vec_cast()`](https://vctrs.r-lib.org/reference/vec_cast.html).

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

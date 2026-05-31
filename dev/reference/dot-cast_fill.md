# Cast a fill value using stbl-style friendlier coercion

For plain atomic targets (lgl/int/dbl), use stbl's lossless coercion so
that e.g. `"1"` can fill an integer field. For all other targets
(including chr), falls back to
[`vctrs::vec_cast()`](https://vctrs.r-lib.org/reference/vec_cast.html).
Mirrors the behavior of the C-level `add_value` function.

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

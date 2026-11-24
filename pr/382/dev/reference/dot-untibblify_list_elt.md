# Untibblify a single list element

Untibblify a single list element

## Usage

``` r
.untibblify_list_elt(x, field_spec, call = caller_env())
```

## Arguments

- x:

  (`any`) The object to check.

- field_spec:

  (`tib_collector`) A tibblify field collector.

- call:

  (`environment`) The environment to use for error messages.

## Value

The converted element, or `x` unchanged if no conversion applies.

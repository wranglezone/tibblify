# Extract a nested (df, row, or recursive) field from a spec

Extract a nested (df, row, or recursive) field from a spec

## Usage

``` r
.get_nested_field(spec, name, .call = caller_env())
```

## Arguments

- spec:

  (`tspec` or `NULL`) A spec object describing the structure of `x`.

- name:

  (`character(1)`) The name of the field.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`tib_collector`) The field spec.

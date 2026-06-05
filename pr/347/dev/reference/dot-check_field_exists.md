# Check that a named field exists in a spec

Check that a named field exists in a spec

## Usage

``` r
.check_field_exists(spec, name, .call = caller_env())
```

## Arguments

- spec:

  (`tspec` or `NULL`) A spec object describing the structure of `x`.

- name:

  (`character(1)`) The name of the field.

- .call:

  (`environment`) The environment to use for error messages.

## Value

`NULL` (invisibly). Throws an error if the field does not exist.

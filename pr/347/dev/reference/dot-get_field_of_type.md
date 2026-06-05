# Check that a field exists in spec and extract it

Check that a field exists in spec and extract it

## Usage

``` r
.get_field_of_type(spec, name, type, fn_name, .call = caller_env())
```

## Arguments

- spec:

  (`tspec` or `NULL`) A spec object describing the structure of `x`.

- name:

  (`character(1)`) The name of the field.

- type:

  (`character(1)`) The expected field type string.

- fn_name:

  (`character(1)`) The name of the tib constructor function for use in
  error messages.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`tib_collector`) The field spec.

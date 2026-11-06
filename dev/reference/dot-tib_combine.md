# Combine a list of tib fields

Combine a list of tib fields

## Usage

``` r
.tib_combine(tib_list, name, .duplicate_keys, .call)
```

## Arguments

- tib_list:

  (`list`) A list of tib fields.

- name:

  (`character(1)`) The name of the field.

- .duplicate_keys:

  (`character(1)`) What to do if more than one field uses the same
  `.key`. Can be one of:

  - `"error"`: The default. Throw an error.

  - `"warn"`: Allow the duplicates, but warn.

  - `"allow"`: Allow the duplicates without checking.

  Keys are compared as a whole, so `c("a", "b")` and `c("a", "c")` are
  different keys.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`tib_collector`) A combined tibblify field collector.

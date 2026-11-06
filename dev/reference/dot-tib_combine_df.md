# Combine dataframe tib fields

Combine dataframe tib fields

## Usage

``` r
.tib_combine_df(tib_list, type, key, required, .duplicate_keys, .call)
```

## Arguments

- tib_list:

  (`list`) A list of tib fields.

- type:

  (`character(1)`) The target tib type ("row" or "df").

- key:

  (`character(1)`) The key of the field.

- required:

  (`logical(1)`) Whether the field is required.

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

(`tib_row` or `tib_df`) A tibblify dataframe field collector.

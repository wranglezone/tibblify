# Combine dataframe tib fields

Combine dataframe tib fields

## Usage

``` r
.tib_combine_df(tib_list, type, key, required, .call)
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

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`tib_row` or `tib_df`) A tibblify dataframe field collector.

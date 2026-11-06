# Apply column-to-spec conversion across a data frame

Apply column-to-spec conversion across a data frame

## Usage

``` r
.imap_col_to_spec(col_list, empty_list_unspecified)
```

## Arguments

- col_list:

  (`list`) A named list of columns, typically a data frame.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

## Value

A named list of tib field specifications.

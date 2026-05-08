# Apply column-to-spec conversion across a data frame

Apply column-to-spec conversion across a data frame

## Usage

``` r
.imap_col_to_spec(col_list, empty_list_unspecified, local_env)
```

## Arguments

- col_list:

  (`list`) A named list of columns, typically a data frame.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

A named list of tib field specifications.

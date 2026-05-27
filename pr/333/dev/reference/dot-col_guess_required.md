# Guess whether a field is required across a list of data frames

Guess whether a field is required across a list of data frames

## Usage

``` r
.col_guess_required(col_name, df_list)
```

## Arguments

- col_name:

  (`character(1)`) The column name to check.

- df_list:

  (`list`) A list of data frames.

## Value

(`logical(1)`) `TRUE` if `col_name` is present in every data frame,
`FALSE` otherwise.

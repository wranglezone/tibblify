# Guess whether each field is required in a df-typed list column

Guess whether each field is required in a df-typed list column

## Usage

``` r
.df_guess_required(fields_spec, col, ptype)
```

## Arguments

- fields_spec:

  (`list`) A named list of tib field specifications.

- col:

  (`list`) A list column whose elements are data frames.

## Value

`fields_spec` with `$required` updated for each field.

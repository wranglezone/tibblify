# Create a minimal tibble from a list

Create a minimal tibble from a list

## Usage

``` r
.fast_tibble(x, n = NULL)
```

## Arguments

- x:

  (`list`) A named list of equal-length vectors.

- n:

  (`integer(1)` or `NULL`) Number of rows; inferred from `x` if `NULL`.

## Value

(`tbl_df`) A tibble constructed directly from `x`.

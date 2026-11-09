# Determine which fields are required in an object list

Determine which fields are required in an object list

## Usage

``` r
.get_required(x, sample_size = 10000)
```

## Arguments

- x:

  (`any`) The object to check.

- sample_size:

  (`integer(1)`) Maximum number of records to sample when `x` is large.

## Value

A named logical vector indicating which fields are present in every
element of `x`.

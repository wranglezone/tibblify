# Read whether the empty list argument was used

Read whether the empty list argument was used

## Usage

``` r
.read_empty_list_argument(local_env)
```

## Arguments

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

`TRUE` if `local_env$empty_list_used` is `TRUE`, `FALSE` otherwise.

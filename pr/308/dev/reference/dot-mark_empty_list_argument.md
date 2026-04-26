# Mark that the empty list argument was used

Mark that the empty list argument was used

## Usage

``` r
.mark_empty_list_argument(used_empty_list_arg, local_env)
```

## Arguments

- used_empty_list_arg:

  (`logical(1)`) Whether any empty lists were dropped during ptype
  detection due to `empty_list_unspecified`.

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

Called for its side effect of setting `local_env$empty_list_used` to
`TRUE` when `used_empty_list_arg` is `TRUE`.

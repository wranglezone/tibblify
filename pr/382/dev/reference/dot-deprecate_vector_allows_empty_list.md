# Deprecate the `vector_allows_empty_list` arguments

Empty lists are now always accepted, so the arguments have no effect.

## Usage

``` r
.deprecate_vector_allows_empty_list(
  dotted,
  undotted,
  fn_name = rlang::call_name(rlang::caller_call()),
  user_env = rlang::caller_env(2)
)
```

## Arguments

- dotted, undotted:

  The values of `.vector_allows_empty_list` and
  `vector_allows_empty_list`.

## Value

`NULL`, invisibly.

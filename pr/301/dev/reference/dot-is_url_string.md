# Check whether input is an HTTP(S) URL string

Check whether input is an HTTP(S) URL string

## Usage

``` r
.is_url_string(x, arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  (`any`) The object to check.

- arg:

  (`character(1)`) An argument name. This name will be mentioned in
  error messages as the input that is at the origin of a problem.

- call:

  (`environment`) The environment to use for error messages.

## Value

(`logical(1)`) `TRUE` for scalar strings starting with `http://` or
`https://`, `FALSE` otherwise.

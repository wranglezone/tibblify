# Read an OpenAPI spec from a file, connection, or list

Read an OpenAPI spec from a file, connection, or list

## Usage

``` r
.read_spec(file, arg = caller_arg(file), call = caller_env())
```

## Arguments

- file:

  (`character(1)`) A path to a file, a connection, or literal data.

- arg:

  (`character(1)`) An argument name. This name will be mentioned in
  error messages as the input that is at the origin of a problem.

- call:

  (`environment`) The environment to use for error messages.

## Value

(`list`) The parsed spec.

# Parse a list of parameter objects from an OpenAPI spec

Parse a list of parameter objects from an OpenAPI spec

## Usage

``` r
.parse_parameters(parameters, openapi_spec)
```

## Arguments

- parameters:

  (`list` or `NULL`) A list of parameter objects from an OpenAPI spec,
  as defined in the [Parameter
  Object](https://spec.openapis.org/oas/v3.1.0#parameter-object).

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

(`tbl_df` or `NULL`) A tibble of parsed parameters, or `NULL` if
`parameters` is `NULL`.

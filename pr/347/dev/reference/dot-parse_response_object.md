# Parse a single response object from an OpenAPI spec

Parse a single response object from an OpenAPI spec

## Usage

``` r
.parse_response_object(response_object, openapi_spec)
```

## Arguments

- response_object:

  (`list`) A response object from an OpenAPI spec, as defined in the
  [Response
  Object](https://spec.openapis.org/oas/v3.1.0#response-object).

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

(`tbl_df`) A one-row tibble describing the response.

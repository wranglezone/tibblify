# Parse a request body object from an OpenAPI spec

Parse a request body object from an OpenAPI spec

## Usage

``` r
.parse_request_body(request_body, openapi_spec)
```

## Arguments

- request_body:

  (`list` or `NULL`) A request body object from an OpenAPI spec, as
  defined in the [Request Body
  Object](https://spec.openapis.org/oas/v3.1.0#request-body-object).

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

(`tspec_row` or `NULL`) A parsed request body row spec, or `NULL` if
`request_body` is `NULL`.

# Parse a responses object from an OpenAPI spec

Parse a responses object from an OpenAPI spec

## Usage

``` r
.parse_responses_object(responses_object, openapi_spec)
```

## Arguments

- responses_object:

  (`list`) A responses object from an OpenAPI spec, mapping status codes
  to response objects, as defined in the [Responses
  Object](https://spec.openapis.org/oas/v3.1.0#responses-object).

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

(`tbl_df`) A tibble of parsed response objects with a `status_code`
column.

# Parse an operation object from an OpenAPI spec

Parse an operation object from an OpenAPI spec

## Usage

``` r
.parse_operation_object(operation_object, openapi_spec)
```

## Arguments

- operation_object:

  (`list`) An operation object from an OpenAPI spec, as defined in the
  [Operation
  Object](https://spec.openapis.org/oas/v3.1.0#operation-object).

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

A one-row tibble describing the operation.

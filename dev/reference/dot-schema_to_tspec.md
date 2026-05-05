# Convert an OpenAPI schema to a tibblify tspec

Convert an OpenAPI schema to a tibblify tspec

## Usage

``` r
.schema_to_tspec(schema, openapi_spec)
```

## Arguments

- schema:

  (`list`) A JSON schema object, as defined in the [Schema
  Object](https://spec.openapis.org/oas/v3.1.0#schema-object), typically
  from `openapi_spec$components$schemas` or inline within the spec.

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

A tibblify spec (`tspec_row`, `tspec_df`, or a tib field).

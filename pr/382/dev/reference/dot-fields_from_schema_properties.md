# Extract tib fields from schema properties

Extract tib fields from schema properties

## Usage

``` r
.fields_from_schema_properties(schema, openapi_spec)
```

## Arguments

- schema:

  (`list`) A JSON schema object, as defined in the [Schema
  Object](https://spec.openapis.org/oas/v3.1.0#schema-object), typically
  from `openapi_spec$components$schemas` or inline within the spec.

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

A named list of tib field specs corresponding to the schema properties,
with required flags applied.

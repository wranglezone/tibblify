# Parse an object-type OpenAPI schema and create a tib field

Parse an object-type OpenAPI schema and create a tib field

## Usage

``` r
.tib_from_schema_object(schema, name, openapi_spec)
```

## Arguments

- schema:

  (`list`) A JSON schema object, as defined in the [Schema
  Object](https://spec.openapis.org/oas/v3.1.0#schema-object), typically
  from `openapi_spec$components$schemas` or inline within the spec.

- name:

  (`character(1)`) The name of the field.

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

A [`tib_row()`](https://tibblify.wrangle.zone/reference/tib_spec.md)
field spec with fields extracted from schema properties.

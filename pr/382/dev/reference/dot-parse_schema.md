# Parse an OpenAPI schema object into a tib field spec

Parse an OpenAPI schema object into a tib field spec

## Usage

``` r
.parse_schema(schema, name, openapi_spec)
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

A tib field spec corresponding to the schema type.

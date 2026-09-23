# Resolve `$ref` references in an OpenAPI schema object

Resolve `$ref` references in an OpenAPI schema object

## Usage

``` r
.openapi_resolve_reference(schema, openapi_spec)
```

## Arguments

- schema:

  (`list`) A JSON schema object, as defined in the [Schema
  Object](https://spec.openapis.org/oas/v3.1.0#schema-object), typically
  from `openapi_spec$components$schemas` or inline within the spec.

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

(`list`) The schema with all `$ref` references resolved.

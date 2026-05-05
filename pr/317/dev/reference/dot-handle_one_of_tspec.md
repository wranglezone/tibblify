# Handle a `oneOf` schema by combining sub-schemas into a tspec

Handle a `oneOf` schema by combining sub-schemas into a tspec

## Usage

``` r
.handle_one_of_tspec(schema, openapi_spec)
```

## Arguments

- schema:

  (`list`) A JSON schema object, as defined in the [Schema
  Object](https://spec.openapis.org/oas/v3.1.0#schema-object), typically
  from `openapi_spec$components$schemas` or inline within the spec.

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

A combined tspec, or `tib_variant("dummy")` if schemas are incompatible.

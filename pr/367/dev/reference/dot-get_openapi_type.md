# Determine the type of an OpenAPI schema object

Determine the type of an OpenAPI schema object

## Usage

``` r
.get_openapi_type(schema)
```

## Arguments

- schema:

  (`list`) A JSON schema object, as defined in the [Schema
  Object](https://spec.openapis.org/oas/v3.1.0#schema-object), typically
  from `openapi_spec$components$schemas` or inline within the spec.

## Value

(`character(1)`) The type string, one of `"object"`, `"array"`,
`"string"`, `"integer"`, `"boolean"`, `"number"`, or `"variant"`.

# Combine `oneOf` sub-schemas into a tspec

Combine `oneOf` sub-schemas into a tspec

## Usage

``` r
.tspec_from_one_of(schema, openapi_spec)
```

## Arguments

- schema:

  (`list`) A JSON schema object, as defined in the [Schema
  Object](https://spec.openapis.org/oas/v3.1.0#schema-object), typically
  from `openapi_spec$components$schemas` or inline within the spec.

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

A
[`tspec_combine()`](https://tibblify.wrangle.zone/reference/tspec_combine.md),
or `tib_variant("dummy")` if schemas are incompatible, or `NULL` if
`schema$oneOf` is empty.

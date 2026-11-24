# Choose and apply a tspec_from_schema_type function

Choose and apply a tspec_from_schema_type function

## Usage

``` r
.tspec_from_schema_type(schema, openapi_spec)
```

## Arguments

- schema:

  (`list`) A JSON schema object, as defined in the [Schema
  Object](https://spec.openapis.org/oas/v3.1.0#schema-object), typically
  from `openapi_spec$components$schemas` or inline within the spec.

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

A tibblify spec
([`tspec_row()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
[`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
or a tib field).

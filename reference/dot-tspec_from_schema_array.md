# Convert an array-type schema to a tibblify data frame spec

Convert an array-type schema to a tibblify data frame spec

## Usage

``` r
.tspec_from_schema_array(schema, openapi_spec)
```

## Arguments

- schema:

  (`list`) A JSON schema object, as defined in the [Schema
  Object](https://spec.openapis.org/oas/v3.1.0#schema-object), typically
  from `openapi_spec$components$schemas` or inline within the spec.

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

A [`tspec_df()`](https://tibblify.wrangle.zone/reference/tspec_df.md)
spec with fields extracted from the array items schema properties.

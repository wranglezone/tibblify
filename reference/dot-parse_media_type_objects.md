# Parse a named list of media type objects from an OpenAPI spec

Parse a named list of media type objects from an OpenAPI spec

## Usage

``` r
.parse_media_type_objects(media_type_objects, openapi_spec)
```

## Arguments

- media_type_objects:

  (`list`) A named list of media type objects from an OpenAPI spec.

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

(`tbl_df`) A tibble with `media_type` and `spec` columns.

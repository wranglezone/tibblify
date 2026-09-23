# Parse a path item object from an OpenAPI spec

Parse a path item object from an OpenAPI spec

## Usage

``` r
.parse_path_item_object(path_item_object, openapi_spec)
```

## Arguments

- path_item_object:

  (`list`) A path item object from an OpenAPI spec, as defined in the
  [Path Item
  Object](https://spec.openapis.org/oas/v3.1.0#path-item-object).

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

A tibble of parsed operations with a `global_parameters` column.

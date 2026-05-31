# Parse all path item objects from an OpenAPI spec

Parse all path item objects from an OpenAPI spec

## Usage

``` r
.parse_path_item_objects(openapi_spec)
```

## Arguments

- openapi_spec:

  (`list`) A parsed OpenAPI specification.

## Value

A named list of tibbles, one per path, containing parsed operations.

# Parse an OpenAPI spec

**\[experimental\]** Use `parse_openapi_spec()` to parse an [OpenAPI
spec](https://spec.openapis.org/oas/latest.html) or use
`parse_openapi_schema()` to parse an OpenAPI schema.

## Usage

``` r
parse_openapi_spec(file)

parse_openapi_schema(file)
```

## Arguments

- file:

  (`character(1)`) A path to a file, a connection, or literal data.

## Value

For `parse_openapi_spec()`, a nested data frame with the columns

- `endpoint` (`character`) Name of the endpoint.

- `operations` (`list`) A list of data frames describing that endpoint.
  See the [Paths Object in the OpenAPI
  spec](https://spec.openapis.org/oas/latest.html#paths-object) for
  details. All references (`$ref`) in the spec are resolved.

For `parse_openapi_schema()`, a tibblify spec.

## Examples

``` r
file <- '{
  "$schema": "http://json-schema.org/draft-04/schema",
  "title": "Starship",
  "description": "A vehicle.",
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "description": "The name of this vehicle. The common name, e.g. Sand Crawler."
    },
    "model": {
      "type": "string",
      "description": "The model or official name of this vehicle."
    },
    "url": {
      "type": "string",
      "format": "uri",
      "description": "The hypermedia URL of this resource."
    },
    "edited": {
      "type": "string",
      "format": "date-time",
      "description": "the ISO 8601 date format of the time this resource was edited."
    }
  },
  "required": [
    "name",
    "model",
    "edited"
  ]
}'
parse_openapi_schema(file)
#> tspec_row(
#>   tib_chr("name"),
#>   tib_chr("model"),
#>   tib_chr("url", .required = FALSE),
#>   tib_chr("edited"),
#> )

# Spec example from https://swagger.io/docs/specification/v3_0/basic-structure/
spec_path <- system.file(
  "examples", "openapi", "sample_api.yaml", package = "tibblify"
)
spec <- parse_openapi_spec(spec_path)
spec
#> # A tibble: 1 × 2
#>   endpoint operations       
#>   <chr>    <list>           
#> 1 /users   <tibble [1 × 11]>
```

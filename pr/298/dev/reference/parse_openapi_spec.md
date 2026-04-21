# Parse an OpenAPI spec

**\[experimental\]** Use `parse_openapi_spec()` to parse a [OpenAPI
spec](https://swagger.io/specification/) or use `parse_openapi_schema()`
to parse a OpenAPI schema.

## Usage

``` r
parse_openapi_spec(file)

parse_openapi_schema(file)
```

## Arguments

- file:

  Either a path to a file, a connection, or literal data (a single
  string).

## Value

For `parse_openapi_spec()` a data frame with the columns

- `endpoint` `<character>` Name of the endpoint.

- `operation` `<character>` The http operation; one of `"get"`, `"put"`,
  `"post"`, `"delete"`, `"options"`, `"head"`, `"patch"`, or `"trace"`.

- `status_code` `<character>` The http status code. May contain
  wildcards like `2xx` for all response codes between `200` and `299`.

- `media_type` `<character>` The media type.

- `spec` `<list>` A list of tibblify specifications.

For `parse_openapi_schema()` a tibblify spec.

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
#>   tib_chr("url", required = FALSE),
#>   tib_chr("edited"),
#> )
```

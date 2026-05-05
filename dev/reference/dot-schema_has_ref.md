# Check whether any nested list element has a `$ref` key

Short-circuiting check that avoids the expensive `names(unlist(schema))`
materialisation.

## Usage

``` r
.schema_has_ref(x)
```

## Arguments

- x:

  (`any`) The object to check.

## Value

(`logical(1)`) `TRUE` if any element has a `$ref` key.

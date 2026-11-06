# Create a tib collector

Create a tib collector

## Usage

``` r
.tib_collector(
  .key,
  .type,
  ...,
  .required = TRUE,
  .class = NULL,
  .transform = NULL,
  .elt_transform = NULL,
  .call = caller_env()
)
```

## Arguments

- .key:

  (`character`) The path of names to the field in the object.

- .type:

  (`character(1)`) The type of the collector.

- .required:

  (`logical(1)`) Throw an error if the field does not exist?

- .class:

  (`character` or `NULL`) Additional classes for the collector.

- .transform:

  (`function` or `NULL`) A function to apply to the whole vector after
  casting to `.ptype_inner`.

- .elt_transform:

  (`function` or `NULL`) A function to apply to each element before
  casting to `.ptype_inner`.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`tib_collector`) A tibblify collector.

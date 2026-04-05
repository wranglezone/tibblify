# Implementation of tib_scalar

Implementation of tib_scalar

## Usage

``` r
.tib_scalar_impl(
  .key,
  .ptype,
  ...,
  .required = TRUE,
  .fill = vctrs::vec_init(.ptype_inner),
  .ptype_inner = .ptype,
  .transform = NULL,
  .class = NULL,
  .call = caller_env()
)
```

## Arguments

- .key:

  (`character`) The path of names to the field in the object.

- .ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

- .required:

  (`logical(1)`) Throw an error if the field does not exist?

- .fill:

  (`vector` or `NULL`) Optionally, a value to use if the field does not
  exist.

- .ptype_inner:

  (`vector(0)`) A prototype of the input field.

- .transform:

  (`function` or `NULL`) A function to apply to the whole vector after
  casting to `.ptype_inner`.

- .class:

  (`character` or `NULL`) Additional classes for the collector.

- .call:

  (`environment`) The environment to use for error messages.

## Value

(`tib_scalar`) A tibblify scalar collector.

# Create a tibblify specification object

Create a tibblify specification object

## Usage

``` r
.tspec(
  .fields,
  .type,
  ...,
  .vector_allows_empty_list = FALSE,
  .error_call = caller_env()
)
```

## Arguments

- .fields:

  (`list`) A list of field specifications, typically created by
  `tib_*()`.

- .type:

  (`character(1)`) The type of specification being created (`"df"`,
  `"object"`, `"row"`, or `"recursive"`).

- ...:

  Additional specification attributes passed to
  [`rlang::list2()`](https://rlang.r-lib.org/reference/list2.html).

- .error_call:

  (`environment`) The environment to use for error messages.

## Value

A `tspec` object with class `tspec_<type>` and `tspec`.

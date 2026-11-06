# Create a tibblify specification object

Create a tibblify specification object

## Usage

``` r
.tspec(
  .fields,
  .type,
  ...,
  .duplicate_keys = "error",
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

- .duplicate_keys:

  (`character(1)`) What to do if more than one field uses the same
  `.key`. Can be one of:

  - `"error"`: The default. Throw an error.

  - `"warn"`: Allow the duplicates, but warn.

  - `"allow"`: Allow the duplicates without checking.

  Keys are compared as a whole, so `c("a", "b")` and `c("a", "c")` are
  different keys.

- .error_call:

  (`environment`) The environment to use for error messages.

## Value

A `tspec` object with class `tspec_<type>` and `tspec`.

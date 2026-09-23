# Expand an object list into a tib_df spec

Expand an object list into a tib_df spec

## Usage

``` r
.guess_object_field_spec_expand_fields_df(
  value,
  empty_list_unspecified,
  simplify_list,
  local_env,
  ...,
  tib_fn = tib_df
)
```

## Arguments

- value:

  (`list`) An object list whose fields will be guessed.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- simplify_list:

  (`logical(1)`) Should scalar lists be simplified to vectors?

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

- ...:

  Additional arguments passed to `tib_fn`.

- tib_fn:

  (`function`) The tib constructor to wrap the fields in; defaults to
  [`tib_df()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

## Value

A [`tib_df()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
spec, with `.names_to` set when `value` is named and non-empty.

# Expand an object list into a tib spec

Expand an object list into a tib spec

## Usage

``` r
.guess_object_field_spec_expand_fields(
  value,
  empty_list_unspecified,
  simplify_list,
  local_env,
  ...,
  tib_fn = tib_df,
  fields_fn = .guess_object_list_spec
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

  (`function`) The tib constructor to wrap the fields in (e.g.
  [`tib_df()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  or
  [`tib_row()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)).

- fields_fn:

  (`function`) The function used to generate field specs from `value`;
  defaults to
  [`.guess_object_list_spec()`](https://tibblify.wrangle.zone/dev/reference/dot-guess_object_list_spec.md).

## Value

A tib spec created by `tib_fn`.

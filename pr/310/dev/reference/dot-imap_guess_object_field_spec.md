# Map `.guess_object_field_spec` over a named list

Map `.guess_object_field_spec` over a named list

## Usage

``` r
.imap_guess_object_field_spec(
  x,
  empty_list_unspecified,
  simplify_list,
  local_env
)
```

## Arguments

- x:

  (`any`) The object to check.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- simplify_list:

  (`logical(1)`) Should scalar lists be simplified to vectors?

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

A named list of tib field specifications, one per element of `x`.

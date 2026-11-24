# Check that recursive children don't collide with other fields

The children are parsed into an extra column named `.children_to`, using
the key `.children`. If `.children_to` matches the name of another
field, that field would be silently replaced, so this is always an
error. If `.children` matches the key of another field, the same input
is processed twice, so it is handled like any other duplicated key.

## Usage

``` r
.check_recursive_children(
  fields,
  .children,
  .children_to,
  .duplicate_keys,
  .call = caller_env()
)
```

## Arguments

- fields:

  (`list`) A named list of field specifications.

- .children:

  (`character(1)`) The name of the field that contains the children.

- .children_to:

  (`character(1)`) The column name in which to store the children.

- .duplicate_keys:

  (`character(1)`) What to do if more than one field uses the same
  `.key`. Can be one of:

  - `"error"`: The default. Throw an error.

  - `"warn"`: Allow the duplicates, but warn.

  - `"allow"`: Allow the duplicates without checking.

  Keys are compared as a whole, so `c("a", "b")` and `c("a", "c")` are
  different keys.

- .call:

  (`environment`) The environment to use for error messages.

## Value

`fields`, invisibly.

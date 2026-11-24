# Check that no two fields use the same key

Keys are compared as a whole, so `c("a", "b")` and `c("a", "c")` are
different keys.

## Usage

``` r
.check_duplicate_keys(fields, .duplicate_keys, .call = caller_env())
```

## Arguments

- fields:

  (`list`) A named list of field specifications.

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

`fields`, invisibly. Throws an error or warning if keys are duplicated,
depending on `.duplicate_keys`.

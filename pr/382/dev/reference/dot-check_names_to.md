# Check that `.names_to` is valid for the given input form

Check that `.names_to` is valid for the given input form

## Usage

``` r
.check_names_to(.names_to, .input_form, .call = caller_env())
```

## Arguments

- .names_to:

  (`character(1)` or `NULL`) The name of the column in the output which
  will contain the names of top-level elements of the input named list.
  If `NULL`, the default, no name column is created.

- .input_form:

  (`character(1)`) The input form of data-frame-like lists. Can be one
  of:

  - `"rowmajor"`: The default. The input is a named list of rows.

  - `"colmajor"`: The input is a named list of columns.

- .call:

  (`environment`) The environment to use for error messages.

## Value

`NULL` (invisibly).

# Error for non-list vector element

Error for non-list vector element

## Usage

``` r
.stop_vector_non_list_element(path, input_form, x)
```

## Arguments

- path:

  (`list`) A path object encoded as a depth and a list of path elements.

- input_form:

  (`character(1)`) The input form string used in error messages.

- x:

  (`any`) The object to check.

## Value

`NULL` (invisibly). Called for its side effect of throwing an error.

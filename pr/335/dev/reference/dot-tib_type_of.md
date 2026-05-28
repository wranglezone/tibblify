# Determine the tib type of an object

Determine the tib type of an object

## Usage

``` r
.tib_type_of(x, name, other)
```

## Arguments

- x:

  (`any`) The object to check.

- name:

  (`character(1)`) The name of the field.

- other:

  (`logical(1)`) If `TRUE`, return `"other"` for unrecognized types
  rather than throwing an error.

## Value

One of `"df"`, `"list"`, `"vector"`, or `"other"`.

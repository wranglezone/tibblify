# Error for inconsistent colmajor field sizes

Error for inconsistent colmajor field sizes

## Usage

``` r
.stop_colmajor_wrong_size_element(path, size_act, path_exp, size_exp)
```

## Arguments

- path:

  (`list`) A path object encoded as a depth and a list of path elements.

- size_act:

  (`integer(1)`) The observed size of a field.

- path_exp:

  (`list`) The path of the field used as the reference in size mismatch
  errors.

- size_exp:

  (`integer(1)`) The expected size of a field.

## Value

Never returns; called for its side effect of throwing an error.

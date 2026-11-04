# Pad a character vector with a specified number of spaces

Pad a character vector with a specified number of spaces

## Usage

``` r
.pad(x, n)
```

## Arguments

- x:

  (`character`) A vector to pad.

- n:

  (`integer`) The number of spaces to use for padding.

## Value

A character vector with each element of `x` prepended with `n` spaces.
If an element of `x` contains newlines, each line will be prepended with
`n` spaces.

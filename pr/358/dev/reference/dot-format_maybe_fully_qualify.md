# Format a function name with optional full qualification

Format a function name with optional full qualification

## Usage

``` r
.format_maybe_fully_qualify(f_name, fully_qualify)
```

## Arguments

- f_name:

  (`character(1)`) The (possibly ANSI-colored) function name.

- fully_qualify:

  (`logical(1)`) Should `tib_*()` and `tspec_*()` calls be prefixed with
  `tibblify::`?

## Value

The formatted function name, potentially fully qualified.

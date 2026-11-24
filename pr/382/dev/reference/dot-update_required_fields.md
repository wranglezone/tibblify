# Update the required status of field specs

Update the required status of field specs

## Usage

``` r
.update_required_fields(fields, required)
```

## Arguments

- fields:

  (`list`) A named list of tib field specs.

- required:

  (`logical`) A named logical vector of required statuses, as returned
  by
  [`.get_required()`](https://tibblify.wrangle.zone/dev/reference/dot-get_required.md).

## Value

`fields` with the `$required` component of each spec updated.

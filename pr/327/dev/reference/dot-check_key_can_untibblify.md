# Check that a key is valid for untibblify

Validates that `key` is a length-1 character string by chaining
[`.check_key_length_1()`](https://tibblify.wrangle.zone/dev/reference/dot-check_key_length_1.md)
and
[`.check_key_is_character()`](https://tibblify.wrangle.zone/dev/reference/dot-check_key_is_character.md).

## Usage

``` r
.check_key_can_untibblify(key, call = caller_env())
```

## Arguments

- key:

  (`character`) The spec key to validate.

- call:

  (`environment`) The environment to use for error messages.

## Value

`key` if valid; otherwise throws an error.

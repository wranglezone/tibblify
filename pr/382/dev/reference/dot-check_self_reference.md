# Check that no element is its own parent

Check that no element is its own parent

## Usage

``` r
.check_self_reference(parent_ids, ids, call = caller_env())
```

## Arguments

- parent_ids:

  (`character` or `integer`) The parent ids to check.

- ids:

  (`character` or `integer`) The potential child ids to compare against.

- call:

  (`environment`) The environment to use for error messages.

## Value

The input `parent_ids`.

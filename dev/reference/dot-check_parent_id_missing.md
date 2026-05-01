# Check that parent ids aren't missing

Check that parent ids aren't missing

## Usage

``` r
.check_parent_id_missing(parent_ids, ids, call = caller_env())
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

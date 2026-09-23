# Guess field specs for an object list

Guess field specs for an object list

## Usage

``` r
.guess_object_list_spec(
  object_list,
  empty_list_unspecified,
  simplify_list,
  local_env
)
```

## Arguments

- object_list:

  (`list`) A list of named lists (objects) whose fields are to be
  guessed.

- empty_list_unspecified:

  (`logical(1)`) Treat empty lists as unspecified?

- simplify_list:

  (`logical(1)`) Should scalar lists be simplified to vectors?

- local_env:

  (`environment`) A local environment used to track state across
  recursive calls, such as whether empty lists were encountered.

## Value

A named list of tib field specs.

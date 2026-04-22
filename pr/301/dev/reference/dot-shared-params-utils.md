# Shared utils parameters

These parameters are shared by internal helper functions in `R/utils.R`.

## Arguments

- env:

  (`environment`) The environment used to evaluate glue fields in
  `message`.

- error_call:

  (`environment`) The call passed to
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  when rethrowing indexed errors.

- expr:

  (`any`) An expression to evaluate and return, with indexed errors
  wrapped.

- index:

  (`integer(1)`) A zero-based location in a path.

- input_form:

  (`character(1)`) The input form string used in error messages.

- message:

  (`character`) A cli message template.

- path:

  (`list`) A path object encoded as a depth and a list of path elements.

- path_exp:

  (`list`) The path of the field used as the reference in size mismatch
  errors.

- size_act:

  (`integer(1)`) The observed size of a field.

- size_exp:

  (`integer(1)`) The expected size of a field.

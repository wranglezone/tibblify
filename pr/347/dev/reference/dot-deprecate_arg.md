# Handle deprecated arguments

Handle deprecated arguments

## Usage

``` r
.deprecate_arg(
  good_arg,
  bad_arg,
  fn_name = rlang::call_name(rlang::caller_call()),
  pkg_version = "0.4.0",
  good_arg_name = rlang::caller_arg(good_arg),
  bad_arg_name = rlang::caller_arg(bad_arg),
  .call = rlang::caller_env(),
  user_env = rlang::caller_env(2)
)
```

## Arguments

- good_arg:

  (`any`) The value of the new argument.

- bad_arg:

  (`any`) The value of the deprecated argument.

- fn_name:

  (`character(1)`) Name of the calling function.

- pkg_version:

  (`character(1)`) Package version when deprecation occurred.

- good_arg_name:

  (`character(1)`) Name of the new argument.

- bad_arg_name:

  (`character(1)`) Name of the deprecated argument.

- .call:

  (`environment`) The environment to use for error messages.

- user_env:

  (`environment`) The environment from which the calling function is
  being called.

## Value

(`any`) The value to use.

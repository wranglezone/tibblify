---
name: r-code
description: Guide for writing R code in tibblify. Use when writing new functions, designing APIs, or reviewing/modifying existing R code.
---

# R code in tibblify

This skill covers how to design and write R functions in this package —
including signatures, API conventions, error handling, and common pitfalls.
For documenting functions, use the `document` skill. For tests, use the
`tdd-workflow` skill.

## tibblify API conventions

`tib_*()` collector functions use dot-prefixed arguments:

- `.key` — always the first argument; names the output column
- `.ptype` — prototype that determines the output type
- `.required` — whether the field must be present
- `.default` — value to use when the field is absent
- `.names_to` — captures element names into a column

New `tib_*()` functions must follow this scheme. Use dot-prefixed names for
any non-standard or spec-controlling parameters to stay consistent with the
existing family.

More broadly, dot-prefix is the package-wide convention for named parameters,
to avoid collisions with column names passed through `...`. The exceptions are
common positional parameters where collision is unlikely: `x`, `spec`, `name`,
and similar. When in doubt, use the dot prefix.

## General API design patterns

**Enum-like arguments** — declare choices as the default vector; resolve with
`arg_match0()` (exact match, no partial matching) at the top of the function:

```r
my_function <- function(x, .mode = c("fast", "safe")) {
  .mode <- arg_match0(.mode, c("fast", "safe"))
  # .mode is now guaranteed to be "fast" or "safe"
}
```

**`NULL` as "not provided"** — use `NULL` as the default for optional
arguments where there is no sensible scalar fallback; check with `is.null()`:

```r
my_function <- function(x, .names_to = NULL) {
  if (!is.null(.names_to)) { ... }
}
```

**`...` usage** — there are two distinct patterns in tibblify:

```r
# tspec_*(): collect named collector specs with list2()
tspec_custom <- function(...) {
  fields <- rlang::list2(...)
}

# tib_*(): dots reserved for future extensions — must be empty
tib_custom <- function(.key, ..., .required = TRUE) {
  rlang::check_dots_empty()
}
```

**S3 object construction** — build as a named list, set class explicitly:

```r
.my_object <- function(x, type) {
  out <- list(value = x, type = type)
  class(out) <- c(paste0("my_", type), "my_object")
  out
}
```

**`vctrs` for type-safe operations** — prefer `vctrs::vec_*` over base
equivalents for length, missing-value, and type checks:

```r
vctrs::vec_size(x)           # instead of length(x)
vctrs::vec_any_missing(x)    # instead of anyNA(x)
vctrs::vec_detect_missing(x) # instead of is.na(x)
```

**`.call` propagation in internal validators** — helpers that validate
arguments and may throw errors should accept and forward `.call`:

```r
.check_something <- function(x, .call = caller_env()) {
  if (bad(x)) cli::cli_abort("...", call = .call)
}

my_exported_fn <- function(x, .call = caller_env()) {
  .check_something(x, .call)
}
```

**Return tibbles, not data frames:**

```r
my_function <- function(x) {
  result |> tibble::as_tibble()
}
```

## Internal vs. exported functions

Export a function when:
- Users will call it directly
- Other packages may want to extend it
- It is a stable, intentional part of the API

Keep a function internal when:
- It is an implementation detail that may change
- It is only used within the package
- Exporting it would clutter the user-facing API

Internal helpers use a dot prefix (e.g. `.my_helper()`). Mark them with
`@keywords internal` and omit `@export`.

## Error handling

```r
cli::cli_abort(
  "Input {.arg x} cannot be empty.",
  "i" = "Provide a non-empty vector.",
  call = caller_env()
)
```

- Always pass `call = caller_env()` (or `call = .call` or `call = call`, if a
  call is passed to the function) so errors point to the user's call frame, not
  an internal helper.
- Use custom error classes for errors that callers may want to catch
  programmatically:
  ```r
  cli::cli_abort(
    "...",
    class = c("my_specific_error", "tibblify_error"),
    call = caller_env()
  )
  ```

## Common package mistakes

```r
# Never use library() inside package code
library(dplyr)          # Wrong
dplyr::filter(...)      # Right
# or `@importFrom dplyr filter` if used extensively

# Never modify global state without restoring it
options(my_option = TRUE)                    # Wrong
withr::local_options(list(my_option = TRUE)) # Right

# Use system.file() for package data, not hardcoded paths
read.csv("/home/user/data.csv")                          # Wrong
system.file("extdata", "data.csv", package = "tibblify") # Right
```

## Dependencies

### Use existing imports first

Packages that are already in `Imports` in @DESCRIPTION should be used in
preference to base R equivalents when relevant.

For example: prefer `purrr::map()` over `lapply()`, `rlang::is_*()` predicates
over `is.*()`, `vctrs::vec_*()` over base length/NA checks, and
`withr::local_*()` over manual `on.exit()` state management.

### When to add a new dependency

Add a dependency when it provides significant functionality that would be
complex or brittle to reimplement — date parsing, web requests, complex string
manipulation. Stick with base R when the solution is straightforward and a
dependency would add overhead for little gain.

tibblify's existing dependencies are intentional. **Adding a new dependency
requires explicit discussion with the developer.**

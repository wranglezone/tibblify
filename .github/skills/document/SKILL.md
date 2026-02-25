---
name: document
description: Document package functions. Use when asked to document functions.
---

# Document functions

*All* R functions in `R/` should be documented in {roxygen2} `#'` style, including internal/unexported functions.

- Run `air format .` then `devtools::document()` after changing any roxygen2 docs.
- Use sentence case for all headings.
- Files matching `R/import-standalone-*.R` are imported from other packages and have their own conventions. Do not modify their documentation.

## Parameter naming

Dot-prefix parameter names (`.key`, `.ptype`, `.required`) to avoid collisions with column names passed through `...`. This convention is being standardized package-wide; use it for new or updated functions even if the function doesn't currently use `...`.

Exceptions: common tidyverse-style parameters like `x`, `spec`, or `name` in contexts where collision is unlikely. When in doubt, use the dot prefix.

## Shared parameters

**Parameters used in more than one function** go in `R/aaa-shared_params.R` under `@name .shared-params`. Functions inherit them with `@inheritParams .shared-params`. See @R/aaa-shared_params.R for current definitions.

Multiple shared-params groups exist for different contexts (`.shared-params-tib`, `.shared-params-spec_prep`). File-level groups are appropriate when parameters are only shared within a file and closely related files.

Shared params blocks: alphabetize parameters, use `@name .shared-params` (with leading dot), include `@keywords internal`, end with `NULL`.

## Parameter documentation format

```r
#' @param .param_name (`TYPE`) One sentence description. Can include [cross_references()].
#'   Additional details on continuation lines if needed.
```

Function-specific `@param` definitions always appear *before* any `@inheritParams` lines. If all parameters are defined locally, omit `@inheritParams` entirely.

### Type notation

- "(`character`)" - Character vector
- "(`character(1)`)" - Single string
- "(`logical(1)`)" - Single logical
- "(`integer`)" - Integer vector
- "(`vector(0)`)" - A prototype (zero-length vector)
- "(`vector`)" - A vector of unspecified type
- "(`list`)" - List
- "(`function` or `NULL`)" - A function or NULL
- "(`tib_collector`)" - A class-specific type (use the actual class name)
- "(`any`)" - Any type

### Enumerated values

When a parameter takes one of a fixed set of values, document them with a bullet list:

```r
#' @param .input_form (`character(1)`) The structure of the input field. Can be
#'   one of:
#'   * `"vector"`: The field is a vector, e.g. `c(1, 2, 3)`.
#'   * `"scalar_list"`: The field is a list of scalars, e.g. `list(1, 2, 3)`.
```

## Returns

Use `@returns` (not `@return`). Include a type when it's informative:

```r
#' @returns A prepared tibblify specification.
#' @returns (`logical(1)`) `TRUE` if `x` is a `tib_scalar`.
#' @returns Either a tibble or a list, depending on the specification.
#' @returns `NULL` (invisibly).
```

## Exported functions

```r
#' Title in sentence case
#'
#' Description paragraph providing context and details.
#'
#' @param .param (`TYPE`) Description.
#' @inheritParams .shared-params
#'
#' @returns Description of return value.
#' @seealso [related_function()]
#' @export
#'
#' @examples
#' example_code()
```

- Blank `#'` lines separate: title/description, description/params, and `@export`/`@examples`.
- `@seealso` (optional) goes between `@returns` and `@export`.
- `@details` can supplement the description when needed.

## Internal (unexported) functions

Internal functions (starting with `.`) use abbreviated documentation:

```r
#' Title in sentence case
#'
#' @param .one_off_param (`TYPE`) Description.
#' @inheritParams .shared-params
#' @returns (`TYPE`) What it returns.
#' @keywords internal
```

No description paragraph, fewer blank `#'` lines, no `@examples`, `@keywords internal` instead of `@export`.

## S3 methods and `@rdname` grouping

Use `@rdname` to group related functions under one help page. This applies to:
- **S3 methods we own** (generic defined in this package): generic gets full docs, methods get `@rdname` + `@export`.
- **Related exported functions** (e.g., `tspec_df`/`tspec_object`/`tspec_row`): primary function gets full docs, variants get `@rdname` + `@export`.

```r
#' Finalize a tibblify object
#'
#' @param field (`any`) The field value.
#' @inheritParams .shared-params-spec_prep
#' @keywords internal
.finalize_tspec_object <- function(field_spec, field) {
  UseMethod(".finalize_tspec_object")
}

#' @rdname .finalize_tspec_object
#' @export
.finalize_tspec_object.tib_collector <- function(field_spec, field) {
  field[[1]]
}
```

**S3 methods we don't own** (generic from another package) need standalone documentation:

```r
#' Title describing the method
#'
#' @param x (`TYPE`) Description.
#' @param ... Additional arguments (ignored).
#' @returns Description.
#' @exportS3Method pkg::generic
method.class <- function(x, ...) { ... }
```

## Style notes

**Cross-references:** Use square brackets — `[tspec_df()]` (internal), `[tibble::tibble()]` (external), `[tib_spec]` (topics).

**Section comment headers** organize code within a file, lowercase with dashes to column 80:

```r
# helpers ----------------------------------------------------------------------
```

**Examples:** Exported functions include `@examples`. Use `@examplesIf interactive()` for network-dependent functions. Use section-style comments (`# Section ---`) to organize longer example blocks. Internal functions do not get examples.

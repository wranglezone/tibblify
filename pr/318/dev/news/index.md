# Changelog

## tibblify (development version)

- All arguments of functions that accept meaningful named `...` are now
  prefixed with `.` to minimize conflicts with column and object names
  in `...`. The un-dotted versions of the arguments are still accepted,
  but calling functions directly with un-dotted arguments will produce a
  warning once per session (see `?lifecycle::deprecate_soft()`).
  Un-dotted arguments will be phased out in a future version of this
  package, so we recommend switching to the dot-prefixed versions. See
  [`?tspec_df`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
  and `?tib_scalar()` for details.
- All code has been refactored for maintainability. While we were
  careful to ensure that output is unchanged, it is possible that a
  corner case is no longer handled how it was in version 0.3.0. Please
  notify us (<https://github.com/wranglezone/tibblify/issues>) if
  something has changed for the worse in an unexpected way
  ([\#243](https://github.com/wranglezone/tibblify/issues/243)).
- The
  [`guess_tspec()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md)
  variants
  [`guess_tspec_list()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md)
  and
  [`guess_tspec_object_list()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md)
  are now exported (along with
  [`guess_tspec_df()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md)
  and
  [`guess_tspec_object()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md),
  which were already exported).
  [`guess_tspec()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md)
  should correctly guess the format in most cases, but you can call the
  variant directly if you think
  [`guess_tspec()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md)
  is dispatching incorrectly
  ([\#249](https://github.com/wranglezone/tibblify/issues/249)).
- [`untibblify()`](https://tibblify.wrangle.zone/dev/reference/untibblify.md)
  now automatically uses the `tib_spec` attribute when present, so
  tibblified objects can be round-tripped without explicitly passing the
  spec ([\#235](https://github.com/wranglezone/tibblify/issues/235)).
- [`parse_openapi_spec()`](https://tibblify.wrangle.zone/dev/reference/parse_openapi_spec.md)
  supports many more fields and works for many more APIs
  ([\#190](https://github.com/wranglezone/tibblify/issues/190),
  [\#200](https://github.com/wranglezone/tibblify/issues/200),
  [@jonthegeek](https://github.com/jonthegeek) and
  [@mgirlich](https://github.com/mgirlich)).
- The underlying C implementation has been updated to better comply with
  R’s C API. We also fixed various bugs during this update
  ([\#203](https://github.com/wranglezone/tibblify/issues/203),
  [\#204](https://github.com/wranglezone/tibblify/issues/204),
  [\#222](https://github.com/wranglezone/tibblify/issues/222)).
- All vignettes and the documentation of all functions has been updated
  for clarity
  ([\#243](https://github.com/wranglezone/tibblify/issues/243)).

(roughly sorted into “Breaking changes”, “Potential breaking changes”,
“New features”, “Bug fixes”, and “Documentation” as of 2026-04-10, but I
left out the headers to make it easier to add more bullets during
development)

## tibblify 0.3.1

CRAN release: 2024-01-11

- New
  [`parse_openapi_spec()`](https://tibblify.wrangle.zone/dev/reference/parse_openapi_spec.md)
  and
  [`parse_openapi_schema()`](https://tibblify.wrangle.zone/dev/reference/parse_openapi_spec.md)
  to convert an OpenAPI specification to a tibblify specification.

- Fix ptype of a
  [`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  inside a
  [`tib_df()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md).

- New
  [`unpack_tspec()`](https://tibblify.wrangle.zone/dev/reference/unpack_tspec.md)
  to unpack the elements of
  [`tib_row()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  fields ([\#165](https://github.com/wranglezone/tibblify/issues/165)).

- Improved printing of lists parsed with
  [`tspec_object()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md).

- Improved performance of the `tspec()` family.

- Improved guessing.

## tibblify 0.3.0

CRAN release: 2022-11-16

- In column major format all fields are required.

- Fixed a memory leak.

- [`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  is now uses less memory and is faster.

- `tspec_*()`,
  [`tib_df()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md),
  and
  [`tib_row()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  now discard `NULL` in `...`. This makes it easier to add a field
  conditionally with, for example `tspec_df(if (x) tib_int("a"))`.

- [`tib_variant()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  and
  [`tib_vector()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  give you more control for transforming:

  - `transform` is now applied to the whole vector.

  - There is a new `elt_transform` argument that is applied to every
    element.

- New
  [`tspec_recursive()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
  and
  [`tib_recursive()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
  to parse tree like structure, e.g. a directory structure with its
  children.

## tibblify 0.2.0

CRAN release: 2022-07-14

Major rewrite of the tibblify package with lots of benefits:

- [`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md)
  is now implemented in C and therefore way faster.

- Support of column major format.

- Support for vectors as scalar lists and objects.

- Specification functions have been renamed

  - `lcols()` to
    [`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
  - new specs
    [`tspec_object()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
    and
    [`tspec_row()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
  - `lcol_int()` to
    [`tib_int()`](https://tibblify.wrangle.zone/dev/reference/tib_spec.md)
    etc

- [`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
  gains an argument `.names_to` to store the names of a recordlist in a
  column.

- Added
  [`untibblify()`](https://tibblify.wrangle.zone/dev/reference/untibblify.md)
  to turn a tibble into a nested list, i.e. to reverse the action of
  [`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md).

- Added `spec_combine()` to combine multiple specifications.

- Added argument `unspecified` to
  [`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md)
  to control how to handle unspecified fields.

- Many bugfixes.

## tibblify 0.1.0

CRAN release: 2020-09-23

- First CRAN release.

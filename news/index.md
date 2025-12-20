# Changelog

## tibblify (development version)

## tibblify 0.3.1

CRAN release: 2024-01-11

- New
  [`parse_openapi_spec()`](https://mgirlich.github.io/tibblify/reference/parse_openapi_spec.md)
  and
  [`parse_openapi_schema()`](https://mgirlich.github.io/tibblify/reference/parse_openapi_spec.md)
  to convert an OpenAPI specification to a tibblify specification.

- Fix ptype of a
  [`tib_vector()`](https://mgirlich.github.io/tibblify/reference/tib_scalar.md)
  inside a
  [`tib_df()`](https://mgirlich.github.io/tibblify/reference/tib_scalar.md).

- New
  [`unpack_tspec()`](https://mgirlich.github.io/tibblify/reference/unpack_tspec.md)
  to unpack the elements of
  [`tib_row()`](https://mgirlich.github.io/tibblify/reference/tib_scalar.md)
  fields ([\#165](https://github.com/mgirlich/tibblify/issues/165)).

- Improved printing of lists parsed with
  [`tspec_object()`](https://mgirlich.github.io/tibblify/reference/tspec_df.md).

- Improved performance of the `tspec()` family.

- Improved guessing.

## tibblify 0.3.0

CRAN release: 2022-11-16

- In column major format all fields are required.

- Fixed a memory leak.

- [`tib_vector()`](https://mgirlich.github.io/tibblify/reference/tib_scalar.md)
  is now uses less memory and is faster.

- `tspec_*()`,
  [`tib_df()`](https://mgirlich.github.io/tibblify/reference/tib_scalar.md),
  and
  [`tib_row()`](https://mgirlich.github.io/tibblify/reference/tib_scalar.md)
  now discard `NULL` in `...`. This makes it easier to add a field
  conditionally with, for example `tspec_df(if (x) tib_int("a"))`.

- [`tib_variant()`](https://mgirlich.github.io/tibblify/reference/tib_scalar.md)
  and
  [`tib_vector()`](https://mgirlich.github.io/tibblify/reference/tib_scalar.md)
  give you more control for transforming:

  - `transform` is now applied to the whole vector.

  - There is a new `elt_transform` argument that is applied to every
    element.

- New
  [`tspec_recursive()`](https://mgirlich.github.io/tibblify/reference/tspec_df.md)
  and
  [`tib_recursive()`](https://mgirlich.github.io/tibblify/reference/tib_scalar.md)
  to parse tree like structure, e.g. a directory structure with its
  children.

## tibblify 0.2.0

CRAN release: 2022-07-14

Major rewrite of the tibblify package with lots of benefits:

- [`tibblify()`](https://mgirlich.github.io/tibblify/reference/tibblify.md)
  is now implemented in C and therefore way faster.

- Support of column major format.

- Support for vectors as scalar lists and objects.

- Specification functions have been renamed

  - `lcols()` to
    [`tspec_df()`](https://mgirlich.github.io/tibblify/reference/tspec_df.md)
  - new specs
    [`tspec_object()`](https://mgirlich.github.io/tibblify/reference/tspec_df.md)
    and
    [`tspec_row()`](https://mgirlich.github.io/tibblify/reference/tspec_df.md)
  - `lcol_int()` to
    [`tib_int()`](https://mgirlich.github.io/tibblify/reference/tib_scalar.md)
    etc

- [`tspec_df()`](https://mgirlich.github.io/tibblify/reference/tspec_df.md)
  gains an argument `.names_to` to store the names of a recordlist in a
  column.

- Added
  [`untibblify()`](https://mgirlich.github.io/tibblify/reference/untibblify.md)
  to turn a tibble into a nested list, i.e. to reverse the action of
  [`tibblify()`](https://mgirlich.github.io/tibblify/reference/tibblify.md).

- Added `spec_combine()` to combine multiple specifications.

- Added argument `unspecified` to
  [`tibblify()`](https://mgirlich.github.io/tibblify/reference/tibblify.md)
  to control how to handle unspecified fields.

- Many bugfixes.

## tibblify 0.1.0

CRAN release: 2020-09-23

- First CRAN release.

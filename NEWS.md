# tibblify (development version)

* All arguments of functions that accept meaningful named `...` are now prefixed with `.` to minimize conflicts with column and object names in `...`. The un-dotted versions of the arguments are still accepted, but calling functions directly with un-dotted arguments will produce a warning once per session (see `?lifecycle::deprecate_soft()`). Un-dotted arguments will be phased out in a future version of this package, so we recommend switching to the dot-prefexed versions. See `?tspec_df` and `?tib_scalar()` for details.
* All code has been refactored for maintainability. While we were careful to ensure that output is unchanged, it is possible that a corner case is no longer handled how it was in version 0.3.0. Please notify us (<https://github.com/wranglezone/tibblify/issues>) if something has changed for the worse in an unexpected way (#243).
* The `guess_tspec()` variants `guess_tspec_list()` and `guess_tspec_object_list()` are now exported (along with `guess_tspec_df()` and `guess_tspec_object()`, which were already exported). `guess_tspec()` should correctly guess the format in most cases, but you can call the variant directly if you think `guess_tspec()` is dispatching incorrectly (#249). 
* `untibblify()` now automatically uses the `tib_spec` attribute when present, so tibblified objects can be round-tripped without explicitly passing the spec (#235).
* `parse_openapi_spec()` supports many more fields and works for many more APIs (#190, #200, @jonthegeek and @mgirlich).
* The underlying C implementation has been updated to better comply with R's C API. We also fixed various bugs during this update (#203, #204, #222).
* All vignettes and the documentation of all functions has been updated for clarity (#243).

(roughly sorted into "Breaking changes", "Potential breaking changes", "New features", "Bug fixes", and "Documentation" as of 2026-04-10, but I left out the headers to make it easier to add more bullets during development)

# tibblify 0.3.1

* New `parse_openapi_spec()` and `parse_openapi_schema()` to convert an
  OpenAPI specification to a tibblify specification.

* Fix ptype of a `tib_vector()` inside a `tib_df()`.

* New `unpack_tspec()` to unpack the elements of `tib_row()` fields (#165).

* Improved printing of lists parsed with `tspec_object()`.

* Improved performance of the `tspec()` family.

* Improved guessing.

# tibblify 0.3.0

* In column major format all fields are required.

* Fixed a memory leak.

* `tib_vector()` is now uses less memory and is faster.

* `tspec_*()`, `tib_df()`, and `tib_row()` now discard `NULL` in `...`. This
  makes it easier to add a field conditionally with, for example
  `tspec_df(if (x) tib_int("a"))`.

* `tib_variant()` and `tib_vector()` give you more control for transforming:

  * `transform` is now applied to the whole vector.
  
  * There is a new `elt_transform` argument that is applied to every element.

* New `tspec_recursive()` and `tib_recursive()` to parse tree like structure,
  e.g. a directory structure with its children.

# tibblify 0.2.0

Major rewrite of the tibblify package with lots of benefits:

* `tibblify()` is now implemented in C and therefore way faster.

* Support of column major format.

* Support for vectors as scalar lists and objects.

* Specification functions have been renamed
  * `lcols()` to `tspec_df()`
  * new specs `tspec_object()` and `tspec_row()`
  * `lcol_int()` to `tib_int()` etc

* `tspec_df()` gains an argument `.names_to` to store the names of a recordlist
  in a column.

* Added `untibblify()` to turn a tibble into a nested list, i.e. to reverse the action of `tibblify()`.

* Added `spec_combine()` to combine multiple specifications.

* Added argument `unspecified` to `tibblify()` to control how to handle unspecified
  fields.

* Many bugfixes.  

# tibblify 0.1.0

* First CRAN release.

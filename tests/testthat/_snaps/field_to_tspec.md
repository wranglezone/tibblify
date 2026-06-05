# field_to_tspec errors on non-nested field types (#346)

    Code
      (expect_error(field_to_tspec(spec, "id")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec()`:
      ! Field id must be a `tib_df()`, `tib_row()`, or `tib_recursive()` field.
      x Field id is a `tib_scalar()` field.

# field_to_tspec_df errors on non-nested field type (#346)

    Code
      (expect_error(field_to_tspec_df(spec, "id")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec_df()`:
      ! Field id must be a `tib_df()`, `tib_row()`, or `tib_recursive()` field.
      x Field id is a `tib_scalar()` field.

# field_to_tspec_row errors on non-nested field type (#346)

    Code
      (expect_error(field_to_tspec_row(spec, "id")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec_row()`:
      ! Field id must be a `tib_df()`, `tib_row()`, or `tib_recursive()` field.
      x Field id is a `tib_scalar()` field.

# field_to_tspec_recursive errors on non-recursive field type (#346)

    Code
      (expect_error(field_to_tspec_recursive(spec, "id")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec_recursive()`:
      ! Field id must be a `tib_recursive()` field.
      x Field id is a `tib_scalar()` field.

# field_to_tspec_recursive errors on tib_row (#346)

    Code
      (expect_error(field_to_tspec_recursive(spec, "loc")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec_recursive()`:
      ! Field loc must be a `tib_recursive()` field.
      x Field loc is a `tib_row()` field.

# field_to_tspec errors if field doesn't exist (#346)

    Code
      (expect_error(field_to_tspec(spec, "missing")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec()`:
      ! Field missing doesn't exist in `spec`.
    Code
      (expect_error(field_to_tspec_df(spec, "missing")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec_df()`:
      ! Field missing doesn't exist in `spec`.
    Code
      (expect_error(field_to_tspec_row(spec, "missing")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec_row()`:
      ! Field missing doesn't exist in `spec`.
    Code
      (expect_error(field_to_tspec_recursive(spec, "missing")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec_recursive()`:
      ! Field missing doesn't exist in `spec`.

# field_to_tspec errors if spec is not a tspec (#346)

    Code
      (expect_error(field_to_tspec(list(), "x")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec()`:
      ! `spec` must be a tibblify spec.
    Code
      (expect_error(field_to_tspec_df(list(), "x")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec_df()`:
      ! `spec` must be a tibblify spec.
    Code
      (expect_error(field_to_tspec_row(list(), "x")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec_row()`:
      ! `spec` must be a tibblify spec.
    Code
      (expect_error(field_to_tspec_recursive(list(), "x")))
    Output
      <error/tibblify_error>
      Error in `field_to_tspec_recursive()`:
      ! `spec` must be a tibblify spec.


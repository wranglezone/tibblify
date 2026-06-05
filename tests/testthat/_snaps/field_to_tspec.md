# field_to_tspec errors on non-nested field types (#346)

    Code
      (expect_error(field_to_tspec(spec, "id")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec()`:
      ! Field id must be a `tib_df()`, `tib_row()`, or `tib_recursive()` field.
      x Field id is a `tib_scalar()` field.

# field_to_tspec_df errors on wrong field type (#346)

    Code
      (expect_error(field_to_tspec_df(spec, "loc")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec_df()`:
      ! Field loc must be a `tib_df()` field.
      x Field loc is a `tib_row()` field.

# field_to_tspec_row errors on wrong field type (#346)

    Code
      (expect_error(field_to_tspec_row(spec, "items")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec_row()`:
      ! Field items must be a `tib_row()` field.
      x Field items is a `tib_df()` field.

# field_to_tspec_recursive errors on wrong field type (#346)

    Code
      (expect_error(field_to_tspec_recursive(spec, "id")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec_recursive()`:
      ! Field id must be a `tib_recursive()` field.
      x Field id is a `tib_scalar()` field.

# field_to_tspec errors if field doesn't exist (#346)

    Code
      (expect_error(field_to_tspec(spec, "missing")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec()`:
      ! Field missing doesn't exist in `spec`.
    Code
      (expect_error(field_to_tspec_df(spec, "missing")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec_df()`:
      ! Field missing doesn't exist in `spec`.
    Code
      (expect_error(field_to_tspec_row(spec, "missing")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec_row()`:
      ! Field missing doesn't exist in `spec`.
    Code
      (expect_error(field_to_tspec_recursive(spec, "missing")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec_recursive()`:
      ! Field missing doesn't exist in `spec`.

# field_to_tspec errors if spec is not a tspec (#346)

    Code
      (expect_error(field_to_tspec(list(), "x")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec()`:
      ! `spec` must be a tibblify spec.
    Code
      (expect_error(field_to_tspec_df(list(), "x")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec_df()`:
      ! `spec` must be a tibblify spec.
    Code
      (expect_error(field_to_tspec_row(list(), "x")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec_row()`:
      ! `spec` must be a tibblify spec.
    Code
      (expect_error(field_to_tspec_recursive(list(), "x")))
    Output
      <error/rlang_error>
      Error in `field_to_tspec_recursive()`:
      ! `spec` must be a tibblify spec.


# Shared spec_prep parameters

These parameters are used in multiple
[`.spec_prep()`](https://tibblify.wrangle.zone/dev/reference/dot-spec_prep.md)-related
functions. They are defined here to make them easier to import and to
find. This break-out is for parameters that may differ from other
functions that use the same parameter names.

## Arguments

- coll_locations:

  (`integer`) A numeric vector of locations.

- field_spec:

  (`tib_collector`) A field specification.

- fill:

  (`vector`) The fill value.

- first_keys:

  (`character`) First keys of the complex fields.

- key:

  (`character(1)`) The key of the field.

- spec_fields:

  (`list`) Fields from spec\$fields (or a subset thereof).

- x:

  (`tib_collector`) A field specification.

- ptype:

  (`vector(0)`) The target ptype.

- names_to:

  (`character(1)`) Name of the names column.

- col_names:

  (`character`) Column names.

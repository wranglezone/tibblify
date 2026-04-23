# Create a field specification

Use the `tib_*()` functions to specify how to process the fields of an
object.

## Usage

``` r
tib_scalar(
  .key,
  .ptype,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = .ptype,
  .transform = NULL,
  key = deprecated(),
  ptype = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
)

tib_vector(
  .key,
  .ptype,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = .ptype,
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
  ptype = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated(),
  elt_transform = deprecated(),
  input_form = deprecated(),
  values_to = deprecated(),
  names_to = deprecated()
)

tib_unspecified(
  .key,
  ...,
  .required = TRUE,
  key = deprecated(),
  required = deprecated()
)

tib_lgl(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = logical(),
  .transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
)

tib_int(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = integer(),
  .transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
)

tib_dbl(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = double(),
  .transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
)

tib_chr(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = character(),
  .transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
)

tib_date(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = vctrs::new_date(),
  .transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated()
)

tib_chr_date(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .format = "%Y-%m-%d",
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  format = deprecated()
)

tib_lgl_vec(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = logical(),
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated(),
  elt_transform = deprecated(),
  input_form = deprecated(),
  values_to = deprecated(),
  names_to = deprecated()
)

tib_int_vec(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = integer(),
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated(),
  elt_transform = deprecated(),
  input_form = deprecated(),
  values_to = deprecated(),
  names_to = deprecated()
)

tib_dbl_vec(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = double(),
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated(),
  elt_transform = deprecated(),
  input_form = deprecated(),
  values_to = deprecated(),
  names_to = deprecated()
)

tib_chr_vec(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = character(),
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated(),
  elt_transform = deprecated(),
  input_form = deprecated(),
  values_to = deprecated(),
  names_to = deprecated()
)

tib_date_vec(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .ptype_inner = vctrs::new_date(),
  .transform = NULL,
  .elt_transform = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  ptype_inner = deprecated(),
  transform = deprecated(),
  elt_transform = deprecated(),
  input_form = deprecated(),
  values_to = deprecated(),
  names_to = deprecated()
)

tib_chr_date_vec(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .input_form = c("vector", "scalar_list", "object"),
  .values_to = NULL,
  .names_to = NULL,
  .format = "%Y-%m-%d",
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  input_form = deprecated(),
  values_to = deprecated(),
  names_to = deprecated(),
  format = deprecated()
)

tib_variant(
  .key,
  ...,
  .required = TRUE,
  .fill = NULL,
  .transform = NULL,
  .elt_transform = NULL,
  key = deprecated(),
  required = deprecated(),
  fill = deprecated(),
  transform = deprecated(),
  elt_transform = deprecated()
)

tib_recursive(.key, ..., .children, .children_to = .children, .required = TRUE)

tib_row(.key, ..., .required = TRUE)

tib_df(.key, ..., .required = TRUE, .names_to = NULL)
```

## Arguments

- .key, key:

  (`character`) The path of names to the field in the object.

- .ptype, ptype:

  (`vector(0)`) A prototype of the desired output type of the field.

- ...:

  These dots are for future extensions and must be empty.

- .required, required:

  (`logical(1)`) Throw an error if the field does not exist?

- .fill, fill:

  (`vector` or `NULL`) Optionally, a value to use if the field does not
  exist.

- .ptype_inner, ptype_inner:

  (`vector(0)`) A prototype of the input field.

- .transform, transform:

  (`function` or `NULL`) A function to apply to the whole vector after
  casting to `.ptype_inner`.

- .elt_transform, elt_transform:

  (`function` or `NULL`) A function to apply to each element before
  casting to `.ptype_inner`.

- .input_form, input_form:

  (`character(1)`) The structure of the input field. Can be one of:

  - `"vector"`: The field is a vector, e.g. `c(1, 2, 3)`.

  - `"scalar_list"`: The field is a list of scalars, e.g.
    `list(1, 2, 3)`.

  - `"object"`: The field is a named list of scalars, e.g.
    `list(a = 1, b = 2, c = 3)`.

- .values_to, values_to:

  (`character(1)` or `NULL`) For `NULL` (the default), the field is
  converted to a `.ptype` vector. If a string is provided, the field is
  converted to a tibble and the values go into the specified column.

- .names_to, names_to:

  (`character(1)` or `NULL`) What to do with the inner names of the
  object. Can be one of:

  - `NULL`: the default. The inner names of the field are not used.

  - A string: Use only if the input form is `"object"` or `"vector"`,
    and `.values_to` is a string. The inner names of the field will
    populate the specified column in the field's tibble.

- .format, format:

  (`character(1)` or `NULL`) Passed to the `format` argument of
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html).

- .children:

  (`character(1)`) The name of the field that contains the children.

- .children_to:

  (`character(1)`) The column name in which to store the children.

## Value

A tibblify field collector. This specification can be used with
[`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
or another `tspec_*()` function to specify how to process an object.

## Details

There are five families of `tib_*()` functions:

- `tib_scalar(.ptype)`: Cast each instance of the field to a length-one
  vector of type `.ptype`. Inside
  [`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  this results in a column of the specified `.ptype`.

- `tib_vector(.ptype)`: Cast each instance of the field to an arbitrary
  length vector of type `.ptype`. Inside
  [`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  this results in a list column of vectors of the specified `.ptype`.

- `tib_variant()`: Cast each instance of the field to a list. Inside
  [`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  this results in a list column of lists.

- `tib_row()`: Cast each instance of the field to a 1-row tibble. Inside
  [`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  this results in a list column of 1-row tibbles.

- `tib_df()`: Cast each instance of the field to a tibble. Inside
  [`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  this results in a list column of tibbles (each of which can have
  multiple rows).

  There are some special shortcuts of `tib_scalar()` and `tib_vector()`
  for the most common prototypes:

- [`logical()`](https://rdrr.io/r/base/logical.html): `tib_lgl()` and
  `tib_lgl_vec()`

- [`integer()`](https://rdrr.io/r/base/integer.html): `tib_int()` and
  `tib_int_vec()`

- [`double()`](https://rdrr.io/r/base/double.html): `tib_dbl()` and
  `tib_dbl_vec()`

- [`character()`](https://rdrr.io/r/base/character.html): `tib_chr()`
  and `tib_chr_vec()`

- `Date`: `tib_date()` and `tib_date_vec()`

  Further, there are special shortcuts for dates encoded as character:
  `tib_chr_date()` and `tib_chr_date_vec()`.

  There are two other `tib_*()` functions for special cases:

- `tib_recursive()`: Cast each instance of the field to a tibble, within
  which columns can themselves contain the same sorts of tibble, etc.
  Inside
  [`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md),
  this results in a list column of tibbles, each row of which can itself
  contain a tibble, etc. This is intended for structures such as a
  directory tree.

- `tib_unspecified()`: Tag a field in the object as unspecified. The
  `unspecified` argument of
  [`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md)
  controls how such fields are handled. If you are constructing a
  specification manually (as opposed to using
  [`guess_tspec()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md)),
  you should most likely specify such columns with `tib_variant()`, or
  leave them out of the spec entirely.

## Examples

``` r
tib_int("int")
#> tib_int("int")
tib_int("int", .required = FALSE, .fill = 0)
#> tib_int(
#>   "int",
#>   required = FALSE,
#>   fill = 0L,
#> )

# This is essentially how `tib_chr_date()` is implemented.
tib_scalar("date", Sys.Date(), .transform = function(x) as.Date(x, format = "%Y-%m-%d"))
#> tib_date("date", transform = function (x) 
#> as.Date(x, format = "%Y-%m-%d"))

tib_df(
  "data",
  .names_to = "id",
  age = tib_int("age"),
  name = tib_chr("name")
)
#> tib_df(
#>   "data",
#>   .names_to = "id",
#>   tib_int("age"),
#>   tib_chr("name"),
#> )
```

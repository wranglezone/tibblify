# Create a Field Specification

Use these functions to specify how to convert the fields of an object.

## Usage

``` r
tib_unspecified(key, ..., required = TRUE)

tib_scalar(
  key,
  ptype,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = ptype,
  transform = NULL
)

tib_lgl(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = logical(),
  transform = NULL
)

tib_int(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = integer(),
  transform = NULL
)

tib_dbl(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = double(),
  transform = NULL
)

tib_chr(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = character(),
  transform = NULL
)

tib_date(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = vctrs::new_date(),
  transform = NULL
)

tib_chr_date(key, ..., required = TRUE, fill = NULL, format = "%Y-%m-%d")

tib_vector(
  key,
  ptype,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = ptype,
  transform = NULL,
  elt_transform = NULL,
  input_form = c("vector", "scalar_list", "object"),
  values_to = NULL,
  names_to = NULL
)

tib_lgl_vec(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = logical(),
  transform = NULL,
  elt_transform = NULL,
  input_form = c("vector", "scalar_list", "object"),
  values_to = NULL,
  names_to = NULL
)

tib_int_vec(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = integer(),
  transform = NULL,
  elt_transform = NULL,
  input_form = c("vector", "scalar_list", "object"),
  values_to = NULL,
  names_to = NULL
)

tib_dbl_vec(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = double(),
  transform = NULL,
  elt_transform = NULL,
  input_form = c("vector", "scalar_list", "object"),
  values_to = NULL,
  names_to = NULL
)

tib_chr_vec(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = character(),
  transform = NULL,
  elt_transform = NULL,
  input_form = c("vector", "scalar_list", "object"),
  values_to = NULL,
  names_to = NULL
)

tib_date_vec(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  ptype_inner = vctrs::new_date(),
  transform = NULL,
  elt_transform = NULL,
  input_form = c("vector", "scalar_list", "object"),
  values_to = NULL,
  names_to = NULL
)

tib_chr_date_vec(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  input_form = c("vector", "scalar_list", "object"),
  values_to = NULL,
  names_to = NULL,
  format = "%Y-%m-%d"
)

tib_variant(
  key,
  ...,
  required = TRUE,
  fill = NULL,
  transform = NULL,
  elt_transform = NULL
)

tib_recursive(.key, ..., .children, .children_to = .children, .required = TRUE)

tib_row(.key, ..., .required = TRUE)

tib_df(.key, ..., .required = TRUE, .names_to = NULL)
```

## Arguments

- key, .key:

  The path to the field in the object.

- ...:

  These dots are for future extensions and must be empty.

- required, .required:

  Throw an error if the field does not exist?

- ptype:

  A prototype of the desired output type of the field.

- fill:

  Optionally, a value to use if the field does not exist.

- ptype_inner:

  A prototype of the field.

- transform:

  A function to apply to the whole vector after casting to
  `ptype_inner`.

- format:

  Optional, a string passed to the `format` argument of
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html).

- elt_transform:

  A function to apply to each element before casting to `ptype_inner`.

- input_form:

  A string that describes what structure the field has. Can be one of:

  - `"vector"`: The field is a vector, e.g. `c(1, 2, 3)`.

  - `"scalar_list"`: The field is a list of scalars, e.g.
    `list(1, 2, 3)`.

  - `"object"`: The field is a named list of scalars, e.g.
    `list(a = 1, b = 2, c = 3)`.

- values_to:

  Can be one of the following:

  - `NULL`: the default. The field is converted to a `ptype` vector.

  - A string: The field is converted to a tibble and the values go into
    the specified column.

- names_to:

  Can be one of the following:

  - `NULL`: the default. The inner names of the field are not used.

  - A string: This can only be used if 1) for the input form is
    `"object"` or `"vector"` and 2) `values_to` is a string. The inner
    names of the field go into the specified column.

- .children:

  A string giving the name of field that contains the children.

- .children_to:

  A string giving the column name to store the children.

- .names_to:

  A string giving the name of the column which will contain the names of
  elements of the object list. If `NULL`, the default, no name column is
  created

## Value

A tibblify field collector.

## Details

There are basically five different `tib_*()` functions

- `tib_scalar(ptype)`: Cast the field to a length one vector of type
  `ptype`.

- `tib_vector(ptype)`: Cast the field to an arbitrary length vector of
  type `ptype`.

- `tib_variant()`: Cast the field to a list.

- `tib_row()`: Cast the field to a named list.

- `tib_df()`: Cast the field to a tibble.

There are some special shortcuts of `tib_scalar()` resp. `tib_vector()`
for the most common prototypes

- [`logical()`](https://rdrr.io/r/base/logical.html): `tib_lgl()` resp.
  `tib_lgl_vec()`

- [`integer()`](https://rdrr.io/r/base/integer.html): `tib_int()` resp.
  `tib_int_vec()`

- [`double()`](https://rdrr.io/r/base/double.html): `tib_dbl()` resp.
  `tib_dbl_vec()`

- [`character()`](https://rdrr.io/r/base/character.html): `tib_chr()`
  resp. `tib_chr_vec()`

- `Date`: `tib_date()` resp. `tib_date_vec()`

Further, there is also a special shortcut for dates encoded as
character: `tib_chr_date()` resp. `tib_chr_date_vec()`.

## Examples

``` r
tib_int("int")
#> tib_int("int")
tib_int("int", required = FALSE, fill = 0)
#> tib_int(
#>   "int",
#>   required = FALSE,
#>   fill = 0L,
#> )

tib_scalar("date", Sys.Date(), transform = function(x) as.Date(x, format = "%Y-%m-%d"))
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

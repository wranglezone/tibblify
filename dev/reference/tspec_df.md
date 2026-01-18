# Create a tibblify specification

Use `tspec_df()` to specify how to convert a list of objects to a
tibble. Use `tspec_row()` to specify how to convert an object to a
one-row tibble. Use `tspec_object()` to specify how to convert an object
to a list.

## Usage

``` r
tspec_df(
  ...,
  .input_form = c("rowmajor", "colmajor"),
  .names_to = NULL,
  .vector_allows_empty_list = FALSE,
  vector_allows_empty_list = deprecated()
)

tspec_object(
  ...,
  .input_form = c("rowmajor", "colmajor"),
  .vector_allows_empty_list = FALSE,
  vector_allows_empty_list = deprecated()
)

tspec_row(
  ...,
  .input_form = c("rowmajor", "colmajor"),
  .vector_allows_empty_list = FALSE,
  vector_allows_empty_list = deprecated()
)

tspec_recursive(
  ...,
  .children,
  .children_to = .children,
  .input_form = c("rowmajor", "colmajor"),
  .vector_allows_empty_list = FALSE,
  vector_allows_empty_list = deprecated()
)
```

## Arguments

- ...:

  Column specifications created by `tib_*()` or `tspec_*()`. If the dots
  are named, the name will be used for the resulting column. Otherwise,
  the name of the input will be used for the column name.

- .input_form:

  The input form of data-frame-like lists. Can be one of:

  - `"rowmajor"`: The default. The input is a named list of rows.

  - `"colmajor"`: The input is a named list of columns.

- .names_to:

  A string giving the name of the column in the output which will
  contain the names of top-level elements of the input named list. If
  `NULL`, the default, no name column is created.

- .vector_allows_empty_list, vector_allows_empty_list:

  Should empty lists for columns with `.input_form = "vector"` be
  accepted and treated as empty vectors?

- .children:

  A string giving the name of the field that contains the children.

- .children_to:

  A string giving the column name in which to store the children.

## Value

A tibblify specification.

## Details

In column-major format, all fields are required, regardless of the
`.required` argument.

## Examples

``` r
tspec_df(
  id = tib_int("id"),
  name = tib_chr("name"),
  aliases = tib_chr_vec("aliases")
)
#> tspec_df(
#>   tib_int("id"),
#>   tib_chr("name"),
#>   tib_chr_vec("aliases"),
#> )

# Equivalent to
tspec_df(
  tib_int("id"),
  tib_chr("name"),
  tib_chr_vec("aliases")
)
#> tspec_df(
#>   tib_int("id"),
#>   tib_chr("name"),
#>   tib_chr_vec("aliases"),
#> )

# To create multiple columns of the same type use the bang-bang-bang (`!!!`)
# operator together with `purrr::map()`
tspec_df(
  !!!purrr::map(purrr::set_names(c("id", "age")), tib_int),
  !!!purrr::map(purrr::set_names(c("name", "title")), tib_chr)
)
#> tspec_df(
#>   tib_int("id"),
#>   tib_int("age"),
#>   tib_chr("name"),
#>   tib_chr("title"),
#> )

# The `tspec_*()` functions can also be nested
spec1 <- tspec_object(
  int = tib_int("int"),
  chr = tib_chr("chr")
)
spec2 <- tspec_object(
  int2 = tib_int("int2"),
  chr2 = tib_chr("chr2")
)

tspec_df(spec1, spec2)
#> tspec_df(
#>   tib_int("int"),
#>   tib_chr("chr"),
#>   tib_int("int2"),
#>   tib_chr("chr2"),
#> )
```

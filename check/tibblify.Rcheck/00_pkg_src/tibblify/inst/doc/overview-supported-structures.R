## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(tibblify)

## ----results='hide'-----------------------------------------------------------
TRUE
1
1.5
"a"

## ----eval=FALSE---------------------------------------------------------------
# c(TRUE, NA, FALSE)
# c(1L, NA, 2L)
# c(1.5, NA, 2.5)
# c("a", NA, "c")

## ----error=TRUE---------------------------------------------------------------
try({
x_json <- '[
  {"a": [1, 2]},
  {"a": []}
]'

x <- jsonlite::fromJSON(x_json, simplifyDataFrame = FALSE)
str(x)
})

## ----error=TRUE---------------------------------------------------------------
try({
tibblify(x, tspec_df(tib_int_vec("a")))
})

## -----------------------------------------------------------------------------
tibblify(x, tspec_df(tib_int_vec("a"), vector_allows_empty_list = TRUE))$a

## ----error=TRUE---------------------------------------------------------------
try({
x_json <- '[
  {"a": [1, 2]},
  {"a": [1, 2, 3]}
]'

x <- jsonlite::fromJSON(x_json, simplifyVector = FALSE)
str(x)
})

## ----error=TRUE---------------------------------------------------------------
try({
tibblify(x, tspec_df(tib_int_vec("a")))
})

## -----------------------------------------------------------------------------
tibblify(x, tspec_df(tib_int_vec("a", input_form = "scalar_list")))$a

## -----------------------------------------------------------------------------
x_json <- '[
  {"a": {"x": 1, "y": 2}},
  {"a": {"a": 1, "b": 2, "b": 3}}
]'

x <- jsonlite::fromJSON(x_json, simplifyVector = FALSE)
str(x)

## -----------------------------------------------------------------------------
spec <- tspec_df(
  tib_int_vec(
    "a",
    input_form = "object",
    names_to = "name",
    values_to = "value"
  )
)

tibblify(x, spec)$a

## ----eval=FALSE---------------------------------------------------------------
# list(1, "a", TRUE)

## ----results='hide'-----------------------------------------------------------
x <- list(
  a = 1,
  b = TRUE
)

## -----------------------------------------------------------------------------
x <- list(
  list(row = list(a = 1, b = TRUE)),
  list(row = list(a = 2, b = FALSE))
)

spec <- tspec_df(
  tib_row(
    "row",
    tib_int("a"),
    tib_lgl("b")
  )
)

tibblify(x, spec)

## ----results='hide'-----------------------------------------------------------
x <- list(
  list(a = 1, b = TRUE),
  list(a = 2, b = FALSE)
)

## ----results='hide'-----------------------------------------------------------
x <- list(
  object1 = list(a = 1, b = TRUE),
  object2 = list(a = 2, b = FALSE)
)

## -----------------------------------------------------------------------------
x_json <- '[
{
  "df": {
    "object1": {"a": 1, "b": true},
    "object2": {"a": 2, "b": false}
  }
}]'

x <- jsonlite::fromJSON(x_json, simplifyDataFrame = FALSE)

spec <- tspec_df(
  tib_df(
    "df",
    tib_int("a"),
    tib_lgl("b"),
    .names_to = "name"
  )
)

tibblify(x, spec)$df

## ----results='hide'-----------------------------------------------------------
x <- list(
  a = c(1, 2),
  b = c(TRUE, FALSE)
)

## -----------------------------------------------------------------------------
df_spec <- tspec_df(
  tib_int("a"),
  tib_lgl("b"),
  .input_form = "colmajor"
)

tibblify(x, df_spec)


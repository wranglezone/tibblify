# Used in test-spec_guess_object_list.R

guess_ol_field <- function(
  value,
  name = "x",
  empty_list_unspecified = FALSE,
  simplify_list = FALSE
) {
  guess_object_list_field_spec(
    value = value,
    name = name,
    empty_list_unspecified = empty_list_unspecified,
    simplify_list = simplify_list
  )
}

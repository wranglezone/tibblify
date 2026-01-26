new_difftime <- function(units) {
  structure(numeric(), class = "difftime", units = units)
}

new_rational <- function(n = integer(), d = integer()) {
  n <- vctrs::vec_cast(n, integer())
  d <- vctrs::vec_cast(d, integer())

  size <- vctrs::vec_size_common(n, d)
  n <- vctrs::vec_recycle(n, size)
  d <- vctrs::vec_recycle(d, size)

  vctrs::new_rcrd(list(n = n, d = d), class = "vctrs_rational")
}

read_sample_json <- function(x) {
  path <- system.file("jsonexamples", x, package = "tibblify")
  jsonlite::fromJSON(path, simplifyDataFrame = FALSE)
}

tib <- function(x, col) {
  tibblify(
    list(x),
    tspec_df(x = col)
  )
}

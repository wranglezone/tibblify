#' @rdname formatting
#' @export
print.tibblify_object <- function(x, ..., fully_qualify = FALSE) {
  attributes(x) <- list(names = names(x))
  print(x)
}

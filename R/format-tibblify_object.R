#' @rdname formatting
#' @export
print.tibblify_object <- function(x, ...) {
  attributes(x) <- list(names = names(x))
  print(x)
}

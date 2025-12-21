# nocov start

.onLoad <- function(libname, pkgname) {
  # Load vctrs explicitly to ensure it's available
  vctrs_ns <- loadNamespace("vctrs")

  # Pass BOTH namespaces to the C initializer
  .Call(tibblify_initialize, ns_env("tibblify"), vctrs_ns)
}

# nocov end

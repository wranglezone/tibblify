# nocov start

.onLoad <- function(libname, pkgname) {
  # Load vctrs and stbl explicitly to ensure their DLLs and C callables are
  # available before we call into the C initializer.
  vctrs_ns <- loadNamespace("vctrs")
  loadNamespace("stbl")

  # Pass BOTH namespaces to the C initializer
  .Call(tibblify_initialize, rlang::ns_env("tibblify"), vctrs_ns)

  if (rlang::is_installed("memoise")) {
    .parse_schema_memoised <<- memoise::memoise(
      .parse_schema,
      omit_args = "openapi_spec"
    )
  }
}

# nocov end

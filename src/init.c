#include "rlang.h"
#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

#include <R_ext/Visibility.h>
#include <vctrs.c>
#include "r-vctrs.h"

#define export attribute_visible extern

/* .Call calls */
extern SEXP ffi_tibblify(SEXP, SEXP, SEXP);
extern SEXP ffi_is_object(SEXP);
extern SEXP ffi_is_object_list(SEXP);
extern SEXP ffi_is_null_list(SEXP);
extern SEXP ffi_list_is_list_null(SEXP);

extern SEXP tibblify_initialize(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"ffi_tibblify",           (DL_FUNC) &ffi_tibblify,           3},
  {"ffi_is_object",          (DL_FUNC) &ffi_is_object,          1},
  {"ffi_is_object_list",     (DL_FUNC) &ffi_is_object_list,     1},
  {"ffi_is_null_list",       (DL_FUNC) &ffi_is_null_list,       1},
  {"ffi_list_is_list_null",  (DL_FUNC) &ffi_list_is_list_null,  1},
  {"tibblify_initialize",    (DL_FUNC) &tibblify_initialize,    2},
  {NULL, NULL, 0}
};

export void R_init_tibblify(DllInfo* dll){
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  vctrs_init_api();
}

// --------------------------------------------------------
// Initialization Hooks
// --------------------------------------------------------

void tibblify_init_utils(SEXP ns, SEXP vctrs_ns);
SEXP r_init_library(SEXP);

SEXP tibblify_initialize(SEXP ns, SEXP vctrs_ns) {
  r_init_library(ns);
  tibblify_init_utils(ns, vctrs_ns);
  rvctrs_init(vctrs_ns);

  return R_NilValue;
}

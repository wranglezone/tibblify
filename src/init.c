#include "rlang.h"
#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

#include <R_ext/Visibility.h>
#include <vctrs.c>

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

void vctrs_init_globals(SEXP ns);
void vctrs_init_utils(SEXP ns);
void vctrs_init_cast(SEXP ns);
// void vctrs_init_dictionary(SEXP ns);
// void vctrs_init_names(SEXP ns);
void vctrs_init_data(SEXP ns);
// void vctrs_init_proxy_restore(SEXP ns);
// void vctrs_init_ptype(SEXP ns);
// void vctrs_init_ptype2(SEXP ns);
// void vctrs_init_ptype2_dispatch(SEXP ns);
// void vctrs_init_rep(SEXP ns);
// void vctrs_init_slice(SEXP ns);
// void vctrs_init_slice_assign(SEXP ns);
// void vctrs_init_subscript(SEXP ns);
// void vctrs_init_subscript_loc(SEXP ns);
// void vctrs_init_type_data_frame(SEXP ns);
void vctrs_init_type_date_time(SEXP ns);
// void vctrs_init_type_info(SEXP ns);
// void vctrs_init_unspecified(SEXP ns);

void tibblify_init_utils(SEXP ns, SEXP vctrs_ns);
SEXP r_init_library(SEXP);

SEXP tibblify_initialize(SEXP ns, SEXP vctrs_ns) {
  r_init_library(ns);

  vctrs_init_globals(vctrs_ns);
  vctrs_init_utils(vctrs_ns);
  vctrs_init_cast(vctrs_ns);
  // vctrs_init_dictionary(vctrs_ns);
  // vctrs_init_names(vctrs_ns);
  vctrs_init_data(vctrs_ns);
  // vctrs_init_proxy_restore(vctrs_ns);
  // vctrs_init_ptype(vctrs_ns);
  // vctrs_init_ptype2(vctrs_ns);
  // vctrs_init_ptype2_dispatch(vctrs_ns);
  // vctrs_init_rep(vctrs_ns);
  // vctrs_init_slice(vctrs_ns);
  // vctrs_init_slice_assign(vctrs_ns);
  // vctrs_init_subscript(vctrs_ns);
  // vctrs_init_subscript_loc(vctrs_ns);
  // vctrs_init_type_data_frame(vctrs_ns);
  vctrs_init_type_date_time(vctrs_ns);
  // vctrs_init_type_info(vctrs_ns);
  // vctrs_init_unspecified(vctrs_ns);

  tibblify_init_utils(ns, vctrs_ns);

  return R_NilValue;
}

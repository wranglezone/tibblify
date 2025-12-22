#include "r-vctrs.h"
#include "tibblify.h" // For tibblify_ns_env and r_sym

struct rvctrs_syms rvctrs_syms;

void rvctrs_init(SEXP vctrs_ns) {
  rvctrs_syms.vec_cast = r_sym("vec_cast");
}

SEXP rvctrs_vec_cast(SEXP x, SEXP to) {
  SEXP call = PROTECT(Rf_lang3(rvctrs_syms.vec_cast, x, to));
  SEXP res = Rf_eval(call, tibblify_ns_env);
  UNPROTECT(1);
  return res;
}

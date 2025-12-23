#include "r-vctrs.h"
#include "tibblify.h" // For tibblify_ns_env and r_sym

struct rvctrs_syms rvctrs_syms;

void rvctrs_init(SEXP vctrs_ns) {
  rvctrs_syms.vec_cast = r_sym("vec_cast");
  rvctrs_syms.vec_is = r_sym("vec_is");
  rvctrs_syms.list_unchop = r_sym("list_unchop");

  rvctrs_syms.ptype = r_sym("ptype");
  rvctrs_syms.name_spec = r_sym("name_spec");

  SEXP zap_sym = Rf_install("zap");
  SEXP zap_call = KEEP(Rf_lang1(zap_sym));
  rvctrs_syms.zap = r_eval(zap_call, tibblify_ns_env);
  r_preserve(rvctrs_syms.zap);
  FREE(1);
}

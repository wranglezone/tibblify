#ifndef R_VCTRS_H
#define R_VCTRS_H

#include <rlang.h>
#include "tibblify.h" // For tibblify_ns_env

// Symbol table for vctrs functions and arguments
struct rvctrs_syms {
  r_obj* vec_cast;
  r_obj* vec_is;
  r_obj* list_unchop;
  r_obj* ptype;
  r_obj* name_spec;
  r_obj* zap; // The rlang::zap() sentinel
};

extern struct rvctrs_syms rvctrs_syms;

void rvctrs_init(SEXP vctrs_ns);

// -----------------------------------------------------------------------------
// Inline wrappers
// -----------------------------------------------------------------------------

static inline SEXP rvctrs_vec_cast(SEXP x, SEXP to) {
  SEXP call = KEEP(Rf_lang3(rvctrs_syms.vec_cast, x, to));
  SEXP out = Rf_eval(call, tibblify_ns_env);
  FREE(1);
  return out;
}

static inline bool rvctrs_vec_is(SEXP x, SEXP ptype) {
  SEXP call = KEEP(Rf_lang3(rvctrs_syms.vec_is, x, ptype));
  SEXP out = KEEP(Rf_eval(call, tibblify_ns_env));
  bool res = Rf_asLogical(out) == 1;
  FREE(2);
  return res;
}

static inline SEXP rvctrs_list_unchop(SEXP x, SEXP ptype) {
  // Construct: list_unchop(x, ptype = ptype, name_spec = zap())
  // We use Rf_lang4 and set tags for the named arguments.

  // arg1: x (no tag)
  // arg2: ptype (tag: ptype)
  // arg3: name_spec (tag: name_spec) -> value is rvctrs_syms.zap

  SEXP call = KEEP(Rf_lang4(rvctrs_syms.list_unchop, x, ptype, rvctrs_syms.zap));

  // Set names (tags) for arguments 2 and 3
  // arguments are in the cdr of the call node
  SEXP args = CDR(call); // points to node containing x

  args = CDR(args); // points to node containing ptype
  SET_TAG(args, rvctrs_syms.ptype);

  args = CDR(args); // points to node containing zap
  SET_TAG(args, rvctrs_syms.name_spec);

  SEXP out = Rf_eval(call, tibblify_ns_env);
  FREE(1);
  return out;
}

#endif

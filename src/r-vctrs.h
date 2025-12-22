#ifndef R_VCTRS_H
#define R_VCTRS_H

#include <rlang.h>

struct rvctrs_syms {
  r_obj* vec_cast;
};

extern struct rvctrs_syms rvctrs_syms;

void rvctrs_init(SEXP vctrs_ns);

SEXP rvctrs_vec_cast(SEXP x, SEXP to);

#endif

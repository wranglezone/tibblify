#ifndef TIBBLIFY_H
#define TIBBLIFY_H

#include <Rinternals.h>
#include <R_ext/Rdynload.h>

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <rlang.h>
#include <vctrs.h>

/**
 * Allocate a shared (non-garbage-collected) R vector.
 *
 * Used to create permanent R objects (e.g., class strings, symbols) that must
 * persist for the lifetime of the package. The returned object is not
 * protected by the R garbage collector and must be preserved with
 * `r_preserve_global()` or similar before use.
 *
 * @param type The R type (`SEXPTYPE`) of the vector.
 * @param n The length of the vector.
 * @return A new, unprotected R vector of the given type and length.
 */
SEXP r_new_shared_vector(SEXPTYPE type, R_len_t n);

extern SEXP tibblify_ns_env;

extern SEXP classes_list_of;

extern SEXP strings_empty;
extern SEXP strings_object;

extern SEXP syms_transform;
extern SEXP syms_value;
extern SEXP syms_x;
extern SEXP syms_ptype;

extern SEXP syms_vec_is;
extern SEXP syms_vec_flatten;

/**
 * Pre-interned R strings for the `input_form` spec field.
 *
 * Initialized at package load via `tibblify_init_utils()`. Use pointer
 * equality (`==`) rather than string comparison for fast dispatch.
 */
struct r_string_input_form_struct {
  r_obj* rowmajor;
  r_obj* colmajor;
};
extern struct r_string_input_form_struct r_string_input_form;

/**
 * Pre-interned R strings for the collector `type` field.
 *
 * Initialized at package load via `tibblify_init_utils()`. Use pointer
 * equality (`==`) rather than string comparison for fast dispatch.
 */
struct r_string_types_struct {
  r_obj* sub;
  r_obj* row;
  r_obj* df;
  r_obj* scalar;
  r_obj* vector;
  r_obj* unspecified;
  r_obj* variant;
  r_obj* recursive;
};
extern struct r_string_types_struct r_string_types;

/**
 * Pre-interned R strings for the vector collector `input_form` field.
 *
 * Initialized at package load via `tibblify_init_utils()`. Use pointer
 * equality (`==`) rather than string comparison for fast dispatch.
 */
struct r_vector_form_struct {
  r_obj* vector;
  r_obj* scalar_list;
  r_obj* object_list;
};
extern struct r_vector_form_struct r_vector_form;

#endif

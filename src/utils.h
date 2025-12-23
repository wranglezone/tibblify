#ifndef TIBBLIFY_UTILS_H
#define TIBBLIFY_UTILS_H

#include "collector.h"
#include "tibblify.h"

// -----------------------------------------------------------------------------
// Type predicates
// -----------------------------------------------------------------------------

/**
 * Check if an object is a list.
 *
 * This checks the underlying R type (VECSXP). It returns true for both bare lists
 * and objects built on top of lists (like data frames).
 *
 * @param x The object to check.
 * @return true if TYPEOF(x) == VECSXP.
 */
static inline bool r_is_list(SEXP x) {
  return r_typeof(x) == R_TYPE_list;
}

/**
 * Check if an object is a data frame.
 *
 * Checks if the object is a list (VECSXP) and inherits from "data.frame".
 *
 * @param x The object to check.
 * @return true if x is a data frame.
 */
static inline bool r_is_data_frame(SEXP x) {
  return r_is_list(x) && r_inherits(x, "data.frame");
}

/**
 * Check if an object is a "bare" list.
 *
 * A bare list is a VECSXP that does not have a class attribute (is not an S3
 * object), or where the class attribute is "list". This excludes data frames
 * and other S3 list-based classes.
 *
 * @param x The object to check.
 * @return true if x is a list and not any other type of object, false
 * otherwise.
 */
static inline bool r_is_bare_list(r_obj* x) {
  return r_is_list(x) && !r_is_object(x);
}

// -----------------------------------------------------------------------------
// Other
// -----------------------------------------------------------------------------

static inline
r_obj* alloc_df(r_ssize n_rows, r_ssize n_cols, r_obj* col_names) {
  r_obj* df = KEEP(r_alloc_list(n_cols));
  r_attrib_poke_names(df, col_names);
  r_init_tibble(df, n_rows);

  FREE(1);
  return(df);
}

static inline
void r_poke_list_of(r_obj* x, r_obj* ptype) {
  r_attrib_poke_class(x, classes_list_of);
  r_attrib_poke(x, syms_ptype, ptype);
}

r_obj* r_list_get_by_name(r_obj* x, const char* nm);

r_obj* apply_transform(r_obj* value, r_obj* fn);

static inline
r_obj* names2(r_obj* x) {
  // simplified version of `rlang::ffi_names2()`
  r_obj* nms = r_names(x);

  if (nms == r_null) {
    r_ssize n = r_length(x);
    nms = KEEP(r_alloc_character(n));
    r_chr_fill(nms, strings_empty, n);
  } else {
    KEEP(nms);
  }

  FREE(1);
  return nms;
}

void match_chr(r_obj* needles_sorted,
               r_obj* haystack,
               int* indices,
               const r_ssize n_haystack);

bool chr_equal(r_obj* x, r_obj* y);

void check_names_unique(r_obj* field_names,
                        const int ind[],
                        const int n_fields,
                        const struct Path* path);

#endif

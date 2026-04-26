#include "collector.h"
#include "tibblify.h"
#include "conditions.h"
#include "utils.h"
#include "parse-spec.h"
#include "add-value.h"
#include "finalize.h"
#include "r-vctrs.h"

/**
 * @file collector.c
 * @brief Collector construction, allocation, and copy logic.
 *
 * This file implements the lifecycle of `struct collector` objects:
 * - `alloc_*`: prepare storage before a parse pass.
 * - `check_colmajor_nrows_*`: validate column lengths in col-major mode.
 * - `get_ptype_*`: compute output prototypes for `list_of` columns.
 * - `copy_*`: deep-copy collectors for the recursive parser.
 * - `new_*_collector`: construct fully-initialized collectors from spec data.
 * - `assign_in_multi_collector`: place a finalized column into its output
 *   frame.
 *
 * All public entry points are declared in `collector.h`.
 */

// for colmajor there is no need to allocate space as the data is used as is
#define ALLOC_SCALAR_COLLECTOR(RTYPE, BEGIN, COLL)             \
  v_collector->current_row = 0;                                \
                                                               \
  if (!v_collector->rowmajor) {                                \
    return;                                                    \
  }                                                            \
                                                               \
  r_obj* col = KEEP(r_alloc_vector(RTYPE, n_rows));            \
  r_list_poke(v_collector->shelter, 0, col);                   \
  v_collector->data = col;                                     \
  v_collector->details.COLL.v_data = BEGIN(col);               \
                                                               \
  FREE(1);

/**
 * Allocate storage for a logical scalar collector.
 *
 * @param v_collector The collector to initialize.
 * @param n_rows      Number of rows to allocate for (ignored in col-major
 *                    mode).
 */
void alloc_lgl_collector(struct collector* v_collector, r_ssize n_rows) {
  ALLOC_SCALAR_COLLECTOR(R_TYPE_logical, r_lgl_begin, lgl_coll);
}

/**
 * Allocate storage for an integer scalar collector.
 *
 * @param v_collector The collector to initialize.
 * @param n_rows      Number of rows to allocate for (ignored in col-major
 *                    mode).
 */
void alloc_int_collector(struct collector* v_collector, r_ssize n_rows) {
  ALLOC_SCALAR_COLLECTOR(R_TYPE_integer, r_int_begin, int_coll);
}

/**
 * Allocate storage for a double scalar collector.
 *
 * @param v_collector The collector to initialize.
 * @param n_rows      Number of rows to allocate for (ignored in col-major
 *                    mode).
 */
void alloc_dbl_collector(struct collector* v_collector, r_ssize n_rows) {
  ALLOC_SCALAR_COLLECTOR(R_TYPE_double, r_dbl_begin, dbl_coll);
}

// character and non-atomic scalars can't assign via a pointer but need to use
// a barrier. Therefore, `v_data` isn't assigned here.
#define ALLOC_SCALAR_COLLECTOR_BARRIER(RTYPE)                  \
  v_collector->current_row = 0;                                \
                                                               \
  if (!v_collector->rowmajor) {                                \
    return;                                                    \
  }                                                            \
                                                               \
  r_obj* col = KEEP(r_alloc_vector(RTYPE, n_rows));            \
  r_list_poke(v_collector->shelter, 0, col);                   \
  v_collector->data = col;                                     \
                                                               \
  FREE(1);                                                     \

/**
 * Allocate storage for a character scalar collector.
 *
 * @param v_collector The collector to initialize.
 * @param n_rows      Number of rows to allocate for (ignored in col-major
 *                    mode).
 */
void alloc_chr_collector(struct collector* v_collector, r_ssize n_rows) {
  ALLOC_SCALAR_COLLECTOR_BARRIER(R_TYPE_character);
}

/**
 * Allocate storage for a non-atomic scalar collector.
 *
 * Non-atomic scalars are staged in an intermediate list, then unchopped during
 * finalization. FIXME: use `vec_init()` / `vec_assign()` once exported by
 * vctrs.
 *
 * @param v_collector The collector to initialize.
 * @param n_rows      Number of rows to allocate for (ignored in col-major
 *                    mode).
 */
void alloc_scalar_collector(struct collector* v_collector, r_ssize n_rows) {
  ALLOC_SCALAR_COLLECTOR_BARRIER(R_TYPE_list);
}

/**
 * Allocate storage for a vector (list-of) collector.
 *
 * Unlike scalar collectors, vector collectors must allocate in both row-major
 * and col-major modes because each row stores a separate R object in the list.
 *
 * @param v_collector The collector to initialize.
 * @param n_rows      Number of rows to allocate for.
 */
void alloc_vector_collector(struct collector* v_collector, r_ssize n_rows) {
  v_collector->current_row = 0;

  r_obj* col = KEEP(r_alloc_list(n_rows));
  r_list_poke(v_collector->shelter, 0, col);
  v_collector->data = col;

  FREE(1);
}

/**
 * Allocate storage for a variant (untyped list) collector.
 *
 * Variant collectors share the same list-backed storage layout as vector
 * collectors, so this delegates directly to `alloc_vector_collector()`.
 *
 * @param v_collector The collector to initialize.
 * @param n_rows      Number of rows to allocate for.
 */
void alloc_variant_collector(struct collector* v_collector, r_ssize n_rows) {
  alloc_vector_collector(v_collector, n_rows);
}

// See collector.h for documentation.
void alloc_row_collector(struct collector* v_collector, r_ssize n_rows) {
  v_collector->details.multi_coll.n_rows = n_rows;
  r_ssize n_coll = v_collector->details.multi_coll.n_keys;

  struct collector* v_collectors = v_collector->details.multi_coll.collectors;
  for (r_ssize j = 0; j < n_coll; ++j) {
    v_collectors[j].alloc(&v_collectors[j], n_rows);
  }
}

/**
 * Allocate storage for a df collector.
 *
 * The df collector accumulates one tibble per input row in an intermediate
 * list, finalized into a `list_of` column.
 *
 * @param v_collector The collector to initialize.
 * @param n_rows      Number of rows to allocate for.
 */
void alloc_df_collector(struct collector* v_collector, r_ssize n_rows) {
  v_collector->current_row = 0;

  r_obj* col = KEEP(r_alloc_list(n_rows));
  r_list_poke(v_collector->shelter, 0, col);
  v_collector->data = col;

  FREE(1);
}

/**
 * Allocate storage for a recursive collector.
 *
 * Recursive collectors use the same list-backed storage layout as df
 * collectors, so this delegates directly to `alloc_df_collector()`.
 *
 * @param v_collector The collector to initialize.
 * @param n_rows      Number of rows to allocate for.
 */
void alloc_recursive_collector(struct collector* v_collector, r_ssize n_rows) {
  alloc_df_collector(v_collector, n_rows);
}

// -----------------------------------------------------------------------------

/**
 * Validate the col-major row count for a scalar, vector, or variant collector.
 *
 * @param v_collector The collector being validated.
 * @param value       The col-major field value.
 * @param n_rows      In/out: number of rows; established on the first call and
 *                    verified to be consistent on subsequent calls.
 * @param v_path      Current path for error reporting.
 * @param nrow_path   Path of the first field that established `*n_rows`.
 */
void check_colmajor_nrows_default(struct collector* v_collector,
                                   r_obj* value,
                                   r_ssize* n_rows,
                                   struct Path* v_path,
                                   struct Path* nrow_path) {
  if (value == r_null) {
    stop_colmajor_null(v_path->data);
  }

  r_ssize n_value = short_vec_size(value);
  check_colmajor_size(n_value, n_rows, v_path, nrow_path);
}

/**
 * Validate the col-major row count for a row or sub collector.
 *
 * Checks field counts across all child collectors, then verifies that the
 * result is consistent with any previously established `*n_rows`.
 *
 * @param v_collector The row or sub collector being validated.
 * @param value       The col-major named list representing the object.
 * @param n_rows      In/out: number of rows; established on the first call and
 *                    verified to be consistent on subsequent calls.
 * @param v_path      Current path for error reporting.
 * @param nrow_path   Path of the first field that established `*n_rows`.
 */
void check_colmajor_nrows_row_collector(struct collector* v_collector,
                                        r_obj* value,
                                        r_ssize* n_rows,
                                        struct Path* v_path,
                                        struct Path* nrow_path) {
  r_ssize n_value = get_collector_vec_rows(v_collector, value, n_rows,
                                           v_path, nrow_path);
  check_colmajor_size(n_value, n_rows, v_path, nrow_path);
}

// See collector.h for documentation.
r_ssize get_collector_vec_rows(struct collector* v_collector,
                               r_obj* object_list,
                               r_ssize* n_rows,
                               struct Path* v_path,
                               struct Path* nrow_path) {
  check_list(object_list, v_path);

  r_obj* field_names = check_names_not_null(object_list, v_path);

  struct multi_collector* v_multi_coll = &v_collector->details.multi_coll;
  match_chr(v_multi_coll->keys,
            field_names,
            v_multi_coll->p_key_match_ind,
            r_length(field_names));

  r_obj* const * v_object_list = r_list_cbegin(object_list);
  r_obj* const * v_keys = r_chr_cbegin(v_multi_coll->keys);
  struct collector* v_collectors = v_multi_coll->collectors;

  path_down(v_path);
  for (int key_index = 0; key_index < v_multi_coll->n_keys; ++key_index) {
    int loc = v_multi_coll->p_key_match_ind[key_index];
    r_obj* cur_key = v_keys[key_index];
    path_replace_key(v_path, cur_key);

    if (loc < 0) {
      stop_required_colmajor(v_path->data);
    }

    r_obj* field = v_object_list[loc];
    struct collector* v_coll_cur = &v_collectors[key_index];
    v_coll_cur->check_colmajor_nrows(v_coll_cur, field, n_rows, v_path,
                                     nrow_path);
  }
  path_up(v_path);

  return *n_rows;
}

// -----------------------------------------------------------------------------

/**
 * Return the output prototype for a scalar collector.
 *
 * @param v_collector The scalar collector.
 * @return The prototype R object used for the final `vec_cast()`.
 */
r_obj* get_ptype_scalar(struct collector* v_collector) {
  return v_collector->ptype;
}

/**
 * Return an empty `list_of` prototype for a vector collector.
 *
 * @param v_collector The vector collector.
 * @return A length-0 list with the `list_of` ptype attribute set.
 */
r_obj* get_ptype_vector(struct collector* v_collector) {
  r_obj* ptype = KEEP(r_alloc_list(0));
  r_poke_list_of(ptype, v_collector->details.vec_coll.list_of_ptype);
  FREE(1);

  return ptype;
}

/**
 * Return an empty list as the prototype for a variant collector.
 *
 * @param v_collector The variant collector (unused; present for a uniform
 *                    signature).
 * @return A length-0 untyped list.
 */
r_obj* get_ptype_variant(struct collector* v_collector) {
  return r_globals.empty_list;
}

// See collector.h for documentation.
r_obj* get_ptype_row(struct collector* v_collector) {
  struct multi_collector* p_multi_coll = &v_collector->details.multi_coll;
  r_ssize n_cols = p_multi_coll->n_cols;
  r_obj* df = KEEP(alloc_df(0, n_cols, p_multi_coll->col_names));

  struct collector* v_collectors = p_multi_coll->collectors;
  for (r_ssize i = 0; i < p_multi_coll->n_keys; ++i) {
    struct collector* v_coll_i = &v_collectors[i];
    r_obj* col = KEEP(v_coll_i->get_ptype(v_coll_i));

    r_obj* ffi_locs = r_list_get(p_multi_coll->coll_locations, i);
    assign_in_multi_collector(df, col, v_coll_i->unpack, ffi_locs);
    FREE(1);
  }

  if (p_multi_coll->names_col != r_null) {
    r_list_poke(df, 0, r_globals.empty_chr);
  }

  FREE(1);
  return df;
}

/**
 * Return an empty `list_of<tibble>` prototype for a df collector.
 *
 * @param v_collector The df collector.
 * @return A length-0 list with the `list_of` ptype attribute set to a 0-row
 *         tibble reflecting the collector's child schema.
 */
r_obj* get_ptype_df(struct collector* v_collector) {
  r_obj* ptype = KEEP(r_alloc_list(0));

  r_obj* list_of_ptype = KEEP(get_ptype_row(v_collector));
  r_poke_list_of(ptype, list_of_ptype);

  FREE(2);
  return ptype;
}

/**
 * Return an empty list as the prototype for a recursive collector.
 *
 * @param v_collector The recursive collector (unused; present for a uniform
 *                    signature).
 * @return A length-0 untyped list.
 */
r_obj* get_ptype_recursive(struct collector* v_collector) {
  return r_globals.empty_list;
}

// -----------------------------------------------------------------------------

/**
 * Shallow-copy a collector into a new GC-protected allocation.
 *
 * Allocates a fresh shelter of `shelter_size` slots, copies the collector
 * struct byte-for-byte, and points the copy's `shelter` at the new allocation.
 * Slot 0 of the shelter is reserved for `data`; slot 1 holds the collector raw.
 * Callers are responsible for re-pointing any inner raw allocations.
 *
 * @param shelter_size Number of GC shelter slots to allocate.
 * @param p_coll       The collector to copy.
 * @return A fresh heap-allocated copy; ownership transferred to caller.
 */
struct collector* copy_collector_generic(int shelter_size,
                                         struct collector* p_coll) {
  r_obj* shelter = KEEP(r_alloc_list(shelter_size));

  r_obj* coll_raw = r_alloc_raw(sizeof(struct collector));
  r_list_poke(shelter, 1, coll_raw);
  struct collector* p_coll_new = r_raw_begin(coll_raw);
  *p_coll_new = *p_coll;
  p_coll_new->shelter = shelter;

  FREE(1);
  return p_coll_new;
}

/**
 * Copy a simple (non-multi) collector.
 *
 * Uses a 2-slot shelter: slot 0 for `data`, slot 1 for the collector raw.
 *
 * @param p_coll The collector to copy.
 * @return A fresh heap-allocated copy; ownership transferred to caller.
 */
struct collector* copy_collector(struct collector* p_coll) {
  return copy_collector_generic(2, p_coll);
}

/**
 * Deep-copy a multi-collector (row, sub, or df).
 *
 * Re-allocates the inner `multi_collector` struct, the `key_match_ind` buffer,
 * and the `collectors` array, then recursively copies each child collector.
 * FIXME: it might be clearer to call `new_multi_collector()` with the right
 * arguments.
 *
 * @param p_coll The multi-collector to copy.
 * @return A fresh heap-allocated deep copy; ownership transferred to caller.
 */
struct collector* copy_multi_collector(struct collector* p_coll) {
  struct multi_collector* p_multi_coll = &p_coll->details.multi_coll;
  r_ssize n_keys = p_multi_coll->n_keys;

  struct collector* p_coll_new = copy_collector_generic(5 + n_keys, p_coll);
  KEEP(p_coll_new->shelter);

  r_obj* multi_coll_raw = KEEP(r_alloc_raw(sizeof(struct multi_collector)));
  r_list_poke(p_coll_new->shelter, 2, multi_coll_raw);
  struct multi_collector* p_multi_coll_new = r_raw_begin(multi_coll_raw);
  *p_multi_coll_new = p_coll_new->details.multi_coll;

  r_obj* key_match_ind = KEEP(r_alloc_raw(n_keys * sizeof(r_ssize)));
  r_list_poke(p_coll_new->shelter, 3, key_match_ind);
  p_multi_coll_new->key_match_ind = key_match_ind;

  int* p_key_match_ind = r_raw_begin(key_match_ind);
  for (int i = 0; i < n_keys; ++i) {
    p_key_match_ind[i] = (r_ssize) i;
  }
  p_multi_coll_new->p_key_match_ind = p_key_match_ind;

  p_multi_coll_new->field_names_prev = r_globals.empty_chr;

  r_obj* collectors_raw = KEEP(r_alloc_raw(sizeof(struct collector) * n_keys));
  r_list_poke(p_coll_new->shelter, 4, collectors_raw);
  p_multi_coll_new->collectors = r_raw_begin(collectors_raw);

  for (r_ssize i = 0; i < n_keys; ++i) {
    struct collector* p_coll_i = &p_multi_coll->collectors[i];
    struct collector* p_coll_i_new = p_coll_i->copy(p_coll_i);
    r_list_poke(p_coll_new->shelter, 5 + i, p_coll_i_new->shelter);
    p_multi_coll_new->collectors[i] = *p_coll_i_new;
  }

  p_coll_new->details.multi_coll = *p_multi_coll_new;

  FREE(4);
  return p_coll_new;
}

// -----------------------------------------------------------------------------

// See collector.h for documentation.
struct collector* new_scalar_collector(bool required,
                                       r_obj* ptype,
                                       r_obj* ptype_inner,
                                       r_obj* default_value,
                                       r_obj* transform,
                                       r_obj* na,
                                       bool rowmajor) {
  r_obj* shelter = KEEP(r_alloc_list(2));

  r_obj* coll_raw = r_alloc_raw(sizeof(struct collector));
  r_list_poke(shelter, 1, coll_raw);
  struct collector* p_coll = r_raw_begin(coll_raw);

  p_coll->shelter = shelter;
  if (rvctrs_vec_is(ptype_inner, r_globals.empty_lgl)) {
    p_coll->alloc = &alloc_lgl_collector;
    p_coll->add_value = &add_value_lgl;
    p_coll->add_value_colmajor = &add_value_lgl_colmajor;
    p_coll->add_default = &add_default_lgl;
    p_coll->finalize = &finalize_atomic_scalar;
    p_coll->details.lgl_coll.default_value = *r_lgl_begin(default_value);
    // `ptype_inner` and `na` don't need to be stored b/c of the appropriate
    // functions used
  } else if (rvctrs_vec_is(ptype_inner, r_globals.empty_int)) {
    p_coll->alloc = &alloc_int_collector;
    p_coll->add_value = &add_value_int;
    p_coll->add_value_colmajor = &add_value_int_colmajor;
    p_coll->add_default = &add_default_int;
    p_coll->finalize = &finalize_atomic_scalar;
    p_coll->details.int_coll.default_value = *r_int_begin(default_value);
  } else if (rvctrs_vec_is(ptype_inner, r_globals.empty_dbl)) {
    p_coll->alloc = &alloc_dbl_collector;
    p_coll->add_value = &add_value_dbl;
    p_coll->add_value_colmajor = &add_value_dbl_colmajor;
    p_coll->add_default = &add_default_dbl;
    p_coll->finalize = &finalize_atomic_scalar;
    p_coll->details.dbl_coll.default_value = *r_dbl_begin(default_value);
  } else if (rvctrs_vec_is(ptype_inner, r_globals.empty_chr)) {
    p_coll->alloc = &alloc_chr_collector;
    p_coll->add_value = &add_value_chr;
    p_coll->add_value_colmajor = &add_value_chr_colmajor;
    p_coll->add_default = &add_default_chr;
    p_coll->finalize = &finalize_atomic_scalar;
    p_coll->details.chr_coll.default_value = r_chr_get(default_value, 0);
  } else {
    p_coll->alloc = &alloc_scalar_collector;
    p_coll->add_value = &add_value_scalar;
    p_coll->add_value_colmajor = &add_value_scalar_colmajor;
    p_coll->add_default = &add_default_scalar;
    p_coll->finalize = &finalize_scalar;
    p_coll->details.scalar_coll.default_value = default_value;
    p_coll->details.scalar_coll.ptype_inner = ptype_inner;
    p_coll->details.scalar_coll.na = na;
  }
  p_coll->check_colmajor_nrows = &check_colmajor_nrows_default;
  p_coll->get_ptype = &get_ptype_scalar;
  p_coll->copy = &copy_collector;
  p_coll->rowmajor = rowmajor;
  p_coll->unpack = false;
  assign_f_absent(p_coll, required);

  p_coll->ptype = ptype;
  p_coll->transform = transform;

  FREE(1);
  return p_coll;
}

// See collector.h for documentation.
struct collector* new_vector_collector(bool required,
                                       r_obj* ptype,
                                       r_obj* ptype_inner,
                                       r_obj* default_value,
                                       r_obj* transform,
                                       r_obj* input_form,
                                       bool vector_allows_empty_list,
                                       r_obj* names_to,
                                       r_obj* values_to,
                                       r_obj* na,
                                       r_obj* elt_transform,
                                       r_obj* col_names,
                                       r_obj* list_of_ptype,
                                       bool rowmajor) {
  r_obj* shelter = KEEP(r_alloc_list(3));

  r_obj* coll_raw = r_alloc_raw(sizeof(struct collector));
  r_list_poke(shelter, 1, coll_raw);
  struct collector* p_coll = r_raw_begin(coll_raw);

  p_coll->shelter = shelter;
  p_coll->get_ptype = &get_ptype_vector;
  p_coll->copy = &copy_collector;
  p_coll->alloc = &alloc_vector_collector;
  p_coll->add_value = &add_value_vector;
  p_coll->add_value_colmajor = &add_value_vector_colmajor;
  p_coll->add_default = &add_default_vector;
  p_coll->finalize = &finalize_vector;
  p_coll->check_colmajor_nrows = &check_colmajor_nrows_default;
  p_coll->rowmajor = rowmajor;
  p_coll->unpack = false;
  assign_f_absent(p_coll, required);

  p_coll->ptype = ptype;
  p_coll->transform = transform;

  r_obj* vec_coll_raw = r_alloc_raw(sizeof(struct vector_collector));
  r_list_poke(shelter, 2, vec_coll_raw);
  struct vector_collector* p_vec_coll = r_raw_begin(vec_coll_raw);

  p_vec_coll->ptype_inner = ptype_inner;
  p_vec_coll->default_value = default_value;
  p_vec_coll->na = na;
  p_vec_coll->elt_transform = elt_transform;
  p_vec_coll->vector_allows_empty_list = vector_allows_empty_list;
  p_vec_coll->input_form = r_to_vector_form(input_form);
  p_vec_coll->col_names = col_names;
  p_vec_coll->list_of_ptype = list_of_ptype;

  if (names_to != r_null) {
    p_vec_coll->prep_data = &vec_prep_values_names;
  } else if (values_to != r_null) {
    p_vec_coll->prep_data = &vec_prep_values;
  } else {
    p_vec_coll->prep_data = &vec_prep_simple;
  }
  p_coll->details.vec_coll = *p_vec_coll;

  FREE(1);
  return p_coll;
}

// See collector.h for documentation.
struct collector* new_variant_collector(bool required,
                                        r_obj* default_value,
                                        r_obj* transform,
                                        r_obj* elt_transform,
                                        bool rowmajor) {
  r_obj* shelter = KEEP(r_alloc_list(3));

  r_obj* coll_raw = r_alloc_raw(sizeof(struct collector));
  r_list_poke(shelter, 1, coll_raw);
  struct collector* p_coll = r_raw_begin(coll_raw);

  p_coll->shelter = shelter;
  p_coll->get_ptype = &get_ptype_variant;
  p_coll->copy = &copy_collector;
  p_coll->alloc = &alloc_variant_collector;
  p_coll->add_value = &add_value_variant;
  p_coll->add_value_colmajor = &add_value_variant_colmajor;
  p_coll->add_default = &add_default_variant;
  p_coll->finalize = &finalize_variant;
  p_coll->check_colmajor_nrows = &check_colmajor_nrows_default;
  p_coll->rowmajor = rowmajor;
  p_coll->unpack = false;
  assign_f_absent(p_coll, required);

  p_coll->transform = transform;

  r_obj* variant_coll_raw = KEEP(r_alloc_raw(sizeof(struct variant_collector)));
  r_list_poke(p_coll->shelter, 2, variant_coll_raw);
  struct variant_collector* p_variant_coll = r_raw_begin(variant_coll_raw);
  p_variant_coll->elt_transform = elt_transform;
  p_variant_coll->default_value = default_value;

  p_coll->details.variant_coll = *p_variant_coll;

  FREE(2);
  return p_coll;
}

/**
 * Construct a multi-collector (row, sub, or df) from spec data.
 *
 * This is the shared implementation called by `new_row_collector()`,
 * `new_sub_collector()`, `new_df_collector()`, and `new_parser()`. The
 * `coll_type` parameter selects the correct function pointer set; child
 * collectors are attached later by `create_parser()` in `parse-spec.c`.
 *
 * @param coll_type      One of `COLLECTOR_TYPE_row`, `_sub`, or `_df`.
 * @param required       Error if the field is absent.
 * @param n_keys         Number of child keys.
 * @param coll_locations Mapping from key index to output column location(s).
 * @param col_names      Output column names.
 * @param names_col      Column name for capturing input names, or `r_null`.
 * @param keys           Sorted character vector of expected field names.
 * @param ptype_dummy    Prototype placeholder.
 * @param n_cols         Number of output columns.
 * @param rowmajor       `true` for row-major input.
 * @return A heap-allocated collector; ownership transferred to caller.
 */
struct collector* new_multi_collector(enum collector_type coll_type,
                                      bool required,
                                      int n_keys,
                                      r_obj* coll_locations,
                                      r_obj* col_names,
                                      r_obj* names_col,
                                      r_obj* keys,
                                      r_obj* ptype_dummy,
                                      int n_cols,
                                      bool rowmajor) {
  r_obj* shelter = KEEP(r_alloc_list(5 + n_keys));

  r_obj* coll_raw = r_alloc_raw(sizeof(struct collector));
  r_list_poke(shelter, 1, coll_raw);
  struct collector* p_coll = r_raw_begin(coll_raw);

  p_coll->shelter = shelter;

  switch(coll_type) {
  case COLLECTOR_TYPE_sub:
  case COLLECTOR_TYPE_row:
    p_coll->get_ptype = &get_ptype_row;
    p_coll->alloc = &alloc_row_collector;
    p_coll->add_value = &add_value_row;
    p_coll->add_value_colmajor = &add_value_row_colmajor;
    p_coll->add_default = &add_default_row;
    p_coll->finalize = &finalize_row;
    p_coll->check_colmajor_nrows = &check_colmajor_nrows_row_collector;
    p_coll->unpack = coll_type == COLLECTOR_TYPE_sub;
    break;
  case COLLECTOR_TYPE_df:
    p_coll->get_ptype = &get_ptype_df;
    p_coll->alloc = &alloc_df_collector;
    p_coll->add_value = &add_value_df;
    p_coll->add_value_colmajor = &add_value_df_colmajor;
    p_coll->add_default = &add_default_df;
    p_coll->finalize = &finalize_df;
    p_coll->check_colmajor_nrows = &check_colmajor_nrows_default;
    p_coll->unpack = false;
    break;
  default: // # nocov
    r_stop_internal("Unexpected collector type."); // # nocov
  }
  p_coll->copy = &copy_multi_collector;

  assign_f_absent(p_coll, required);
  p_coll->ptype = ptype_dummy;
  p_coll->rowmajor = rowmajor;

  r_obj* multi_coll_raw = KEEP(r_alloc_raw(sizeof(struct multi_collector)));
  r_list_poke(shelter, 2, multi_coll_raw);
  struct multi_collector* p_multi_coll = r_raw_begin(multi_coll_raw);
  p_multi_coll->n_keys = n_keys;
  p_multi_coll->keys = keys;

  r_obj* key_match_ind = KEEP(r_alloc_raw(n_keys * sizeof(r_ssize)));
  r_list_poke(p_coll->shelter, 3, key_match_ind);
  p_multi_coll->key_match_ind = key_match_ind;
  int* p_key_match_ind = r_raw_begin(key_match_ind);
  for (int i = 0; i < n_keys; ++i) {
    p_key_match_ind[i] = (r_ssize) i;
  }
  p_multi_coll->p_key_match_ind = p_key_match_ind;

  for (int i = 0; i < 256; ++i) {
    p_multi_coll->field_order_ind[i] = i;
  }

  p_multi_coll->n_cols = n_cols;
  p_multi_coll->col_names = col_names;
  p_multi_coll->coll_locations = coll_locations;
  p_multi_coll->names_col = names_col;
  p_multi_coll->field_names_prev = r_globals.empty_chr;

  r_obj* collectors_raw = KEEP(r_alloc_raw(sizeof(struct collector) * n_keys));
  r_list_poke(shelter, 4, collectors_raw);
  p_multi_coll->collectors = r_raw_begin(collectors_raw);

  p_coll->details.multi_coll = *p_multi_coll;

  FREE(4);
  return p_coll;
}

// See collector.h for documentation.
struct collector* new_parser(int n_keys,
                             r_obj* coll_locations,
                             r_obj* col_names,
                             r_obj* names_col,
                             r_obj* keys,
                             r_obj* ptype_dummy,
                             int n_cols,
                             bool rowmajor) {
  return new_multi_collector(COLLECTOR_TYPE_row,
                             false,
                             n_keys,
                             coll_locations,
                             col_names,
                             names_col,
                             keys,
                             ptype_dummy,
                             n_cols,
                             rowmajor);
}

// See collector.h for documentation.
struct collector* new_row_collector(bool required,
                                    int n_keys,
                                    r_obj* coll_locations,
                                    r_obj* col_names,
                                    r_obj* keys,
                                    r_obj* ptype_dummy,
                                    int n_cols,
                                    bool rowmajor) {
  return new_multi_collector(COLLECTOR_TYPE_row,
                             required,
                             n_keys,
                             coll_locations,
                             col_names,
                             r_null,
                             keys,
                             ptype_dummy,
                             n_cols,
                             rowmajor);
}

// See collector.h for documentation.
struct collector* new_sub_collector(int n_keys,
                                    r_obj* coll_locations,
                                    r_obj* col_names,
                                    r_obj* keys,
                                    r_obj* ptype_dummy,
                                    int n_cols,
                                    bool rowmajor) {
  return new_multi_collector(COLLECTOR_TYPE_sub,
                             false,
                             n_keys,
                             coll_locations,
                             col_names,
                             r_null,
                             keys,
                             ptype_dummy,
                             n_cols,
                             rowmajor);
}

// See collector.h for documentation.
struct collector* new_df_collector(bool required,
                                   int n_keys,
                                   r_obj* coll_locations,
                                   r_obj* col_names,
                                   r_obj* names_col,
                                   r_obj* keys,
                                   r_obj* ptype_dummy,
                                   int n_cols,
                                   bool rowmajor) {
  return new_multi_collector(COLLECTOR_TYPE_df,
                             required,
                             n_keys,
                             coll_locations,
                             col_names,
                             names_col,
                             keys,
                             ptype_dummy,
                             n_cols,
                             rowmajor);
}

// See collector.h for documentation.
struct collector* new_recursive_collector(void) {
  r_obj* shelter = KEEP(r_alloc_list(3));

  r_obj* coll_raw = r_alloc_raw(sizeof(struct collector));
  r_list_poke(shelter, 1, coll_raw);
  struct collector* p_coll = r_raw_begin(coll_raw);

  p_coll->shelter = shelter;
  p_coll->get_ptype = &get_ptype_recursive;
  p_coll->copy = &copy_collector;
  p_coll->alloc = &alloc_recursive_collector;
  p_coll->add_value = &add_value_recursive;
  p_coll->add_value_colmajor = &add_value_recursive_colmajor;
  p_coll->add_default = &add_default_recursive;
  p_coll->finalize = &finalize_recursive;
  // TODO
  p_coll->check_colmajor_nrows = &check_colmajor_nrows_default;
  p_coll->unpack = false;
  assign_f_absent(p_coll, false);

  r_obj* rec_coll_raw = r_alloc_raw(sizeof(struct recursive_collector));
  r_list_poke(shelter, 2, rec_coll_raw);
  struct recursive_collector* p_rec_coll = r_raw_begin(rec_coll_raw);
  p_coll->details.rec_coll = *p_rec_coll;

  FREE(1);
  return p_coll;
}

// See collector.h for documentation.
void assign_in_multi_collector(r_obj* x,
                               r_obj* xi,
                               bool unpack,
                               r_obj* ffi_locs) {
  // The sub collector is basically the same as the row collector but the fields
  // should not become columns. Rather they are into the parent structure.
  if (unpack) {
    r_ssize n_locs = short_vec_size(ffi_locs);
    for (r_ssize j = 0; j < n_locs; ++j) {
      int loc = r_int_get(ffi_locs, j);
      r_obj* val = r_list_get(xi, j);
      r_list_poke(x, loc, val);
    }
  } else {
    r_list_poke(x, r_int_get(ffi_locs, 0), xi);
  }
}

#ifndef TIBBLIFY_ADD_VALUE_H
#define TIBBLIFY_ADD_VALUE_H

/**
 * @file add-value.h
 * @brief Add/default dispatch helpers for collector population.
 *
 * This header exposes the function-pointer targets used by collector instances
 * while parsing values (`add_value*`) and filling missing fields
 * (`add_default*`). The same logical operations are provided for row-major and
 * col-major inputs.
 */

#include "utils.h"
#include "collector.h"
#include "Path.h"
#include "tibblify.h"

/**
 * Raise the "required field is absent" error for a collector field.
 *
 * @param v_collector Collector whose required field is missing.
 * @param path Path context used for error reporting.
 */
void add_stop_required(struct collector* v_collector, struct Path* path);

/**
 * Configure how absent fields are handled for a collector.
 *
 * If `required` is true, absent fields error via `add_stop_required()`;
 * otherwise they fall back to the collector's regular default handler.
 *
 * @param v_collector Collector whose `add_default_absent` callback is updated.
 * @param required Whether absent values should error instead of defaulting.
 */
static inline
void assign_f_absent(struct collector* v_collector, bool required) {
  if (required) {
    v_collector->add_default_absent = &add_stop_required;
  } else {
    v_collector->add_default_absent = v_collector->add_default;
  }
}

/**
 * Default writers used when a value is missing (`NULL`) in row-major parsing.
 */
void add_default_lgl(struct collector* v_collector, struct Path* path);
void add_default_int(struct collector* v_collector, struct Path* path);
void add_default_dbl(struct collector* v_collector, struct Path* path);
void add_default_chr(struct collector* v_collector, struct Path* path);
void add_default_scalar(struct collector* v_collector, struct Path* path);
void add_default_vector(struct collector* v_collector, struct Path* path);
void add_default_variant(struct collector* v_collector, struct Path* path);
void add_default_row(struct collector* v_collector, struct Path* path);
void add_default_df(struct collector* v_collector, struct Path* path);
void add_default_recursive(struct collector* v_collector, struct Path* path);

/**
 * Value writers used during row-major parsing.
 */
void add_value_lgl(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_int(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_dbl(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_chr(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_scalar(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_vector(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_variant(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_row(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_df(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_recursive(struct collector* v_collector, r_obj* value, struct Path* path);

/**
 * Value writers used during col-major parsing.
 *
 * These consume column vectors and append/parse each row into row-major
 * collector storage.
 */
void add_value_lgl_colmajor(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_int_colmajor(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_dbl_colmajor(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_chr_colmajor(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_scalar_colmajor(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_vector_colmajor(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_variant_colmajor(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_row_colmajor(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_df_colmajor(struct collector* v_collector, r_obj* value, struct Path* path);
void add_value_recursive_colmajor(struct collector* v_collector, r_obj* value, struct Path* path);

static inline
r_obj* vec_prep_simple(r_obj* value_casted, r_obj* names, r_obj* col_names) {
  return value_casted;
}

static inline
r_obj* vec_prep_values(r_obj* value_casted, r_obj* names, r_obj* col_names) {
  r_obj* df = KEEP(alloc_df(short_vec_size(value_casted), 1, col_names));

  r_list_poke(df, 0, value_casted);
  FREE(1);
  return df;
}

static inline
r_obj* vec_prep_values_names(r_obj* value_casted, r_obj* names, r_obj* col_names) {
  r_ssize n_rows = short_vec_size(value_casted);
  r_obj* df = KEEP(alloc_df(n_rows, 2, col_names));

  if (names == r_null) {
    names = KEEP(r_alloc_character(n_rows));
    r_chr_fill(names, r_globals.na_str, n_rows);
  } else {
    KEEP(names);
  }

  r_list_poke(df, 0, names);
  r_list_poke(df, 1, value_casted);
  FREE(2);
  return df;
}

/**
 * Parse a row-major data payload with a row collector parser.
 *
 * @param v_collector Parser/collector configured from the spec.
 * @param value Row-major payload (list or data frame) to parse.
 * @param v_path Mutable path tracker used for diagnostics.
 * @return Parsed row-major result after finalization.
 */
r_obj* parse(struct collector* v_collector, r_obj* value, struct Path* v_path);

/**
 * Parse a col-major payload by determining row count, allocating output, and
 * delegating to col-major add-value handlers.
 *
 * @param v_collector Parser/collector configured from the spec.
 * @param value Col-major payload to parse.
 * @param v_path Mutable path tracker used for diagnostics.
 * @return Parsed col-major result after finalization.
 */
r_obj* parse_colmajor(struct collector* v_collector, r_obj* value, struct Path* v_path);

#endif

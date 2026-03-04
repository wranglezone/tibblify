#ifndef TIBBLIFY_FINALIZE_H
#define TIBBLIFY_FINALIZE_H

#include "collector.h"
#include "tibblify.h"

/**
 * Finalize an atomic scalar collector (lgl, int, dbl, chr).
 *
 * Applies any transform and casts the accumulated vector to `ptype`.
 *
 * @param v_collector The collector to finalize.
 * @return The finalized R vector.
 */
r_obj* finalize_atomic_scalar(struct collector* v_collector);

/**
 * Finalize a non-atomic scalar collector.
 *
 * In row-major mode the intermediate list is unchoped into a vector before
 * casting; in col-major mode the data is already in vector form.
 *
 * @param v_collector The collector to finalize.
 * @return The finalized R vector.
 */
r_obj* finalize_scalar(struct collector* v_collector);

/**
 * Finalize a vector collector.
 *
 * Applies any transform and attaches the `list_of` ptype attribute.
 *
 * @param v_collector The collector to finalize.
 * @return The finalized `list_of` column.
 */
r_obj* finalize_vector(struct collector* v_collector);

/**
 * Finalize a variant collector.
 *
 * Applies any transform and returns the accumulated list as-is.
 *
 * @param v_collector The collector to finalize.
 * @return The finalized list column.
 */
r_obj* finalize_variant(struct collector* v_collector);

/**
 * Finalize a row collector into a tibble.
 *
 * Finalizes each child collector in turn and assembles the results into a
 * data frame, respecting `unpack` for sub-collectors.
 *
 * @param v_collector The collector to finalize.
 * @return A tibble with one column per key.
 */
r_obj* finalize_row(struct collector* v_collector);

/**
 * Finalize a sub-collector.
 *
 * Alias for `finalize_row()`; sub-collectors unpack their columns into the
 * parent data frame rather than nesting them.
 *
 * @param v_collector The collector to finalize.
 * @return A tibble whose columns will be unpacked into the parent.
 */
r_obj* finalize_sub(struct collector* v_collector);

/**
 * Finalize a df collector into a `list_of` column.
 *
 * Attaches the row ptype as the `list_of` attribute so the column is typed.
 *
 * @param v_collector The collector to finalize.
 * @return A `list_of<tibble>` column.
 */
r_obj* finalize_df(struct collector* v_collector);

/**
 * Finalize a recursive collector.
 *
 * Returns the accumulated data list directly without further processing.
 *
 * @param v_collector The collector to finalize.
 * @return The raw accumulated list.
 */
r_obj* finalize_recursive(struct collector* v_collector);

#endif

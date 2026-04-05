#ifndef TIBBLIFY_PATH_H
#define TIBBLIFY_PATH_H

#define R_NO_REMAP
#define STRICT_R_HEADERS
#include "tibblify.h"

/**
 * Tracks the current location within the nested list being parsed.
 *
 * Used to construct informative error messages when parsing fails. `data` is
 * the R-level path object surfaced in error conditions. `depth` points into a
 * single-element integer vector that records the current nesting level.
 * `path_elts` is a pre-allocated list of length 30 where each slot holds the
 * key (string) or index (integer) at that nesting depth.
 */
struct Path {
  r_obj* data;       /**< R-level path object for error reporting. */
  int* depth;        /**< Pointer to the current nesting depth (0-based). */
  r_obj* path_elts;  /**< List of path elements, one per nesting level. */
};

/**
 * Descend one level in the path.
 *
 * Call before iterating into a nested structure; pair with `path_up()`.
 *
 * @param path The current path.
 */
static inline
void path_down(struct Path* path) {
  ++(*path->depth);
}

/**
 * Ascend one level in the path.
 *
 * Call after finishing iteration over a nested structure; pair with
 * `path_down()`.
 *
 * @param path The current path.
 */
static inline
void path_up(struct Path* path) {
  --(*path->depth);
}

/**
 * Record an integer index at the current path depth.
 *
 * Used when iterating over positional (unnamed) list elements.
 *
 * @param path  The current path.
 * @param index The 1-based integer index to record.
 */
static inline
void path_replace_int(struct Path* path, int index) {
  r_obj* ffi_index = KEEP(r_int(index));
  r_list_poke(path->path_elts, *path->depth, ffi_index);
  FREE(1);
}

/**
 * Record a string key at the current path depth.
 *
 * Used when iterating over named list elements.
 *
 * @param path The current path.
 * @param key  An interned R string (`CHARSXP`) to record.
 */
static inline
void path_replace_key(struct Path* path, r_obj* key) {
  r_obj* ffi_key = KEEP(r_alloc_character(1));
  r_chr_poke(ffi_key, 0, key);
  r_list_poke(path->path_elts, *path->depth, ffi_key);
  FREE(1);
}

#endif

#ifndef TIBBLIFY_SHAPE_UTILS_H
#define TIBBLIFY_SHAPE_UTILS_H

#include "tibblify.h"

// -----------------------------------------------------------------------------
// C-level API (Internal Logic)
// -----------------------------------------------------------------------------

/**
 * Check if a list represents a single "object" (row).
 *
 * An "object" in tibblify terms is a structure that can be converted to a
 * single row of a tibble. It must:
 * - Be a bare list (no S3 class unless that class is "list").
 * - Be fully named (no empty names).
 * - Have unique, non-NA names.
 *
 * @param x The object to check.
 * @return true if x is a valid object, false otherwise.
 */
bool is_object(r_obj* x);

/**
 * Check if a list is a list of objects.
 *
 * Valid inputs are:
 * - Data frames (automatically considered lists of objects).
 * - Lists where every element is either NULL or a valid object (see is_object).
 *
 * @param x The object to check.
 * @return true if x is a valid list of objects.
 */
bool is_object_list(r_obj* x);

/**
 * Check if a list consists entirely of NULLs.
 *
 * @param x The list to check.
 * @return true if all elements are NULL.
 */
bool is_null_list(r_obj* x);

/**
 * Check if a list is a list of NULL lists.
 *
 * Used to detect structures that might be empty nested lists.
 *
 * @param x The list to check.
 * @return true if all elements are NULL or are themselves NULL lists.
 */
bool list_is_null_list(r_obj* x);

// -----------------------------------------------------------------------------
// FFI Wrappers (Called from R)
// -----------------------------------------------------------------------------

r_obj* ffi_is_object(r_obj* x);
r_obj* ffi_is_object_list(r_obj* x);
r_obj* ffi_is_null_list(r_obj* x);
r_obj* ffi_list_is_list_null(r_obj* x);

#endif

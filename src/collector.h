#ifndef TIBBLIFY_COLLECTOR_H
#define TIBBLIFY_COLLECTOR_H

#include "Path.h"
#include "tibblify.h"

/**
 * How a vector-typed field is represented in the input list.
 *
 * - `VECTOR_FORM_vector`: the field value is already a vector.
 * - `VECTOR_FORM_scalar_list`: the field is a list of length-1 vectors.
 * - `VECTOR_FORM_object`: the field is a list of named objects (rectangled
 *   into a data frame before storing).
 */
enum vector_form {
  VECTOR_FORM_vector      = 0,
  VECTOR_FORM_scalar_list = 1,
  VECTOR_FORM_object      = 2,
};

/**
 * Convert an interned R string to the corresponding `vector_form` enum value.
 *
 * @param input_form An interned R string from `r_vector_form`.
 * @return The corresponding `enum vector_form` value.
 */
static inline
enum vector_form r_to_vector_form(r_obj* input_form) {
  if (input_form == r_vector_form.vector) {
    return VECTOR_FORM_vector;
  } else if (input_form == r_vector_form.scalar_list) {
    return VECTOR_FORM_scalar_list;
  } else if (input_form == r_vector_form.object_list) {
    return VECTOR_FORM_object;
  } else {
    r_stop_internal("unexpected vector input form"); // # nocov
  }
}

/**
 * Convert a `vector_form` enum value to an R character scalar.
 *
 * @param input_form The enum value to convert.
 * @return A length-1 R character vector.
 */
static inline
r_obj* vector_input_form_to_sexp(enum vector_form input_form) {
  switch (input_form) {
  case VECTOR_FORM_vector: return r_chr("vector"); // # nocov
  case VECTOR_FORM_scalar_list: return r_chr("scalar_list");
  case VECTOR_FORM_object: return r_chr("object");
  }

  r_stop_unreachable(); // # nocov
}

/**
 * Identifies the kind of collector represented by a `struct collector`.
 *
 * Used internally by `new_multi_collector()` to select the correct function
 * pointer set. Not stored on the collector itself after construction.
 */
enum collector_type {
  COLLECTOR_TYPE_scalar        = 0,
  COLLECTOR_TYPE_scalar_lgl    = 1,
  COLLECTOR_TYPE_scalar_int    = 2,
  COLLECTOR_TYPE_scalar_dbl    = 3,
  // COLLECTOR_TYPE_scalar_cpl    = 4,
  // COLLECTOR_TYPE_scalar_raw    = 5,
  COLLECTOR_TYPE_scalar_chr    = 6,
  COLLECTOR_TYPE_vector        = 7,
  COLLECTOR_TYPE_variant       = 8,
  COLLECTOR_TYPE_sub           = 9,
  COLLECTOR_TYPE_row           = 10,
  COLLECTOR_TYPE_df            = 11,
  COLLECTOR_TYPE_recursive     = 12,
};

/** Type-specific storage for a logical scalar collector. */
struct lgl_collector {
  int* v_data;        /**< Direct pointer into the allocated logical vector. */
  int default_value;  /**< NA or user-supplied default as a C int. */
};

/** Type-specific storage for an integer scalar collector. */
struct int_collector {
  int* v_data;        /**< Direct pointer into the allocated integer vector. */
  int default_value;  /**< NA or user-supplied default as a C int. */
};

/** Type-specific storage for a double scalar collector. */
struct dbl_collector {
  double* v_data;        /**< Direct pointer into the allocated double vector. */
  double default_value;  /**< NA or user-supplied default as a C double. */
};

/**
 * Type-specific storage for a character scalar collector.
 *
 * Character vectors cannot be written through a raw pointer (they require a
 * write barrier), so there is no `v_data` field; writes go via `r_chr_poke()`.
 */
struct chr_collector {
  r_obj* default_value;  /**< Default value as an interned R string (`CHARSXP`). */
};

/**
 * Type-specific storage for a non-atomic scalar collector.
 *
 * Non-atomic scalars are accumulated in an intermediate list, then unchoped
 * into a typed vector during finalization.
 */
struct scalar_collector {
  r_obj* default_value;  /**< Default R value inserted when the field is absent. */
  r_obj* ptype_inner;    /**< Prototype of the element type (before casting). */
  r_obj* na;             /**< R value to use when the field is `NULL`. */
};

/**
 * Type-specific storage for a vector (list-of) collector.
 *
 * Each row contributes one element to the output `list_of` column.
 * `prep_data` is selected at construction time based on whether `names_to`
 * or `values_to` are set.
 */
struct vector_collector {
  r_obj* ptype_inner;    /**< Element prototype used for casting each value. */
  r_obj* default_value;  /**< Default R value inserted when the field is absent. */

  r_obj* list_of_ptype;  /**< Prototype attached as the `list_of` ptype attribute. */
  r_obj* col_names;      /**< Column names when `input_form` is `VECTOR_FORM_object`. */

  r_obj* na;             /**< R value to use when the field is `NULL`. */

  enum vector_form input_form;       /**< How the input data is structured. */
  bool vector_allows_empty_list;     /**< Whether an empty list is a valid value. */
  r_obj* elt_transform;              /**< Per-element transform function, or `r_null`. */

  /** Prepare raw input data before storing; selected by `names_to`/`values_to`. */
  r_obj* (*prep_data)(r_obj* value_casted, r_obj* names, r_obj* col_names);
};

/** Type-specific storage for a variant (untyped list) collector. */
struct variant_collector {
  r_obj* default_value;  /**< Default R value inserted when the field is absent. */
  r_obj* elt_transform;  /**< Per-element transform function, or `r_null`. */
};

/**
 * Type-specific storage shared by row, sub, and df collectors.
 *
 * Holds the set of child collectors (one per key) plus the state needed to
 * match incoming field names to their collectors efficiently.
 */
struct multi_collector {
  r_obj* keys;   /**< Sorted character vector of expected field names. */
  int n_keys;    /**< Number of keys (= number of child collectors). */

  struct collector* collectors;    /**< Array of child collectors, one per key. */
  int field_order_ind[256];        /**< Scratch buffer for field-order tracking. */
  r_obj* key_match_ind;            /**< Raw vector backing `p_key_match_ind`. */
  int* p_key_match_ind;            /**< Maps key index → position in current input. */
  r_obj* field_names_prev;         /**< Field names from the previous row (for fast-path). */

  r_ssize n_rows;   /**< Number of rows allocated (row-major) or observed (col-major). */
  int n_cols;       /**< Number of output columns (may exceed `n_keys` due to unpacking). */
  r_obj* col_names; /**< Output column names as a character vector. */
  r_obj* coll_locations; /**< List mapping each collector to its output column location(s). */

  r_obj* names_col; /**< Output column name for capturing input field names, or `r_null`. */
};

/**
 * Type-specific storage for a recursive collector.
 *
 * Holds a pointer to the parent collector so that the recursive helper can
 * copy it when descending into a nested structure.
 */
struct recursive_collector {
  struct collector* v_parent;
};

/**
 * A polymorphic collector that accumulates one column of output.
 *
 * Collectors are the core data structure of tibblify's C layer. Each
 * `tib_*()` spec entry maps to one collector, which is initialized from the
 * spec by `create_parser()` / `new_*_collector()`, then driven through the
 * parse loop via its function pointers.
 *
 * All function pointers are set at construction time and remain constant for
 * the lifetime of the collector. The `details` union holds the type-specific
 * fields; only the member corresponding to the collector's actual type should
 * be accessed.
 */
struct collector {
  r_obj* shelter;  /**< GC root list protecting all R objects owned by this collector. */

  /** Allocate storage for `n_rows` values (row-major) or reset state (col-major). */
  void (*alloc)(struct collector* v_collector, r_ssize n_rows);
  /** Store one value from the current row (row-major parse). */
  void (*add_value)(struct collector* v_collector, r_obj* value, struct Path* v_path);
  /** Store one column-wise value (col-major parse). */
  void (*add_value_colmajor)(struct collector* v_collector, r_obj* value, struct Path* v_path);
  /** Validate that `value` has `n_rows` elements (col-major); update `*n_rows` on first call. */
  void (*check_colmajor_nrows)(struct collector* v_collector, r_obj* value, r_ssize* n_rows, struct Path* v_path, struct Path* nrow_path);
  /** Store the default value for a field that is present but `NULL`. */
  void (*add_default)(struct collector* v_collector, struct Path* v_path);
  /** Error if the field is required; otherwise store the default (field absent). */
  void (*add_default_absent)(struct collector* v_collector, struct Path* v_path);
  /** Convert accumulated data into the final R output column. */
  r_obj* (*finalize)(struct collector* v_collector);
  /**
   * Return the prototype of this collector's output.
   *
   * Needed to set the correct ptype on `list_of` columns produced by df
   * collectors, since element types cannot be inferred when all rows are NULL.
   * FIXME: it might be simpler to compute this in R.
   */
  r_obj* (*get_ptype)(struct collector* v_collector);
  /**
   * Deep-copy this collector.
   *
   * Required by the recursive parser, which must copy collectors before
   * descending so that sibling nodes do not share mutable state.
   */
  struct collector* (*copy)(struct collector* v_collector);

  bool rowmajor;  /**< `true` for row-major input; `false` for col-major. */
  bool unpack;    /**< `true` for sub-collectors that unpack into the parent frame. */

  r_obj* transform;  /**< Post-processing transform function, or `r_null`. */
  r_obj* ptype;      /**< Output prototype used for the final `vec_cast()`. */

  r_obj* data;          /**< The in-progress R vector / list being built. */
  r_ssize current_row;  /**< Index of the next row to be written (row-major). */

  /** Type-specific fields; access only the member matching this collector's type. */
  union details {
    struct lgl_collector lgl_coll;
    struct int_collector int_coll;
    struct dbl_collector dbl_coll;
    struct chr_collector chr_coll;
    struct scalar_collector scalar_coll;
    struct vector_collector vec_coll;
    struct variant_collector variant_coll;
    struct multi_collector multi_coll;
    struct recursive_collector rec_coll;
  } details;
};

/**
 * Construct a scalar collector for a single-value field.
 *
 * Selects the appropriate atomic specialization (lgl/int/dbl/chr) based on
 * `ptype_inner`, falling back to the generic list-backed collector for
 * non-atomic types.
 *
 * @param required       Error if the field is absent from an input object.
 * @param ptype          Output prototype for the final `vec_cast()`.
 * @param ptype_inner    Element prototype used to select the specialization.
 * @param default_value  Value to use when the field is `NULL`.
 * @param transform      Post-processing function, or `r_null`.
 * @param na             R value for `NULL` fields (non-atomic path only).
 * @param rowmajor       `true` for row-major input.
 * @return A heap-allocated collector; ownership transferred to caller.
 */
struct collector* new_scalar_collector(bool required,
                                       r_obj* ptype,
                                       r_obj* ptype_inner,
                                       r_obj* default_value,
                                       r_obj* transform,
                                       r_obj* na,
                                       bool rowmajor);

/**
 * Construct a vector (list-of) collector.
 *
 * Each row contributes one element; the output column is a `list_of` typed
 * by `list_of_ptype`. `prep_data` is chosen based on `names_to`/`values_to`.
 *
 * @param required                  Error if the field is absent.
 * @param ptype                     Output prototype.
 * @param ptype_inner               Element prototype.
 * @param default_value             Value to use when the field is absent.
 * @param transform                 Post-processing function, or `r_null`.
 * @param input_form                One of `r_vector_form.*` (interned string).
 * @param vector_allows_empty_list  Whether an empty list is a valid element.
 * @param names_to                  Column name for captured element names, or `r_null`.
 * @param values_to                 Column name for captured values, or `r_null`.
 * @param na                        R value for `NULL` elements.
 * @param elt_transform             Per-element transform, or `r_null`.
 * @param col_names                 Column names for object-form input.
 * @param list_of_ptype             Prototype attached to the `list_of` attribute.
 * @param rowmajor                  `true` for row-major input.
 * @return A heap-allocated collector; ownership transferred to caller.
 */
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
                                       bool rowmajor);

/**
 * Construct a variant (untyped list) collector.
 *
 * Accumulates arbitrary R values without casting.
 *
 * @param required       Error if the field is absent.
 * @param default_value  Value to use when the field is absent.
 * @param transform      Post-processing function, or `r_null`.
 * @param elt_transform  Per-element transform, or `r_null`.
 * @param rowmajor       `true` for row-major input.
 * @return A heap-allocated collector; ownership transferred to caller.
 */
struct collector* new_variant_collector(bool required,
                                        r_obj* default_value,
                                        r_obj* transform,
                                        r_obj* elt_transform,
                                        bool rowmajor);

/**
 * Construct a row collector for a `tib_row()` spec entry.
 *
 * A row collector groups child collectors and finalizes them as a nested
 * data frame column.
 *
 * @param required       Error if the field is absent.
 * @param n_keys         Number of child keys.
 * @param coll_locations Mapping from key index to output column location(s).
 * @param col_names      Output column names.
 * @param keys           Sorted character vector of expected field names.
 * @param ptype_dummy    Prototype placeholder (computed from children).
 * @param n_cols         Number of output columns.
 * @param rowmajor       `true` for row-major input.
 * @return A heap-allocated collector; ownership transferred to caller.
 */
struct collector* new_row_collector(bool required,
                                    int n_keys,
                                    r_obj* coll_locations,
                                    r_obj* col_names,
                                    r_obj* keys,
                                    r_obj* ptype_dummy,
                                    int n_cols,
                                    bool rowmajor);

/**
 * Construct a sub-collector for a `tib_row()` spec entry with `unpack = TRUE`.
 *
 * Identical to a row collector except `unpack = true`, which causes
 * `assign_in_multi_collector()` to spread child columns into the parent frame
 * rather than nesting them.
 *
 * @param n_keys         Number of child keys.
 * @param coll_locations Mapping from key index to output column location(s).
 * @param col_names      Output column names.
 * @param keys           Sorted character vector of expected field names.
 * @param ptype_dummy    Prototype placeholder.
 * @param n_cols         Number of output columns.
 * @param rowmajor       `true` for row-major input.
 * @return A heap-allocated collector; ownership transferred to caller.
 */
struct collector* new_sub_collector(int n_keys,
                                    r_obj* coll_locations,
                                    r_obj* col_names,
                                    r_obj* keys,
                                    r_obj* ptype_dummy,
                                    int n_cols,
                                    bool rowmajor);

/**
 * Construct a df collector for a `tib_df()` spec entry.
 *
 * A df collector accumulates nested data frames into a `list_of` column.
 *
 * @param required       Error if the field is absent.
 * @param n_keys         Number of child keys.
 * @param coll_locations Mapping from key index to output column location(s).
 * @param col_names      Output column names.
 * @param names_col      Column name for capturing input row names, or `r_null`.
 * @param keys           Sorted character vector of expected field names.
 * @param ptype_dummy    Prototype placeholder.
 * @param n_cols         Number of output columns.
 * @param rowmajor       `true` for row-major input.
 * @return A heap-allocated collector; ownership transferred to caller.
 */
struct collector* new_df_collector(bool required,
                                   int n_keys,
                                   r_obj* coll_locations,
                                   r_obj* col_names,
                                   r_obj* names_col,
                                   r_obj* keys,
                                   r_obj* ptype_dummy,
                                   int n_cols,
                                   bool rowmajor);

/**
 * Construct the top-level parser collector from a spec.
 *
 * Equivalent to `new_row_collector()` with `required = false` and
 * `names_col = r_null`. Called once by `ffi_tibblify()` to build the root
 * of the collector tree.
 *
 * @param n_keys         Number of top-level keys.
 * @param coll_locations Mapping from key index to output column location(s).
 * @param col_names      Output column names.
 * @param names_col      Column name for capturing input names, or `r_null`.
 * @param keys           Sorted character vector of expected field names.
 * @param ptype_dummy    Prototype placeholder.
 * @param n_cols         Number of output columns.
 * @param rowmajor       `true` for row-major input.
 * @return A heap-allocated collector; ownership transferred to caller.
 */
struct collector* new_parser(int n_keys,
                             r_obj* coll_locations,
                             r_obj* col_names,
                             r_obj* names_col,
                             r_obj* keys,
                             r_obj* ptype_dummy,
                             int n_cols,
                             bool rowmajor);

/**
 * Construct a recursive collector.
 *
 * Used as a placeholder in `tib_recursive()` specs; the actual child
 * collectors are filled in by `create_parser()` when building the tree.
 *
 * @return A heap-allocated collector; ownership transferred to caller.
 */
struct collector* new_recursive_collector(void);

/**
 * Allocate storage in all child collectors of a row/sub/df collector.
 *
 * The row collector holds no data of its own; it records `n_rows` and
 * delegates allocation to each child collector in turn.
 *
 * @param v_collector A row, sub, or df collector.
 * @param n_rows      Number of rows to allocate space for.
 */
void alloc_row_collector(struct collector* v_collector, r_ssize n_rows);

/**
 * Determine the number of rows in an object-list value.
 *
 * Matches field names against the collector's keys and delegates to each
 * child's `check_colmajor_nrows()` to establish or verify `*n_rows`.
 *
 * @param v_collector  A row or sub collector.
 * @param value        The named list representing the object.
 * @param n_rows       In/out: number of rows; set on first non-empty call.
 * @param path         Current path for error reporting.
 * @param nrow_path    Path of the first field that set `*n_rows`.
 * @return The verified number of rows.
 */
r_ssize get_collector_vec_rows(struct collector* v_collector,
                               r_obj* value,
                               r_ssize* n_rows,
                               struct Path* path,
                               struct Path* nrow_path);

/**
 * Build a zero-row prototype tibble reflecting this row collector's schema.
 *
 * @param v_collector A row, sub, or df collector.
 * @return A 0-row tibble with the correct column names and types.
 */
r_obj* get_ptype_row(struct collector* v_collector);

/**
 * Assign a finalized column into a multi-collector output frame.
 *
 * If `unpack` is `true` (sub-collector), the columns of `xi` are spread into
 * `x` at the positions listed in `ffi_locs`. Otherwise `xi` is stored as a
 * single nested column.
 *
 * @param x        The output data frame being assembled.
 * @param xi       The finalized column (or sub-frame) to assign.
 * @param unpack   Whether to spread `xi`'s columns into `x`.
 * @param ffi_locs Integer vector of target column indices in `x`.
 */
void assign_in_multi_collector(r_obj* x, r_obj* xi, bool unpack, r_obj* ffi_locs);

r_obj* ffi_tibblify(r_obj* data, r_obj* spec, r_obj* path_xptr);

#endif

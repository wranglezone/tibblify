#include "tibblify.h"
#include "collector.h"
#include "utils.h"
#include "parse-spec.h"
#include "add-value.h"
#include "finalize.h"

struct r_string_input_form_struct r_string_input_form;
struct r_string_types_struct r_string_types;
struct r_vector_form_struct r_vector_form;

/**
 * Parse a nested R list into a tibble according to a spec.
 *
 * This is the `.Call()` entry point for `tibblify()`. It builds a parser from
 * `spec`, then dispatches to the appropriate parse path:
 * - Row-major df/recursive specs call `parse()` directly.
 * - Row-major scalar/vector specs allocate a single-row collector and call
 *   `add_value_row()` + `finalize_row()`.
 * - Col-major specs call `parse_colmajor()`.
 *
 * @param data     The R list (or data frame) to rectangularize.
 * @param spec     An R list describing the expected structure (a `tspec_*()`).
 * @param ffi_path A length-2 list used as a mutable path tracker for error
 *                 reporting; slot 0 holds the depth integer, slot 1 the
 *                 path elements list.
 * @return A tibble (or scalar value) matching the shape described by `spec`.
 */
r_obj* ffi_tibblify(r_obj* data, r_obj* spec, r_obj* ffi_path) {
  struct collector* coll_parser = create_parser(spec);
  KEEP(coll_parser->shelter);

  r_obj* depth = KEEP(r_alloc_integer(1));
  r_int_poke(depth, 0, -1);
  r_list_poke(ffi_path, 0, depth);
  r_obj* path_elts = KEEP(r_alloc_list(30));
  r_list_poke(ffi_path, 1, path_elts);

  struct Path path = (struct Path) {
    .data = ffi_path,
    .depth = r_int_begin(depth),
    .path_elts = path_elts
  };

  r_obj* type = r_chr_get(r_list_get_by_name(spec, "type"), 0);
  r_obj* out;

  if (r_is_data_frame(data) && short_vec_size(data) == 0) {
    data = r_alloc_list(0);
  }

  if (coll_parser->rowmajor) {
    if (type == r_string_types.df || type == r_string_types.recursive) {
      out = parse(coll_parser, data, &path);
    } else {
      alloc_row_collector(coll_parser, 1);
      add_value_row(coll_parser, data, &path);

      out = finalize_row(coll_parser);
    }
  } else {
    out = parse_colmajor(coll_parser, data, &path);
  }

  FREE(3);

  return out;
}

#include "shape_utils.h"
#include "utils.h"

bool is_object(r_obj* x) {
  if (!r_is_bare_list(x)) {
    return false;
  }

  if (r_length(x) == 0) {
    return true;
  }

  // r_is_named checks for existence of names AND ensures no empty strings ("")
  if (!r_is_named(x)) {
    return false;
  }

  r_obj* nms = r_names(x);

  if (r_chr_has(nms, CHAR(r_globals.na_str))) {
    return false;
  }

  if (Rf_any_duplicated(nms, false)) {
    return false;
  }

  return true;
}

bool is_object_list(r_obj* x) {
  if (!r_is_list(x)) {
    return false;
  }

  if (r_is_data_frame(x)) {
    return true;
  }

  // If it is not a data frame, it must be a bare list to be a container
  if (r_is_object(x)) {
    return false;
  }

  r_ssize n = r_length(x);
  r_obj* const * v_x = r_list_cbegin(x);
  for (r_ssize i = 0; i < n; ++i) {
    r_obj* x_i = v_x[i];
    if (x_i != r_null && !is_object(x_i)) {
      return false;
    }
  }

  return true;
}

bool is_null_list(r_obj* x) {
  if (!r_is_list(x)) {
    r_abort("`x` is not a list");
  }

  r_ssize n = r_length(x);
  r_obj* const * v_x = r_list_cbegin(x);
  for (r_ssize i = 0; i < n; ++i) {
    if (v_x[i] != r_null) {
      return false;
    }
  }

  return true;
}

bool list_is_null_list(r_obj* x) {
  if (!r_is_list(x)) {
    r_abort("`x` is not a list");
  }

  r_ssize n = r_length(x);
  r_obj* const * v_x = r_list_cbegin(x);
  for (r_ssize i = 0; i < n; ++i) {
    r_obj* x_i = v_x[i];
    if (x_i != r_null && !is_null_list(x_i)) {
      return false;
    }
  }

  return true;
}

// -----------------------------------------------------------------------------
// FFI Wrappers
// -----------------------------------------------------------------------------

r_obj* ffi_is_object(r_obj* x) {
  return r_lgl(is_object(x));
}

r_obj* ffi_is_object_list(r_obj* x) {
  return r_lgl(is_object_list(x));
}

r_obj* ffi_is_null_list(r_obj* x) {
  return r_lgl(is_null_list(x));
}

r_obj* ffi_list_is_list_null(r_obj* x) {
  return r_lgl(list_is_null_list(x));
}

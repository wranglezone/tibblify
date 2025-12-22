static
r_obj* vec_ptype2_impl(
  r_obj* x,
  r_obj* y,
  struct vendored_vctrs_arg* p_x_arg,
  struct vendored_vctrs_arg* p_y_arg,
  struct r_lazy call,
  enum s3_fallback s3_fallback,
  int* left,
  bool first_pass
);

static
r_obj* vec_ptype2_switch_native(
  r_obj* x,
  r_obj* y,
  enum vctrs_type x_type,
  enum vctrs_type y_type,
  struct vendored_vctrs_arg* p_x_arg,
  struct vendored_vctrs_arg* p_y_arg,
  struct r_lazy call,
  enum s3_fallback s3_fallback,
  int* left
);

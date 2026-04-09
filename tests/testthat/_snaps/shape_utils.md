# .abort_not_tibblifiable throws informative errors

    Code
      (expect_pkg_error_classes(.abort_not_tibblifiable(letters), "tibblify",
      "untibblifiable_object"))
    Output
      <error/tibblify-error-untibblifiable_object>
      Error:
      ! `letters` is neither an object nor a list of objects.
      An object
      x is a list,
      x is fully named,
      v and has unique names.
      A list of objects is
      x a data frame or
      x a list and
      x each element is `NULL` or an object.

---

    Code
      (expect_pkg_error_classes(.abort_not_tibblifiable(list(1, 2, 3)), "tibblify",
      "untibblifiable_object"))
    Output
      <error/tibblify-error-untibblifiable_object>
      Error:
      ! `list(1, 2, 3)` is neither an object nor a list of objects.
      An object
      v is a list,
      x is fully named,
      v and has unique names.
      A list of objects is
      x a data frame or
      v a list and
      x each element is `NULL` or an object.

---

    Code
      (expect_pkg_error_classes(.abort_not_tibblifiable(list(a = 1, a = 2)),
      "tibblify", "untibblifiable_object"))
    Output
      <error/tibblify-error-untibblifiable_object>
      Error:
      ! `list(a = 1, a = 2)` is neither an object nor a list of objects.
      An object
      v is a list,
      v is fully named,
      x and has unique names.
      A list of objects is
      x a data frame or
      v a list and
      x each element is `NULL` or an object.

---

    Code
      (expect_pkg_error_classes(.abort_not_tibblifiable(list(list(a = 1), letters)),
      "tibblify", "untibblifiable_object"))
    Output
      <error/tibblify-error-untibblifiable_object>
      Error:
      ! `list(list(a = 1), letters)` is neither an object nor a list of objects.
      An object
      v is a list,
      x is fully named,
      v and has unique names.
      A list of objects is
      x a data frame or
      v a list and
      x each element is `NULL` or an object.


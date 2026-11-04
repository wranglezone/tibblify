# recursive: works

    Code
      (expect_error(tibblify(x2, spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Problem while tibblifying `x[[1]]$children[[2]]$children[[1]]$id`
      Caused by error:
      ! `value` <character> must be convertible to <integer>
      x Can't convert some values due to non-numeric strings.
      * Locations: 1
      * Values: "does not work"


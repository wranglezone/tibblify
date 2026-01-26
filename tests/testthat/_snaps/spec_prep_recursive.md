# recursive: works

    Code
      (expect_error(tibblify(x2, spec)))
    Output
      <error/tibblify_error>
      Error in `tibblify()`:
      ! Problem while tibblifying `x[[1]]$children[[2]]$children[[1]]$id`
      Caused by error:
      ! Can't convert `"does not work"` <character> to <integer>.


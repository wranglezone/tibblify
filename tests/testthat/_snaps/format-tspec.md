# can print tspecs

    Code
      tspec_df(tib_int("id"), tib_chr("name"), tib_chr_vec("aliases"))
    Output
      tspec_df(
        tib_int("id"),
        tib_chr("name"),
        tib_chr_vec("aliases"),
      )

# prints non-canonical names

    Code
      format(tspec_df(b = tib_int("a")))
    Output
      [1] "tspec_df(\n  b = tib_int(\"a\"),\n)"
    Code
      format(tspec_df(b = tib_int(c("a", "b"))))
    Output
      [1] "tspec_df(\n  b = tib_int(c(\"a\", \"b\")),\n)"

# can force to print canonical names (#98)

    Code
      format(tspec_df(a = tib_int("a"), b = tib_df("b", x = tib_int("x"))))
    Output
      [1] "tspec_df(\n  a = tib_int(\"a\"),\n  b = tib_df(\n    \"b\",\n    x = tib_int(\"x\"),\n  ),\n)"


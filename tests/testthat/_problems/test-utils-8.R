# Extracted from test-utils.R:8

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "tibblify", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
expect_error(.check_list(1), "must be a list")
expect_error(.check_list(), "must be a list")

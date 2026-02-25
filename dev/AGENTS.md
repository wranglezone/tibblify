# AGENTS.md

## General

- When running R from the console, use `--quiet --vanilla`.
- Always run `air format .` after generating code.
- After adding or changing functions, update their documentation per
  @.github/skills/document/SKILL.md .

## Skills

Load skills from @.github/skills when the user triggers them.

| Trigger               | Path                                           |
|-----------------------|------------------------------------------------|
| tag tests with issues | @.github/skills/tag-tests-with-issues/SKILL.md |
| document functions    | @.github/skills/document/SKILL.md              |

## Testing

- Tests for `R/{name}.R` go in `tests/testthat/test-{name}.R`.
- `devtools::test(reporter = "check")` runs all tests;
  `devtools::test(filter = "name", reporter = "check")` runs tests for
  one file.
- Testing functions automatically load code; you don’t need to.
- All new code should have an accompanying test. Place new tests next to
  similar existing tests.

### Coverage

Goal: 100% file-level test coverage. After editing a file, verify
coverage:

``` r
covr_res <- devtools:::test_coverage_active_file("R/file_name.R")
which(purrr::map_int(covr_res, "value") == 0)
```

Excluded from coverage requirements: - @R/aaa-shared_params.R -
@R/tibblify-package.R - Files matching `R/import-standalone-*.R`

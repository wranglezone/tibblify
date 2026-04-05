# AGENTS.md

## Package overview

{tibblify} is an R package that rectangles nested lists. It converts
deeply nested R lists (e.g., parsed JSON) into tibbles. Users provide a
*spec* describing the expected structure (a
[`tspec_df()`](https://tibblify.wrangle.zone/dev/reference/tspec_df.md)
containing `tib_*()` collectors); tibblify traverses the list and fills
those collectors.

Key architecture: - **R layer** (`R/`): spec construction, guessing
([`guess_tspec()`](https://tibblify.wrangle.zone/dev/reference/guess_tspec.md)),
and the user-facing API
([`tibblify()`](https://tibblify.wrangle.zone/dev/reference/tibblify.md),
[`untibblify()`](https://tibblify.wrangle.zone/dev/reference/untibblify.md),
etc.). - **C layer** (`src/`): high-performance parsing; called from R
via [`.Call()`](https://rdrr.io/r/base/CallExternal.html). - **Vendored
rlang** (`src/rlang/`): read-only C API; updated by the `rlang-c.yaml`
workflow — do not edit directly. - **Tests** (`tests/testthat/`): 100%
file-level coverage goal.

## Standard workflow

For any feature, fix, or refactor:

1.  **Update packages**:
    [`pak::pak()`](https://pak.r-lib.org/reference/pak.html)

2.  **Run existing tests** — confirm everything passes before touching
    code: `devtools::test(reporter = "check")` If any tests fail, stop
    and ask the user how to proceed.

3.  **Plan** — identify which R and C files are affected; check whether
    new exported functions are needed (→ r-code skill) or C changes are
    required (→ c-code skill)

4.  **Test first** — write a failing test, then implement (→
    tdd-workflow skill):
    `devtools::test(filter = "name", reporter = "check")` — should fail

5.  **Implement** — minimal code to make the tests pass

6.  **Refactor** — clean up while keeping all tests green

7.  **Document** — for any new or changed exported functions, use the
    document skill

8.  **Verify**:

    ``` r
    devtools::test(reporter = "check")
    covr_res <- devtools:::test_coverage_active_file("R/file_name.R")
    which(purrr::map_int(covr_res, "value") == 0)
    ```

    Then run `air format .` Once, just before wrapping up:
    `devtools::check(error_on = "warning")`. Warnings and errors must be
    resolved. NOTEs should be resolved too, with one exception:
    “Compiled code should not call non-API entry points in R” is a known
    issue being addressed progressively (primarily via rlang’s efforts)
    — leave it alone.

9.  **News** — add a bullet at the top of `NEWS.md` (under the
    development version heading). Rules:

    - Only for user-facing changes; skip purely internal changes.
    - One line per bullet; end with a full stop.
    - Write for users, not developers. Frame positively, present tense:
      `* \`tib_chr()\` now accepts …`not`\* Fixed a bug where …\`
    - Put the function name (in backticks with `()`) near the start.
    - Issue number and contributor go in parentheses before the final
      period: `* \`tib_chr()\` now accepts … (@{username},
      \#{issue_number}).\`
    - Get username: `gh api user --jq .login`

## General

- When running R from the console, use `--quiet --vanilla`.
- Always run `air format .` after generating R code.
- Code comments should explain *why*, not *what*. Omit comments that
  restate the code.
- When writing or reviewing any code, load the relevant skills (usually
  `r-code`, `tdd-workflow`, and `document`).

## Skills

Load skills from @.github/skills when the user triggers them.

| Trigger                                           | Path                                           |
|---------------------------------------------------|------------------------------------------------|
| tag tests with issues                             | @.github/skills/tag-tests-with-issues/SKILL.md |
| document functions                                | @.github/skills/document/SKILL.md              |
| create a GitHub issue                             | @.github/skills/create-issue/SKILL.md          |
| implement issue / work on \#NNN                   | @.github/skills/implement-issue/SKILL.md       |
| edit files in src/ / C code                       | @.github/skills/c-code/SKILL.md                |
| writing R functions / API design / error handling | @.github/skills/r-code/SKILL.md                |
| writing or reviewing tests                        | @.github/skills/tdd-workflow/SKILL.md          |

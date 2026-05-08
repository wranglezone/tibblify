# AGENTS.md

## Repository overview

**tibblify** — Rectangle Nested Lists

A tool to rectangle a nested list, that is to convert it into a tibble.
This is done automatically or according to a given specification. A
common use case is for nested lists coming from parsing ‘JSON’ files, or
the ‘JSON’ responses of ‘REST’ ‘APIs’. Rectangling uses the ‘vctrs’
package, and therefore offers a wide support of vector types.

pkgdown site: <https://tibblify.wrangle.zone> source repo:
<https://github.com/wranglezone/tibblify>

### Overall structure

The project follows standard R package conventions with these key
directories:

tibblify/ ├── R/ \# R source code │ ├── tibblify-package.R \#
Auto-generated package docs │ └── \*.R \# Function definitions, 1 file
~= 1 exported function ├── tests/testthat/ \# Test suite ├── .github/ │
├── ISSUE_TEMPLATE/ \# GitHub issue templates │ ├── skills/ \# Agent
skill definitions │ └── workflows/ \# CI/CD configurations ├── src/ \# C
source code │ └── rlang/ \# Vendored helpers from the rlang package ├──
man/ \# Generated documentation ├── AGENTS.md \# Main agent setup file
├── DESCRIPTION \# Package metadata ├── NAMESPACE \# Auto-generated
export information ├── NEWS.md \# Changelog └── Various config files \#
.gitignore, codecov.yml, etc.

------------------------------------------------------------------------

## Standard workflow

For any feature, fix, or refactor:

1.  **Update packages**:
    [`pak::pak()`](https://pak.r-lib.org/reference/pak.html)
2.  **Run tests** — confirm passing before changes:
    `devtools::test(reporter = "check")`. If any fail, stop and ask.
3.  **Plan** — identify affected R files; check if new exports are
    needed.
4.  **Test first** — write failing test, then implement:
    `devtools::test(filter = "name", reporter = "check")`.
5.  **Implement** — minimal code to pass tests.
6.  **Refactor** — clean up, keep tests green.
7.  **Document** — document any new or changed exports.
8.  **Verify**: Run `devtools::test(reporter = "check")`, then
    `devtools::check(error_on = "warning")`. Resolve warnings, errors,
    and NOTEs.
9.  **News** — add bullet at top of `NEWS.md` (under dev heading):
    - User-facing changes only. 1 line, end with `.`
    - Present tense, positive framing, function names (backticks + `()`)
      near start: `` * `fn()` now accepts ... `` not `* Fixed ...`
    - Issue/contributor before final period:
      `` * `fn()` now accepts ... (@user, #N). `` where `#N` is the
      GitHub issue number being implemented (e.g. `#42`).
    - Get username: `gh api user --jq .login`; get issue number from the
      user’s prompt, the branch name (`git branch --show-current`), or
      `gh issue list`.
    - **Never guess or invent an issue number.** Before writing it,
      verify: (1) you received it from the user or the branch name,
      OR (2) you looked it up with `gh`. If you cannot trace the number
      to a concrete source, use `#noissue`.

------------------------------------------------------------------------

## General

- R console: use `--quiet --vanilla`.
- Always run `air format .` after generating R code.
- Comments explain *why*, not *what*.

## Skills

| Triggers                                          | Path                                     |
|---------------------------------------------------|------------------------------------------|
| create GitHub issues                              | @.github/skills/create-issue/SKILL.md    |
| document functions                                | @.github/skills/document/SKILL.md        |
| from github                                       | @.github/skills/github/SKILL.md          |
| implement issue / work on \#NNN                   | @.github/skills/implement-issue/SKILL.md |
| writing R functions / API design / error handling | @.github/skills/r-code/SKILL.md          |
| search / rewrite code                             | @.github/skills/search-code/SKILL.md     |
| writing or reviewing tests                        | @.github/skills/tdd-workflow/SKILL.md    |

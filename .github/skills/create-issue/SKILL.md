---
name: create-issue
description: Creates GitHub issues for the package repository. Use when asked to create, file, or open a GitHub issue, or when planning new features or functions that need to be tracked.
compatibility: Requires the `gh` CLI and an authenticated GitHub session.
---

# Create a GitHub issue

Use `gh api graphql` with the `createIssue` mutation to create issues. This sets the issue type in a single step. Write the body to a temp file first, then pass it via `$(cat ...)`.

If `gh` is not authenticated, stop and ask the user to authenticate before continuing.

## Issue type

Choose the type that best fits the issue:

| Type | ID | Use for |
|---|---|---|
| Feature | `IT_kwDODjbzj84BwJRW` | New exported functions or capabilities |
| Bug | `IT_kwDODjbzj84BwJRV` | Something broken or incorrect |
| Documentation | `IT_kwDODjbzj84BwprI` | Docs-only changes |
| Task | `IT_kwDODjbzj84BwJRU` | Maintenance, refactoring, chores |

## Issue title

Titles use conventional commit prefixes:

- `feat: my_function()` — new exported function or feature
- `fix: short description` — bug fix
- `docs: short description` — documentation
- `chore: short description` — maintenance or task

## Issue body structure

Which sections to include depends on the issue type:

| Section | Feature | Bug | Documentation | Task |
|---|---|---|---|---|
| `## Summary` | ✓ | ✓ | ✓ | ✓ |
| `## Details` | optional | optional | optional | optional |
| `## Proposed signature` | ✓ | — | — | — |
| `## Behavior` | ✓ | ✓ | — | — |
| `## References` | optional | optional | optional | optional |

### `## Summary` (all types)

A single user story sentence (no other content in this section):

```markdown
> As a [role], in order to [goal], I would like to [feature].
```

Example:

```markdown
## Summary

> As a tibblify user, in order to handle optional fields gracefully, I would like `tib_chr()` to accept a `.default` argument.
```

### `## Details` (optional, all types)

For information that's important to capture but doesn't fit naturally into any other section. Use sparingly — if the content belongs in `## Behavior`, `## Proposed signature`, or `## References`, put it there instead.

### `## Proposed signature` (Feature only)

The proposed R function signature, arguments table, and return value description:

````markdown
## Proposed signature

```r
function_name(arg1, arg2)
```

**Arguments**

- `arg1` (`TYPE`) — Description.
- `arg2` (`TYPE`) — Description.

**Returns** a `TYPE` with description.
````

### `## Behavior` (Feature and Bug)

- **Feature**: bullet points describing expected behavior, edge cases, and any internal helpers to implement as part of this issue.
- **Bug**: describe the current (broken) behavior, the expected behavior, and steps to reproduce if known.

### `## References` (optional, all types)

Only include when there are specific reference implementations, external URLs, or related code to link to. Omit it entirely when there are none.

## Creating the issue

Use the `repoId` and the `typeId` for the chosen issue type from the table above.
If the mutation fails with an ID-related error, load
`@references/lookup-ids.md` to re-query the correct values.

```bash
gh api graphql \
  -f query='mutation($repoId:ID!, $title:String!, $body:String!, $typeId:ID!) {
    createIssue(input:{repositoryId:$repoId, title:$title, body:$body, issueTypeId:$typeId}) {
      issue { url }
    }
  }' \
  -f repoId="MDEwOlJlcG9zaXRvcnkyODY0NzM4MzA=" \
  -f title="feat: my_function()" \
  -f body="$(cat /tmp/issue_body.md)" \
  -f typeId="{typeId}"
```

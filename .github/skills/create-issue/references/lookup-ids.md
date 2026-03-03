# Looking up IDs

The hardcoded IDs in `SKILL.md` are correct for `wranglezone/tibblify` as of
2026-03-03. Use these queries if you suspect they have changed:

```bash
# Repository node ID
gh api graphql -f query='{ repository(owner: "wranglezone", name: "tibblify") { id } }'

# Available issue type IDs
gh api graphql -f query='{ repository(owner: "wranglezone", name: "tibblify") { issueTypes(first: 20) { nodes { id name } } } }'
```

---
name: tag-tests-with-issues
description: Identify likely GitHub issues connected to test cases. Use when asked to tag tests with issues or get started with qcthat.
---

# Tag tests with issues

Connect test cases to their related GitHub issues by adding issue references (e.g., `(#123)`) to test descriptions. This creates bidirectional traceability between tests and the features or bugs they address. Evidence of connections is provided by a series of R functions that extract the relevant details.

This skill is intended to be executed with minimal interaction, so skip chat output that is intended only for user review.

Note: Throughout this skill, if a full path is not provided, files are located in `tests/testthat` (you should not need to search the entire repo for them).

## Step 1: Load test and issue context

Extract all tests and process them file-by-file. `MapTestFilesToPotentialIssues()` can be slow, so pre-compute the issue-commit mappings once with `MapLongIssueCommits()` and pass the result to each call. Do not try to speed up the process by avoiding this function. Its output is required for `PrepareTestIssueContext()`, and the output of `PrepareTestIssueContext()` is your source of all context for the remaining steps.

```r
library(qcthat)

# Extract all tests from test files
dfFileTests <- ExtractTestsFromFiles()

# Split into one data frame per test file
lFileTestsSplit <- dplyr::group_split(dfFileTests, File)

# Pre-compute issue-commit mappings once (avoids redundant API calls per file)
dfIssueCommitsLong <- MapLongIssueCommits()

# Process one file at a time (shown here for the first file)
dfPotentialIssues <- MapTestFilesToPotentialIssues(
  lFileTestsSplit[[1]],
  dfIssueCommitsLong = dfIssueCommitsLong
)
dfTestIssueContext <- PrepareTestIssueContext(dfPotentialIssues)
```

**About `lFileTestsSplit`**: A list of data frames, one per test file. Process files one at a time (`lFileTestsSplit[[1]]`, then `lFileTestsSplit[[2]]` etc) unless told otherwise.

`PrepareTestIssueContext()` returns a data frame with these columns:

| Column | Type | Description |
|--------|------|-------------|
| `Test` | character | The test description |
| `File` | character | Test file name |
| `LineStart` / `LineEnd` | integer | Line numbers in the test file |
| `Issues` | list of integer vectors | Issues already tagged in the description |
| `PotentialIssueDetails` | list of tibbles | A tibble per test with columns `Issue`, `Title`, and `Body` for each potentially related issue. Identified by matching commits that modified the test with commits that closed issues. |
| `TestCode` | list of character vectors | The actual test code |

## Step 2: Match tests to issues

For each test, compare the test code and description against the issue details in `PotentialIssueDetails`. Do not use `git blame` or other tools, and do not look up issue details directly via `gh` or other means. `dfTestIssueContext` contains all of the information you will need to evaluate the tests and issues. Your matches should only come from the `Issue` column of the `PotentialIssueDetails` table for that test. Many tests will match exactly one issue. Some may match zero. A few may match more than one.

### Decision process

For every test with non-empty `PotentialIssueDetails`, follow these steps in order:

**1. Read the `TestCode` to understand what the test actually does.**

Test descriptions can be vague or misleading. The code is the ground truth. Extract:
- The primary function being called (e.g., `ProcessPayment(...)`) — this is your most important signal
- What the `expect_*()` calls verify (the exact behavior being tested)
- Edge cases, setup code, or mocked dependencies that reveal context

**2. Read the ENTIRE `Body` of each potential issue.**

Titles are often vague, abbreviated, or misleading. The body contains the specific technical details needed for accurate matching. For each issue, note:
- Whether it names the specific function being tested
- Whether it describes the specific behavior or scenario being tested
- The purpose of the issue: Is it about creating this feature? Fixing a bug in it? Refactoring something unrelated?

**3. Look for a function name match.**

If an issue body mentions the function being tested AND the issue is *about* implementing, fixing, or extending that function, that is a strong match. Tag it.

Note: the issue must be about the function, not merely mention it in passing. An issue body that says "this refactoring touched `ProcessPayment()`" is not a match for tests of `ProcessPayment()` unless the issue is specifically about changing `ProcessPayment()` behavior.

**4. If no function name match, look for a specific behavioral match.**

This step has a higher bar than step 3. The issue body must describe the *specific behavior* the test checks — not just the general feature area. Ask: "Does this issue body describe the particular thing this test verifies?" If the connection is only that they're in the same feature area, that is not enough.

For example, if a test checks that `ValidateCardNumber()` rejects expired cards, an issue titled "Payment processing feature" whose body discusses order workflows and receipt generation is NOT a match, even though they're in the same domain. An issue whose body says "add validation for expired card numbers" IS a match, even without naming `ValidateCardNumber()` explicitly.

**5. Decide.**

- **Tag** if you found a strong match in step 3, or a specific behavioral match in step 4.
- **Skip** if the potential issues are about unrelated functionality.
- **When uncertain**, lean slightly toward skipping. An untagged test can be found later; an incorrect tag must be identified and removed during review. You don't have to be absolutely certain in order to tag, but you should don't be over-zealous, either.

**6. Check for duplicates.**

The `Issues` column shows what's already tagged. Do not re-add existing tags.

### Common errors to avoid

Do NOT match based on superficial keyword overlap or feature-area proximity. These are the most common failure patterns:

- **Keyword overlap in title only**: Test mentions "payments" → matching any issue with "payments" in the title, when the issue body describes different work
- **Feature-area match without behavioral match**: Test checks that `FormatReceipt()` handles refunds → matching an issue about "Payment processing feature" whose body discusses order validation, not receipt formatting. Same feature area, wrong behavior.
- **Body contradicts title**: Issue title sounds relevant but the body describes unrelated work — always trust the body over the title
- **Incidental file changes**: Issue is about infrastructure, refactoring, or cleanup that happened to touch the same file but isn't about the functionality the test checks
- **Description vs. code mismatch**: Matching based on the test description when the `TestCode` shows the test is actually checking something different

### Special cases

**Tests with `intIssue` in `ExpectUserAccepts()` calls**: Tag with the referenced issue number, UNLESS the value is obviously test data (e.g., 1, 12, 123, 12345).

**Tests already tagged**: If the `Issues` column is non-empty and the tags look correct, skip. If you are adding new tags, preserve existing ones and keep issue numbers in ascending order.

**Disambiguating similar issues**: When multiple issues seem related, read each body completely and pick the one that most specifically describes the functionality being tested. Reject issues that are about infrastructure, refactoring, or the broader feature area without describing the specific behavior the test checks. If multiple issues genuinely pass the bar from steps 3-4, tag with all of them — but this should be uncommon.

### Example

```r
# After running PrepareTestIssueContext for a file:
test <- dfTestIssueContext[5, ]

# Step 1: Read the test description AND extract function name from code
test$Test
# "ProcessPayment handles declined cards"
test$TestCode[[1]]
# test_that("ProcessPayment handles declined cards", {
#   local_mocked_bindings(
#     GetAPIResult = function(...) {
#       list(result = "declined")
#     }
#   )
#   expect_error(ProcessPayment(), class = "error-payment_declined")
# })

# Step 2: Check potential issues - READ THE BODIES
test$PotentialIssueDetails[[1]]
#   Issue Title                                Body
#   42    "Payment system overhaul"            "Refactor payment module architecture..."
#   87    "Payment processing error handling"  "Implement ProcessPayment() function to handle
#                                               declined cards, expired cards, and..."
#   104   "Add logging to payment module"      "Add debug logging throughout payment..."

# Step 3-4: Match by function name + behavior
# - Issue 42: Body is about refactoring architecture, not implementing ProcessPayment → NO
# - Issue 87: Body explicitly mentions ProcessPayment() and declined cards → YES
# - Issue 104: Body is about logging, unrelated to payment handling → NO

# Decision: Tag with #87
# Issue 87's Body mentioned the exact function and behavior,
# not just keyword overlap in the title.
```

## Step 3: Edit test files

Once you've identified which issue(s) match a test, update the test file.

### Tag format

Add issue references in parentheses at the end of the test description:
- Single issue: `test_that("does something (#123)", { ... })`
- Multiple issues: `test_that("does something (#123, #456)", { ... })`

### Editing guidelines

- **Only edit the parenthetical issue tags** in the `test_that()` description string. Do not change anything else.
- Preserve existing tags. 
- For multiple issue numbers, sort in ascending order.
- Use the `File`, `LineStart`, and `LineEnd` columns to locate the test.
- Batch edits to the same file to minimize file I/O.
- Preserve existing code style and indentation. Handle multi-line test descriptions carefully.

### Editing code

```r
# Construct the new tag string
IssuesToTag <- 87L # Be sure to include existing tags here, if any
test$IssueTags <- glue::glue("#{IssuesToTag}") |>
  glue::glue_collapse(sep = ", ")

# Change: test_that("ProcessPayment handles declined cards", {
# To:     test_that("ProcessPayment handles declined cards (#87)", {
readLines(test$File) |>
  stringr::str_replace(
    stringr::fixed(test$Test),
    glue::glue_data(test, "{Test} ({IssueTags})")
  ) |>
  writeLines(test$File)
```

## Validation

After tagging:
- Ensure tests still run: `devtools::test(reporter = "check")`
  - Snapshots may change since the description of the test has changed, but *only* the description should change.
- Re-run `dfFileTests <- ExtractTestsFromFiles()` to verify tags were parsed correctly
  - Confirm that the `Issues` column now contains the tagged issue numbers

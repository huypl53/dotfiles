---
name: commit
description: Turn local uncommitted git changes into clean commits with coherent history. Use when the user asks to commit the current working tree, create a tidy sequence of logical commits, stage only part of a file, write commit messages, or preserve a clear git history before pushing or opening a PR.
---

# Commit

## Overview

Inspect the working tree, decide on the smallest sensible sequence of commits, and create them without mixing unrelated changes. Favor non-interactive git commands, keep commit boundaries reviewable, and preserve any unrelated edits already present in the repo.

## Inspect The Working Tree

- Run `git status --short` first.
- Read `git diff --stat`, `git diff --name-only`, and `git diff --cached --name-only` when staged changes already exist.
- Read per-file diffs before deciding commit boundaries.
- Classify each change as behavior, refactor, formatting, tests, generated output, or incidental churn.
- Preserve user changes already staged unless the user asked to reorder or rewrite them.

## Build A Commit Plan

- Split by logical intent, not by file count.
- Prefer one commit for one reviewable purpose: bug fix, feature, refactor, tests, or generated artifacts tied to a source change.
- Keep tests with the code change they validate unless the repo clearly prefers a separate test commit.
- Keep formatting-only or mechanical edits separate when practical.
- Do not mix unrelated fixes just because they touch the same file.
- If the grouping is ambiguous or the working tree looks partially finished, ask the user before committing.

## Stage One Commit At A Time

- Prefer whole-file staging when possible: `git add <paths>`.
- Verify the staged set with `git diff --cached --stat` and `git diff --cached`.
- For partial-file commits, avoid interactive git flows when possible. Stage selected hunks with a temporary patch:

```bash
git diff -- path/to/file > /tmp/selected.patch
# edit /tmp/selected.patch so it keeps only the hunks for this commit
git apply --cached --unidiff-zero /tmp/selected.patch
```

- Use `git add -p <path>` only as fallback when patch-based staging is too fragile.
- If staging is wrong, repair the index without discarding work: `git restore --staged <path>`.
- Never use destructive commands like `git reset --hard` or `git checkout --` unless the user explicitly requests them.

## Validate Before Each Commit

- Run the smallest useful verification for the staged change: targeted tests, lint, typecheck, or another project command.
- If automated verification is not feasible, at least re-read the staged diff for correctness and tell the user what was not validated.
- Make sure each intermediate commit is coherent. If splitting the diff would leave a broken intermediate state, keep dependent hunks together and explain why.

## Write The Commit

- Match the repository's commit style if it is obvious from recent history.
- Otherwise, use a short imperative subject and keep it specific.
- Add a commit body when the reason, migration note, or tradeoff is not obvious from the diff.
- Avoid vague messages such as `update`, `fix stuff`, or `misc changes`.
- Commit with `git commit -m "<subject>"` once the staged diff matches the intended unit of work.

## Continue Until Clean

- After each commit, run `git status --short` again.
- Compare the remaining diff against the next planned commit instead of assuming the rest can be committed as one block.
- Stop and ask the user if the remaining changes are ambiguous, incomplete, or should be left uncommitted.
- Report the commit sequence you created and any files or hunks intentionally left behind.

## Example Triggers

- "Commit my current changes."
- "Create a clean commit history from the working tree."
- "Commit the bug fix first and leave the refactor for a second commit."
- "Stage part of this file and write the commit message."

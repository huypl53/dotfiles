---
name: review-changes
description: Review staged and unstaged local git changes with a code review mindset. Use when the user asks to review uncommitted changes, inspect the working tree before commit, check staged or unstaged diffs, look for bugs or regressions in local edits, or assess whether current modifications need tests or fixes before committing.
---

# Review Changes

## Overview

Review the current git working tree without changing it. Focus on actionable findings: correctness issues, behavioral regressions, risky changes, and missing test coverage.

## Establish Scope

- Run `git status --short` first.
- Distinguish between unstaged changes, staged changes, and untracked files.
- If both staged and unstaged changes exist, inspect both `git diff --cached` and `git diff`.
- If the user names files or directories, keep the review scoped to those paths.
- If there are no changes, say so explicitly.

## Read Efficiently

- Start with `git diff --stat` and file lists such as `git diff --name-only` and `git diff --cached --name-only`.
- Read diffs before reading entire files. Use per-file diffs for large changes.
- Open the surrounding file context around edited hunks when behavior depends on nearby code.
- Treat generated files, lockfiles, and snapshots as low priority unless they imply real runtime or dependency risk.

## Review Priorities

- Find correctness bugs first.
- Check for behavioral regressions and contract changes.
- Look for missing validation, error handling, cleanup, or edge-case coverage.
- Check migrations, config changes, schema changes, and dependency updates for rollout risk.
- Call out missing or outdated tests when the diff changes behavior.
- Ignore style-only nits unless they hide a defect or maintainability risk.

## Validate Claims

- Verify findings against local context instead of guessing from the patch alone.
- When possible, use existing tests, type checks, or targeted commands to confirm a suspicion.
- Do not edit files or stage changes unless the user asks for fixes.
- State assumptions clearly when a claim cannot be fully verified from the working tree.

## Response Format

- Present findings first, ordered by severity.
- Include file and line references for each finding when available.
- Explain impact and why the issue matters.
- Keep the summary brief and secondary.
- If no findings are found, say that explicitly and mention any residual risk or testing gaps.

## Suggested Commands

- `git status --short`
- `git diff --stat`
- `git diff --cached --stat`
- `git diff --name-only`
- `git diff --cached --name-only`
- `git diff -- <path>`
- `git diff --cached -- <path>`
- `git diff --check`

## Example Triggers

- "Review my uncommitted changes."
- "Check the working tree before I commit."
- "Do a code review of the staged diff."
- "Look through my local git changes for bugs or missing tests."

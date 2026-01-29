---
name: create-agent
description: Create a new Claude Code subagent for specialized tasks. Use when the user wants to create a custom agent, task handler, or specialized AI assistant for specific workflows.
argument-hint: <agent-name> [description]
disable-model-invocation: true
---

# Create a New Subagent

Create a new subagent Markdown file for Claude Code.

## Step 1: Gather Requirements

If no description is provided in `$ARGUMENTS`, ask the user:
1. What should this agent do?
2. What tools does it need? (Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch, etc.)
3. Should it be read-only or able to modify files?
4. Which model should it use? (sonnet, opus, haiku, or inherit)
5. Should Claude use it proactively or only when explicitly requested?

## Step 2: Analyze the Codebase

Before writing the agent, explore the codebase to understand:
- Project structure and conventions
- Existing patterns relevant to the agent's purpose
- Any existing agents in `.claude/agents/` for style consistency
- Key files the agent will work with

Use Glob and Grep to find relevant patterns.

## Step 3: Create the Agent

Create the agent file at `.claude/agents/$ARGUMENTS[0].md`.

### Frontmatter Template

```yaml
---
name: <agent-name>
description: <what it does and when Claude should use it>
# Optional fields:
# tools: Read, Grep, Glob, Bash              # Allowlist of tools (inherits all if omitted)
# disallowedTools: Write, Edit               # Denylist of tools
# model: sonnet                              # sonnet, opus, haiku, or inherit (default)
# permissionMode: default                    # default, acceptEdits, dontAsk, bypassPermissions, plan
# skills:                                    # Skills to preload into agent context
#   - skill-name
# hooks:                                     # Lifecycle hooks scoped to this agent
#   PreToolUse:
#     - matcher: "Bash"
#       hooks:
#         - type: command
#           command: "./scripts/validate.sh"
---

System prompt content goes here...
```

### Content Guidelines

**For the description field:**
- Clearly state when Claude should delegate to this agent
- Include "proactively" or "immediately" if Claude should use it without being asked
- Examples: "Use proactively after code changes", "Use when user asks about database queries"

**For the system prompt:**
- Start with the agent's role/identity
- Provide step-by-step workflow instructions
- Specify output format expectations
- Include relevant domain knowledge
- Keep focused on a single task type

**Tool Selection:**

| Use Case | Recommended Tools |
|----------|------------------|
| Read-only research | `Read, Grep, Glob` |
| Code review | `Read, Grep, Glob, Bash` |
| Code modification | `Read, Edit, Write, Grep, Glob, Bash` |
| Web research | `WebFetch, WebSearch, Read` |
| Database operations | `Bash, Read` (with validation hooks) |

**Model Selection:**
- `haiku`: Fast, cheap - good for simple lookups and searches
- `sonnet`: Balanced - good for analysis and moderate complexity
- `opus`: Most capable - for complex reasoning and nuanced tasks
- `inherit`: Use same model as main conversation (default)

## Step 4: Verify and Report

After creating the agent:
1. Confirm the file was created successfully
2. Show the user the full path
3. Explain how Claude will use it:
   - Automatically when matching tasks are encountered
   - Explicitly when user says "Use the <agent-name> agent to..."
4. Note that agents load at session start - restart session or use `/agents` to load immediately

## Example Agents

### Code Reviewer (Read-only)
```markdown
---
name: code-reviewer
description: Expert code reviewer. Use proactively after code changes to review for quality and security.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are a senior code reviewer ensuring high standards of code quality and security.

When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:
- Code clarity and readability
- Proper error handling
- No exposed secrets
- Good test coverage

Provide feedback by priority:
- Critical (must fix)
- Warnings (should fix)
- Suggestions (consider)
```

### Test Runner
```markdown
---
name: test-runner
description: Run tests and fix failures. Use proactively after writing code.
tools: Read, Edit, Bash, Grep, Glob
model: inherit
---

You are a test specialist focused on ensuring code quality through testing.

When invoked:
1. Run the test suite
2. Analyze any failures
3. Fix failing tests or the code causing failures
4. Re-run to verify fixes

Report:
- Number of tests passed/failed
- Root cause of any failures
- Fixes applied
```

### Documentation Generator
```markdown
---
name: doc-generator
description: Generate documentation for code. Use when user asks for docs or README updates.
tools: Read, Write, Grep, Glob
model: sonnet
---

You are a technical writer creating clear, helpful documentation.

When invoked:
1. Analyze the codebase structure
2. Identify key components and their purposes
3. Generate appropriate documentation

Documentation should include:
- Overview/purpose
- Installation/setup instructions
- Usage examples
- API reference if applicable
```

### Research Agent (Haiku for speed)
```markdown
---
name: quick-search
description: Fast codebase search for specific patterns or definitions. Use for quick lookups.
tools: Read, Grep, Glob
model: haiku
---

You are a fast research assistant for codebase exploration.

When asked to find something:
1. Use Glob to find relevant files
2. Use Grep to search for patterns
3. Read relevant sections
4. Return concise, focused results

Keep responses brief - just the essential information.
```

### Database Query Validator (with hooks)
```markdown
---
name: db-reader
description: Execute read-only database queries. Use for data analysis.
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---

You are a database analyst with read-only access.

Execute SELECT queries to analyze data. You cannot modify data.
If asked to INSERT, UPDATE, or DELETE, explain you only have read access.
```

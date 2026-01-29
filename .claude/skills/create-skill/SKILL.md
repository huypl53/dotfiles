---
name: create-skill
description: Create a new Claude Code skill by analyzing the codebase. Use when the user wants to create a custom skill, slash command, or extend Claude's capabilities for this project.
argument-hint: <skill-name> [description]
disable-model-invocation: true
---

# Create a New Skill

Create a new skill at `.claude/skills/$ARGUMENTS[0]/SKILL.md` for this project.

## Step 1: Gather Requirements

If no description is provided in `$ARGUMENTS`, ask the user:
1. What should this skill do?
2. Should it be invocable by the user (`/skill-name`), by Claude automatically, or both?
3. Does it need to run in a subagent (isolated context)?
4. What tools does it need access to?

## Step 2: Analyze the Codebase

Before writing the skill, explore the codebase to understand:
- Project structure and conventions
- Existing patterns and coding standards
- Key files and directories relevant to the skill's purpose
- Any existing `.claude/` configurations (CLAUDE.md, other skills)

Use Glob and Grep to find relevant patterns. Read key files to understand conventions.

## Step 3: Create the Skill

Create the skill directory and SKILL.md file at `.claude/skills/$0/SKILL.md`.

### Frontmatter Template

```yaml
---
name: <skill-name>
description: <what it does and when to use it>
# Optional fields based on requirements:
# argument-hint: [arg1] [arg2]           # Show expected arguments
# disable-model-invocation: true         # Only user can invoke via /name
# user-invocable: false                  # Only Claude can invoke
# context: fork                          # Run in isolated subagent
# agent: Explore                         # Agent type if using context: fork
# allowed-tools: Read, Grep, Bash(uv *) # Tools without permission prompts
---
```

### Content Guidelines

**For reference/knowledge skills** (coding standards, conventions):
- Document patterns found in the actual codebase
- Include real examples from the project
- Keep actionable and specific

**For task/workflow skills** (deployments, code generation):
- Write step-by-step instructions
- Reference actual project scripts and commands
- Include validation steps

**For exploration skills** (using `context: fork`):
- Define clear research questions
- Specify what output format to return
- Use appropriate agent type (Explore for read-only, general-purpose for actions)

### String Substitutions Available

- `$ARGUMENTS` or `$ARGUMENTS[N]` - Arguments passed when invoking
- `$0`, `$1`, `$2` - Shorthand for positional arguments
- `${CLAUDE_SESSION_ID}` - Current session ID
- `!`command`` - Execute shell command and inject output (preprocessing)

## Step 4: Verify and Report

After creating the skill:
1. Confirm the file was created successfully
2. Show the user the full path: `.claude/skills/$0/SKILL.md`
3. Explain how to use it:
   - If user-invocable: `/$0 [arguments]`
   - If model-invocable: Describe trigger phrases
4. Suggest testing the skill

## Examples of Good Skills

### Simple Convention Skill
```yaml
---
name: api-style
description: API design conventions for this project
---

When creating API endpoints:
- Use RESTful naming from existing routes in src/routes/
- Follow error format in src/exceptions.py
- Include request validation using Pydantic models
```

### Task Skill with Arguments
```yaml
---
name: new-module
description: Create a new Python module following project patterns
argument-hint: <module_name>
disable-model-invocation: true
allowed-tools: Read, Write, Glob
---

Create a new module `$0` following patterns in src/:

1. Read an existing module to understand the structure
2. Create src/$0/__init__.py with exports
3. Create src/$0/main.py with the implementation
4. Create tests/test_$0.py with tests
```

### Research Skill with Subagent
```yaml
---
name: analyze-deps
description: Analyze project dependencies and find issues
context: fork
agent: Explore
---

Analyze dependencies in this project:

1. Read pyproject.toml
2. Identify outdated or potentially problematic dependencies
3. Check for conflicting version constraints
4. Report findings with specific recommendations
```

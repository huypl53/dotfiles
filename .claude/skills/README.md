# Claude Code Skills

Custom skills for creating new skills and agents in Claude Code.

## Available Skills

### `/create-skill` - Create a New Skill

Create custom slash commands and Claude capabilities for your project.

**Syntax:**
```
/create-skill <skill-name> [description]
```

**Examples:**

```
/create-skill lint Run linting and fix issues automatically
```

```
/create-skill deploy Deploy the application to production
```

```
/create-skill test-api
```
(Claude will ask for details if no description provided)

**Interactive prompts:**

When invoked without a full description, Claude will ask:
1. What should this skill do?
2. Should it be user-invocable (`/skill-name`), model-invocable, or both?
3. Does it need to run in a subagent (isolated context)?
4. What tools does it need?

**What gets created:**
```
.claude/skills/<skill-name>/SKILL.md
```

---

### `/create-agent` - Create a New Subagent

Create specialized AI assistants for specific tasks. Agents run in isolated contexts with their own system prompts and tool access.

**Syntax:**
```
/create-agent <agent-name> [description]
```

**Examples:**

```
/create-agent code-reviewer Review code for quality, security, and best practices
```

```
/create-agent test-fixer Find and fix failing tests automatically
```

```
/create-agent db-analyst Execute read-only SQL queries for data analysis
```

```
/create-agent refactorer
```
(Claude will ask for details if no description provided)

**Interactive prompts:**

When invoked without a full description, Claude will ask:
1. What should this agent do?
2. What tools does it need? (Read, Write, Edit, Bash, Grep, Glob, etc.)
3. Should it be read-only or able to modify files?
4. Which model? (sonnet, opus, haiku, or inherit)
5. Should Claude use it proactively or only when explicitly requested?

**What gets created:**
```
.claude/agents/<agent-name>.md
```

---

## Usage Patterns

### Creating a Feature-Specific Agent

```
/create-agent api-builder Create REST API endpoints following FastAPI patterns with Pydantic validation
```

### Creating a Testing Agent

```
/create-agent pytest-runner Run pytest and fix failing tests, use haiku model for speed
```

### Creating a Documentation Skill

```
/create-skill docs Generate API documentation from docstrings
```

### Creating a Deployment Skill

```
/create-skill deploy-staging Deploy to staging environment using uv and Docker
```

### Creating a Code Generation Skill

```
/create-skill new-endpoint Create a new FastAPI endpoint with tests
```

---

## After Creation

### Skills
- Use immediately with `/<skill-name> [args]`
- Skills are loaded on session start

### Agents
- Claude uses agents automatically when tasks match the description
- Explicitly invoke with: "Use the <agent-name> agent to..."
- Restart session or run `/agents` to load new agents immediately

---

## Tips

1. **Be specific in descriptions** - Claude uses descriptions to decide when to delegate tasks
2. **Include "proactively"** in agent descriptions if Claude should use them without being asked
3. **Start simple** - You can always edit the generated files to add more features
4. **Check existing patterns** - Both skills analyze your codebase first to match conventions

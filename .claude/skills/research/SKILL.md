---
name: research
description: Research topics by searching the web and GitHub, downloading relevant code/docs folders, and creating organized documentation. Use when user asks to research a topic, gather resources, or find examples.
argument-hint: <topic> [--output <dir>] [--focus github|web|both] [--no-download]
disable-model-invocation: false
allowed-tools: Read, Write, Bash, WebFetch, WebSearch, Grep, Glob
---

# Research Skill

Comprehensive research assistant that gathers resources from the web and GitHub, downloads relevant folders, and creates well-organized documentation.

## Arguments

- `<topic>` - Research topic (required). Examples: "Python async patterns", "Kubernetes autoscaling", "React hooks"
- `--output <dir>` - Output directory (default: `research/<topic-slug>/`)
- `--focus` - Research focus: `github`, `web`, or `both` (default: `both`)
- `--no-download` - Skip downloading GitHub folders, only gather links and info

## Tool Location

This skill includes a GitHub folder download tool located at:
`~/.claude/skills/research/gh-folder.sh`

Use this tool to download specific GitHub folders (not entire repos).

## Workflow

### Step 1: Parse Arguments and Setup

1. Parse the topic and options from arguments
2. Create output directory structure:
   ```
   research/<topic>/
     github/          # Downloaded GitHub folders
     docs/            # Web research notes
     links.md         # Collected links and references
     README.md        # Main research documentation
   ```
3. Sanitize topic name for directory (lowercase, hyphens, no special chars)

### Step 2: Web Research Phase

Use WebSearch to find:
- **Official documentation** - Authoritative sources, docs sites
- **GitHub repositories** - Popular, well-maintained projects
- **Tutorials and guides** - Blog posts, articles with examples
- **Best practices** - Industry standards, patterns
- **Recent discussions** - Stack Overflow, Reddit, forums

**Search strategies:**
- `"<topic> tutorial 2026"` - Recent tutorials
- `"<topic> best practices"` - Industry standards
- `"<topic> github examples"` - Code repositories
- `"<topic> documentation"` - Official docs
- `site:github.com <topic>` - GitHub-specific search

Save findings to `docs/web-research.md` with:
- Source URLs
- Brief summaries
- Key concepts identified
- Date accessed

### Step 3: GitHub Resource Identification

From web search results, identify:
- **Specific useful folders** (not entire repos!) like:
  - `/examples/`
  - `/docs/`
  - `/tutorials/`
  - `/templates/`
  - `/use-cases/`

Prioritize:
- Well-maintained repos (recent commits)
- Good documentation
- Popular projects (stars > 100)
- Specific, focused folders

Create `links.md` with:
```markdown
# Research Links: <topic>

## GitHub Resources

### Repository: owner/repo-name
- **URL:** https://github.com/owner/repo/tree/branch/folder/path
- **Stars:** X,XXX
- **Description:** What this contains
- **Worth downloading:** Yes/No - specific folder path
- **Last updated:** Date

## Web Resources

### Article/Tutorial Title
- **URL:** https://example.com/article
- **Source:** Website name
- **Summary:** Brief description
- **Key points:** Bullet list
- **Date:** Publication date
```

### Step 4: Download GitHub Folders

**IMPORTANT:** Only download specific useful folders, NOT entire repositories.

For each identified GitHub folder:

```bash
# The gh-folder.sh tool is at ~/.claude/skills/research/gh-folder.sh
~/.claude/skills/research/gh-folder.sh \
  -o research/<topic>/github/<descriptive-name> \
  https://github.com/owner/repo/tree/branch/folder/path
```

Naming convention for downloads:
- Use format: `<repo-name>-<folder-description>`
- Examples:
  - `vllm-use-cases`
  - `react-hooks-examples`
  - `kubernetes-autoscaling-docs`

Log downloads to `docs/downloads.log`:
```
[YYYY-MM-DD HH:MM] Downloaded: owner/repo/folder -> github/output-name/
[YYYY-MM-DD HH:MM] Status: Success (15 files)
```

### Step 5: Web Content Extraction

For important web articles (top 3-5):
- Use WebFetch to extract content
- Save as markdown in `docs/`
- Filename format: `source-name-article-title.md`
- Include source URL at top of file

### Step 6: Generate Comprehensive README

Create `research/<topic>/README.md` with:

```markdown
# Research: <Topic>

> **Generated:** YYYY-MM-DD HH:MM
> **Research focus:** <focus-type>
> **Resources gathered:** <count>

## Overview

<1-2 paragraph summary of the topic and why it's useful>

## Quick Start

**Start here if you're new to <topic>:**

1. Read: <best intro resource>
2. Explore: `github/<most-relevant-download>/`
3. Try: <quick example or tutorial>

## Resources Summary

### Downloaded GitHub Folders (<count>)

#### 1. <repo-name> - <folder-name>
- **Location:** `github/<output-dir>/`
- **Source:** [GitHub URL](url)
- **Contains:** <description>
- **Files:** <count> files
- **Best for:** <use case>

#### 2. ...

### Web Articles & Documentation (<count>)

#### 1. <Article Title>
- **Source:** [Website](url)
- **Saved as:** `docs/<filename>.md`
- **Summary:** <brief description>
- **Key takeaways:**
  - <point 1>
  - <point 2>

#### 2. ...

## Key Concepts

### Concept 1: <Name>
<Explanation discovered through research>

### Concept 2: <Name>
<Explanation>

## Best Practices

Based on research findings:

1. **Practice 1**
   - Rationale: <why>
   - Source: <where this came from>

2. **Practice 2**
   - Rationale: <why>
   - Source: <where this came from>

## Common Patterns

### Pattern 1: <Name>
- **Description:** <what it is>
- **When to use:** <use case>
- **Example:** `github/<relevant-download>/`

### Pattern 2: <Name>
...

## Example Code

<If applicable, highlight key code examples from downloads>

## Directory Structure

```
<topic>/
├── github/                    # Downloaded GitHub folders
│   ├── <repo>-<folder>/      # Specific downloaded folders
│   └── ...
├── docs/                      # Saved web content
│   ├── web-research.md       # Search findings
│   ├── downloads.log         # Download log
│   └── <article>.md          # Saved articles
├── links.md                   # All links collected
└── README.md                  # This file
```

## Learning Path

**Beginner:**
1. <Resource recommendation>
2. <Resource recommendation>

**Intermediate:**
1. <Resource recommendation>
2. <Resource recommendation>

**Advanced:**
1. <Resource recommendation>
2. <Resource recommendation>

## References

### Official Documentation
- [Name](url)

### GitHub Repositories
- [owner/repo](url) - Description

### Articles & Tutorials
- [Title](url) - Website, Date

### Tools & Libraries
- [Name](url) - Description

## Next Steps

<Suggestions for applying this research>

1. **Try it out**
   - <Specific action>

2. **Explore examples**
   - Check `github/<specific-folder>/`

3. **Further research**
   - <Related topics to explore>

## Notes

<Any additional observations, caveats, or important notes>

---

*Research compiled using Claude Code /research skill*
*Tool: ~/.claude/skills/research/gh-folder.sh*
```

### Step 7: Validation and Summary

After completion:

1. Verify all files created successfully
2. Count resources gathered:
   - GitHub folders downloaded
   - Web articles saved
   - Links collected
3. Print summary:

```
✅ Research Complete: <topic>

📁 Location: research/<topic>/
📊 Summary:
   • GitHub folders: <count>
   • Web articles: <count>
   • Total links: <count>

📚 Downloaded Resources:
   • <repo-name>/<folder> (<file-count> files)
   • ...

📝 Key Findings:
   • <finding 1>
   • <finding 2>
   • <finding 3>

📖 Documentation: research/<topic>/README.md

💡 Next: Review README.md for organized learning path
```

## Focus Options

### `--focus github`
- Skip general web search
- Focus only on finding and downloading GitHub resources
- Faster, more code-focused

### `--focus web`
- Skip GitHub downloads
- Focus on articles, tutorials, documentation
- Good for conceptual understanding

### `--focus both` (default)
- Complete research with both GitHub and web resources
- Most comprehensive

## No-Download Mode

Use `--no-download` to:
- Gather and organize links only
- Research without downloading files
- Preview resources before downloading
- Faster for quick research

In this mode:
- Still identify GitHub folders
- Still search and organize web resources
- Create links.md with all resources
- Create README with links (no local downloads)

## Best Practices

### For GitHub Downloads
- Download specific folders, not entire repos
- Verify folder exists before downloading
- Use descriptive output names
- Include source attribution
- Log all downloads

### For Web Research
- Prioritize authoritative sources (official docs, established sites)
- Include publication dates
- Save important articles locally
- Preserve source URLs
- Note last-accessed dates

### For Organization
- Use consistent naming conventions
- Keep folder depth reasonable (2-3 levels)
- Create clear documentation structure
- Include navigation guides
- Add timestamps to everything

## Error Handling

If downloads fail:
- Log the error to `docs/downloads.log`
- Continue with other downloads
- Note failed downloads in README
- Suggest manual download links

If web searches yield poor results:
- Try alternative search terms
- Focus on available resources
- Note limitations in README
- Suggest manual research topics

## Example Usage

```bash
# Research a topic with defaults
/research "Python async patterns"

# Research focusing only on GitHub
/research "Kubernetes autoscaling" --focus github

# Research with custom output directory
/research "React hooks" --output ~/projects/react-research

# Research without downloading (links only)
/research "Docker best practices" --no-download

# Quick web-only research
/research "FastAPI tutorial" --focus web
```

## Example Output Structures

### Full Research (default)
```
research/python-async-patterns/
├── github/
│   ├── aiohttp-examples/
│   ├── asyncio-patterns/
│   └── trio-tutorials/
├── docs/
│   ├── web-research.md
│   ├── downloads.log
│   ├── realPython-async-guide.md
│   └── python-org-asyncio-docs.md
├── links.md
└── README.md
```

### GitHub-Only Research
```
research/kubernetes-autoscaling/
├── github/
│   ├── k8s-autoscaling-examples/
│   └── keda-samples/
├── docs/
│   └── downloads.log
├── links.md
└── README.md
```

### No-Download Research
```
research/docker-best-practices/
├── docs/
│   └── web-research.md
├── links.md
└── README.md
```

## Notes

- Always preserve source attribution
- Include timestamps for reproducibility
- Keep documentation up-to-date
- Organize for easy navigation
- Focus on actionable resources
- Prioritize quality over quantity

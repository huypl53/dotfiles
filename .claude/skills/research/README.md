# Research Skill

A comprehensive Claude Code skill for researching topics, gathering resources from the web and GitHub, and creating well-organized documentation.

## What This Skill Does

The `/research` skill automates the process of:
1. Searching the web for information about a topic
2. Finding relevant GitHub repositories and specific useful folders
3. Downloading those folders (not entire repos)
4. Organizing everything in a clean directory structure
5. Creating comprehensive, navigable documentation

## Quick Start

```bash
/research "Python async patterns"
```

That's it! The skill will:
- Search the web for Python async patterns
- Find GitHub repos with examples and docs
- Download specific useful folders (like /examples/, /docs/)
- Save important web articles
- Create a comprehensive README to guide you

## Arguments

```
/research <topic> [--output <dir>] [--focus github|web|both] [--no-download]
```

**Required:**
- `<topic>` - What to research (e.g., "Kubernetes autoscaling")

**Optional:**
- `--output <dir>` - Where to save (default: `research/<topic>/`)
- `--focus github|web|both` - Research focus (default: `both`)
- `--no-download` - Don't download, just gather links

## Examples

### Full Research
```bash
/research "React hooks patterns"
```
Downloads GitHub folders, saves articles, creates complete docs.

### GitHub Only
```bash
/research "Kubernetes operators" --focus github
```
Focuses on finding and downloading GitHub code examples.

### Web Only
```bash
/research "Docker best practices" --focus web
```
Gathers articles and documentation without downloads.

### Links Only
```bash
/research "FastAPI tutorial" --no-download
```
Creates organized list of resources without downloading files.

### Custom Location
```bash
/research "PostgreSQL optimization" --output ~/dev/postgres-research
```

## What You Get

After running the skill, you'll have:

```
research/<topic>/
├── github/              # Downloaded GitHub folders
│   ├── repo1-examples/
│   ├── repo2-docs/
│   └── ...
├── docs/                # Saved web content
│   ├── web-research.md
│   ├── downloads.log
│   └── article1.md
├── links.md             # All collected links
└── README.md            # Comprehensive guide
```

The **README.md** includes:
- Overview of the topic
- Quick start guide
- Organized resource list
- Key concepts discovered
- Best practices
- Common patterns
- Learning path (beginner → advanced)
- Complete references

## GitHub Folder Download Tool

This skill includes `gh-folder.sh`, a tool for downloading specific GitHub folders.

**Location:** `~/.claude/skills/research/gh-folder.sh`

**Usage:**
```bash
~/.claude/skills/research/gh-folder.sh \
  -o output-dir \
  https://github.com/owner/repo/tree/branch/folder/path
```

**Features:**
- Downloads specific folders, not entire repos
- Three methods: SVN (fastest), API, git sparse-checkout
- No dependencies needed (uses system tools)
- Preserves directory structure

## How It Works

1. **Parse Arguments**
   - Extract topic and options
   - Create output directory structure

2. **Web Research**
   - Search for official docs, tutorials, repos
   - Identify key concepts and best practices
   - Save findings to `docs/web-research.md`

3. **GitHub Discovery**
   - Find relevant repositories
   - Identify specific useful folders (examples, docs, etc.)
   - List resources in `links.md`

4. **Download Phase** (unless `--no-download`)
   - Download each identified folder using `gh-folder.sh`
   - Organize by repository and folder name
   - Log all downloads

5. **Content Extraction**
   - Save important web articles as markdown
   - Preserve source URLs and dates

6. **Documentation Generation**
   - Create comprehensive README
   - Include navigation, learning paths
   - Add references and next steps

## Focus Options

### `--focus both` (default)
Complete research with web + GitHub resources. Most comprehensive.

### `--focus github`
Only GitHub code and documentation. Faster, code-focused.

### `--focus web`
Only web articles and tutorials. Good for concepts.

## No-Download Mode

Use `--no-download` for:
- Quick research preview
- Link collection only
- Situations where you don't want to download files

Still creates:
- `links.md` with all resources
- `docs/web-research.md` with findings
- `README.md` with organized links

## Use Cases

### Learning New Technology
```bash
/research "GraphQL with TypeScript"
```
Get examples, tutorials, and best practices.

### Project Planning
```bash
/research "microservices deployment patterns" --focus github
```
Gather real-world code examples.

### Documentation Discovery
```bash
/research "Redis caching strategies" --focus web
```
Collect articles and guides.

### Resource Curation
```bash
/research "React performance optimization" --no-download
```
Create curated link collection.

## Tips

### Be Specific
❌ `/research "Python"`
✅ `/research "Python async patterns"`
✅ `/research "Python FastAPI best practices"`

### Choose Right Focus
- Learning concepts? → `--focus web`
- Need code examples? → `--focus github`
- Complete understanding? → `--focus both` (default)

### Use Custom Output for Projects
```bash
/research "authentication patterns" --output ./project-research/auth
```

### Preview Before Downloading
```bash
# First, see what's available
/research "Kubernetes operators" --no-download

# Then download specific topic
/research "Kubernetes operators" --focus github
```

## Output Example

After running `/research "vLLM deployment"`:

```
✅ Research Complete: vLLM deployment

📁 Location: research/vllm-deployment/
📊 Summary:
   • GitHub folders: 2
   • Web articles: 3
   • Total links: 8

📚 Downloaded Resources:
   • vllm-production-stack/use-cases (11 files)
   • vllm-examples/production (7 files)

📝 Key Findings:
   • Autoscaling with KEDA for production workloads
   • Disaggregated prefill improves throughput by 177%
   • KV cache sharing for multi-replica deployments

📖 Documentation: research/vllm-deployment/README.md

💡 Next: Review README.md for organized learning path
```

## Integration with Other Skills

This skill works well with:
- `/report-writer` - Generate reports from research
- Custom agents - Use research as foundation
- Project workflows - Gather resources before starting

## Skill Files

- `SKILL.md` - Main skill definition
- `README.md` - This file
- `gh-folder.sh` - GitHub folder download tool

## GitHub Folder Tool Details

The included `gh-folder.sh` tool tries three methods:

1. **SVN export** (fastest, cleanest)
   - Uses GitHub's SVN protocol support
   - No leftover files

2. **GitHub API + curl/wget**
   - Works with standard tools
   - Requires `jq` for JSON parsing

3. **Git sparse-checkout** (fallback)
   - Uses git to download only specified folder
   - Works if other methods fail

Tool automatically tries methods in order until one succeeds.

## Requirements

**For the skill:**
- WebSearch access
- WebFetch access
- Bash execution

**For GitHub downloads:**
At least one of:
- `svn` (recommended, fastest)
- `curl` or `wget` + `jq`
- `git`

Most systems have at least one of these pre-installed.

## Troubleshooting

### "All download methods failed"
Install one of: `svn`, `jq`, or `git`

```bash
# macOS
brew install svn

# Ubuntu/Debian
sudo apt-get install subversion
```

### Rate limit errors
GitHub API has limits. Use a token:

```bash
export GITHUB_TOKEN=ghp_your_token_here
/research "your topic"
```

### Skill not found
Reload skills:
```bash
/skills reload
```

## Updates

The gh-folder.sh tool is copied into this skill directory. To update:

```bash
# Copy latest version
cp /path/to/new/gh-folder.sh ~/.claude/skills/research/gh-folder.sh
chmod +x ~/.claude/skills/research/gh-folder.sh
```

## License

Part of Claude Code skills. See main Claude Code documentation.

---

**Created:** 2026-02-01
**Version:** 1.0

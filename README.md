# GengsuWiki

A personal knowledge base powered by AI agents, based on [Andrej Karpathy's LLM Wiki pattern](llm-wiki.md). The AI agent builds and maintains a structured, interlinked wiki of markdown files. You curate sources and ask questions — the agent does all the bookkeeping.

## Philosophy

Most RAG systems rediscover knowledge on every query. GengsuWiki is different: **knowledge compounds**. When you add a source, the agent reads it, extracts the key ideas, creates concept pages, cross-references related pages, and flags contradictions. The wiki gets richer with every source and every question. Answers are filed back as new pages so nothing is lost.

> **Obsidian is the IDE. The AI agent is the programmer. The wiki is the codebase.**

## Structure

```
GengsuWiki/
├── raw/                   # Immutable source documents (never modified)
│   └── assets/            # Downloaded images and attachments
├── wiki/                  # Agent-maintained markdown pages
│   ├── index.md           # Table of contents for the entire wiki
│   ├── log.md             # Append-only record of all operations
│   └── concept/           # Concept pages (one per idea/entity)
├── .opencode/             # OpenCode agent configuration
│   ├── opencode.json      # Plugin registration
│   ├── plugins/           # Custom plugins (graphify)
│   └── Skills/            # Agent skills (see below)
├── AGENTS.md              # Agent schema — defines workflows and conventions
├── llm-wiki.md            # Karpathy's original idea document
└── README.md              # This file
```

## Getting Started

### 1. Clone and open in Obsidian

```bash
git clone <repo-url> GengsuWiki
# Open the GengsuWiki folder as an Obsidian vault
```

Obsidian provides graph view, [[wikilink]] navigation, and a Dataview-based Bases plugin for dynamic views.

### 2. Add your first source

Drop documents into `raw/` — articles (markdown, PDF), paper PDFs, book notes, meeting transcripts, anything.

### 3. Tell the agent to ingest

Open your AI agent (OpenCode, Claude Code, Codex) in the GengsuWiki directory and say:

> "Ingest the source in raw/my-article.md"

The agent will:
1. Read the source
2. Discuss key takeaways with you
3. Create a summary page in `wiki/`
4. Create or update concept pages for each major idea
5. Link related pages with [[wikilinks]]
6. Update `wiki/index.md` and `wiki/log.md`
7. Run `graphify update .` to rebuild the knowledge graph

### 4. Query the wiki

> "What does the wiki say about [[reinforcement learning]]?"

The agent reads the index, finds relevant pages, and synthesizes an answer with citations. Good answers get saved back as new pages.

## Daily Workflows

### Ingesting sources

Drop a file into `raw/` → tell the agent to ingest it → review the changes in Obsidian's graph view. One source typically touches 10-15 wiki pages.

### Asking questions

Ask anything against the wiki. The agent searches, synthesizes, and files valuable answers as new pages. Cross-topic questions benefit from the graphify knowledge graph.

### Linting / auditing

> "Lint the wiki"

The agent checks for contradictions, orphan pages, missing concept pages, stale claims, and format compliance.

### Browsing visually

- **Obsidian graph view** — see the shape of your knowledge: hubs, clusters, orphans
- **.base views** — filterable tables and card views over all pages
- **graphify knowledge graph** — community-detected clusters, hidden connections
- **Canvas files** — visual mind maps of related concepts

## Available Skills

The agent is equipped with specialized skills that enhance wiki maintenance:

### Core wiki skills

| Skill | Purpose |
|-------|---------|
| `obsidian-markdown` | Write Obsidian-compatible [[wikilinks]], callouts, frontmatter, and embeds |
| `obsidian-bases` | Create `.base` files for database-like tables, cards, and filtered views |
| `obsidian-json-canvas` | Create visual mind maps and concept diagrams (`.canvas` files) |
| `obsidian-cli` | Automate Obsidian — create notes, search, manage properties from CLI |

### Knowledge graph

| Skill | Purpose |
|-------|---------|
| `graphify` | Build a knowledge graph from wiki content — detect communities, find hidden connections, query relationships between concepts |

### Source ingestion

| Skill | Purpose |
|-------|---------|
| `obsidian-defuddle` | Extract clean markdown from web articles (replaces WebFetch for most URLs) |

### Output formats

| Skill | Purpose |
|-------|---------|
| `slides` | Generate HTML slide presentations from wiki content |
| `brainstorming` | Interactive visual tool for exploring ideas before writing |
| `interactive-explainer` | Create animated HTML explainers for complex concepts |
| `pdf` | Read and extract content from PDF sources |
| `docx` | Read and edit Word documents |
| `pptx` | Create and edit PowerPoint presentations |
| `xlsx` | Work with spreadsheets |

## Key Concepts

### wiki/index.md

The table of contents. Lists every page with a one-line description and metadata. The agent reads this first when answering queries. Updated on every ingest.

### wiki/log.md

An append-only timeline. Every operation (ingests, queries, lint passes) gets an entry with date and summary. Parseable with `grep "^## \[" log.md | tail -5`.

### Concept pages

Each major idea or entity gets its own page in `wiki/concept/`. Pages include YAML frontmatter (title, tags, date, sources, status) for Dataview/Bases compatibility. They link to related concepts with [[wikilinks]].

### Obsidian Bases

`.base` files provide filterable database views. Example uses:
- **Source inventory**: table of all ingested sources with dates and tags
- **Concept index**: card view of all concepts grouped by topic
- **Lint dashboard**: filter to pages with `status: draft`

## Customization

GengsuWiki is designed to evolve with you:

- **Change the page format** — edit the template in `AGENTS.md`
- **Add new workflows** — write them into `AGENTS.md` and the agent follows them
- **Install more skills** — add skill folders to `.opencode/Skills/`
- **Adjust the structure** — add subdirectories to `wiki/` for new page types
- **Co-evolve the schema** — refine `AGENTS.md` as you learn what works

## Credits

Based on [Andrej Karpathy's LLM Wiki](llm-wiki.md) pattern. The core insight: LLMs don't get bored and can maintain cross-references across hundreds of pages, solving the maintenance burden that kills human-maintained wikis.

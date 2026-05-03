# LLM Wiki

A personal knowledge base maintained by AI Agent (Opencode, Claude Code, etc).
Based on Andrej Karpathy's LLM Wiki pattern.

## Purpose

This wiki is a structured, interlinked knowledge base for learning, thinking, and building understanding across any topic.
You are the AI Agent that maintains the wiki. The human curates sources, asks questions, and guides the analysis.

## Folder structure

```
raw/          -- source documents (immutable -- never modify these)
raw/assets/   -- downloaded images and attachments for sources
wiki/         -- markdown pages maintained by AI Agent
wiki/concept  -- markdown pages maintained by AI Agent to save each concept
wiki/index.md -- table of contents for the entire wiki
wiki/log.md   -- append-only record of all operations
```

## Ingest workflow

When the user adds a new source to `raw/` and asks you to ingest it:

1. Read the full source document
2. Discuss key takeaways with the user before writing anything
3. Create a summary page in `wiki/` named after the source
4. Create or update concept pages for each major idea or entity
5. Add wiki-links ([[page-name]]) to connect related pages
6. Update `wiki/index.md` with new pages and one-line descriptions
7. Append an entry to `wiki/log.md` with the date, source name, and what changed

A single source may touch 10-15 wiki pages. That is normal.

## Page format

Every wiki page MUST use YAML frontmatter for metadata. This enables Dataview queries and obsidian-bases views later.

```markdown
---
title: Page Title
tags: [concept, topic-area]
date: 2026-05-03
sources: [filename.md, another.pdf]
aliases: [Alternative Name]
status: draft
---
# Page Title

**Summary**: One to two sentences describing this page.

---

Main content goes here. Use clear headings and short paragraphs.

Link to related concepts using [[wiki-links]] throughout the text.

## Related pages

- [[related-concept-1]]
- [[related-concept-2]]
```

### Frontmatter fields

| Field | Required | Description |
|-------|----------|-------------|
| `title` | Yes | Page title (same as H1) |
| `tags` | Yes | Categorization: `concept`, `source`, `summary`, `comparison`, `analysis`, `question` |
| `date` | Yes | Date created or last significantly updated |
| `sources` | Yes | List of raw source files this page draws from |
| `aliases` | No | Alternative names for the concept (improves [[wikilink]] autocomplete) |
| `status` | No | `draft`, `review`, or `stable` — helps identify pages needing attention during lint

## Citation rules

- Every factual claim should reference its source file
- Use the format (source: filename.pdf) after the claim
- If two sources disagree, note the contradiction explicitly
- If a claim has no source, mark it as needing verification

## Question answering

When the user asks a question:

1. Read `wiki/index.md` first to find relevant pages
2. Read those pages and synthesize an answer
3. Cite specific wiki pages in your response
4. If the answer is not in the wiki, say so clearly
5. If the answer is valuable, offer to save it as a new wiki page

Good answers should be filed back into the wiki so they compound over time.

## Obsidian Bases integration

Use the `obsidian-bases` skill to create `.base` files that provide database-like views over wiki pages. These complement `index.md` by offering filterable, sortable views.

### When to create a base

- **Source inventory** — a table of all ingested sources with status, date, tags
- **Concept index** — a card view of all concepts grouped by topic area
- **Reading/study guide** — a filtered list of only source summary pages
- **Lint dashboard** — filter to pages with `status: draft` or missing sources

### Creating a base

1. Load the `obsidian-bases` skill for the full schema reference
2. Create a `.base` file in `wiki/` (e.g. `wiki/source-index.base`)
3. Filter by tags and folder: `file.hasTag("source")` or `file.inFolder("wiki/concept")`
4. Use frontmatter fields in `order` and `formulas` — all pages have `title`, `tags`, `date`, `sources`, `status`
5. Embed bases in `wiki/index.md` or other pages with `![[source-index.base]]`

### Example: source inventory base

```yaml
filters:
  and:
    - file.hasTag("source")
    - file.inFolder("wiki")

formulas:
  source_count: 'sources.length'

views:
  - type: table
    name: "All Sources"
    order:
      - file.name
      - date
      - formula.source_count
      - status
      - tags
```

## Lint

When the user asks you to lint or audit the wiki:

- Check for contradictions between pages
- Find orphan pages (no inbound links from other pages)
- Identify concepts mentioned in pages that lack their own page
- Flag claims that may be outdated based on newer sources
- Check that all pages follow the page format above
- Report findings as a numbered list with suggested fixes

## Rules

- Never modify anything in the `raw/` folder
- Always update `wiki/index.md` and `wiki/log.md` after changes
- Use the `obsidian-markdown` skill to write Obsidian-compatible [[wikilinks]], callouts, and embeds
- Use the `obsidian-bases` skill to create filterable `.base` views of source inventories and concept indexes
- Use the `graphify` skill to build and query knowledge graphs after major ingests
- Keep page names lowercase with hyphens (e.g. `machine-learning.md`)
- Write in clear, plain language
- When uncertain about how to categorize something, ask the user

## graphify

graphify creates a knowledge graph from the wiki's markdown content, detecting communities of related concepts, cross-references, and hidden connections between topics. Output lives in `graphify-out/`.

### When to use graphify

- **After major ingests** — run `graphify update .` to rebuild the graph, reflecting new cross-references and concept updates
- **Before answering complex queries** — read `graphify-out/GRAPH_REPORT.md` to find god nodes (hub concepts) and community clusters relevant to the question
- **When exploring cross-topic connections** — use `graphify path "<Concept A>" "<Concept B>"` to find the chain of intermediate concepts connecting two ideas
- **When discovering unexpected relationships** — use `graphify query "<question>"` to traverse the graph's extracted and inferred edges
- **When explaining a concept in context** — use `graphify explain "<concept>"` to get its neighborhood in the knowledge graph

### Rules

- The knowledge graph augments (not replaces) `wiki/index.md` for navigation — use both together
- After any session that creates or updates wiki pages, run `graphify update .` to keep the graph current
- If `graphify-out/wiki/index.md` exists, prefer it for graph-based browsing of the wiki
- graphify operates on wiki markdown; it does not modify raw sources

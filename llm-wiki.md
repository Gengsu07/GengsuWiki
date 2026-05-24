# LLM Wiki

A pattern for building personal knowledge bases using LLMs. Copy-paste this to your LLM agent; it will build the specifics with you.

## Core idea

Most RAG systems re-derive knowledge from scratch on every query — nothing accumulates. Instead, the LLM **incrementally builds and maintains a persistent wiki**: a structured, interlinked markdown collection between you and the raw sources.

When you add a source, the LLM extracts key info and integrates it into the wiki — updating pages, revising summaries, flagging contradictions. The knowledge is compiled once and kept current, not re-derived on every question.

**The wiki is a persistent, compounding artifact.** You curate sources and ask questions. The LLM does the summarizing, cross-referencing, filing, and bookkeeping. I have the LLM agent on one side and Obsidian on the other. Obsidian is the IDE; the LLM is the programmer; the wiki is the codebase.

## Three layers

| Layer | Role |
|-------|------|
| **Raw sources** | Your immutable source documents (articles, papers, images) |
| **The wiki** | LLM-generated markdown pages — summaries, concepts, comparisons, synthesis |
| **The schema** | One document (AGENTS.md / CLAUDE.md) that tells the LLM how the wiki works |

## Operations

**Ingest.** Drop a source into `raw/`, tell the LLM to process it. The LLM reads it, discusses key takeaways with you, writes a summary, updates concept pages, cross-references, the index, and the log — all in one pass. A single source may touch 10-15 pages.

**Query.** Ask questions. The LLM searches the wiki index, reads relevant pages, synthesizes an answer with citations. Good answers get filed back as new pages — they shouldn't disappear into chat history.

**Lint.** Periodically ask the LLM to health-check: contradictions, stale claims, orphan pages, missing concepts, missing cross-references.

## Two key files

- **`index.md`** — catalog of every page with a one-line summary. The LLM reads this first when answering queries. Works well at moderate scale (~100 sources, ~hundreds of pages) without RAG infrastructure.
- **`log.md`** — append-only chronological record of ingests, queries, and lint passes. Use consistent prefixes like `## [YYYY-MM-DD] operation | Title` so it's grep-parseable.

## Optional tooling

- **Search**: [qmd](https://github.com/tobi/qmd) — hybrid BM25/vector search for markdown files, CLI and MCP.
- **Obsidian Web Clipper** — converts web articles to markdown.
- **Obsidian graph view** — see the shape of your wiki.
- **Dataview** — query frontmatter across pages.
- **Marp** — markdown slide decks.
- It's all just a git repo — version history, branching, collaboration for free.

## Why this works

Humans abandon wikis because the maintenance burden grows faster than the value. LLMs don't get bored, don't forget cross-references, and can touch 15 files in one pass. The wiki stays maintained because maintenance costs near zero.

Your job: curate sources, direct the analysis, ask good questions. The LLM's job: everything else.

Related in spirit to Vannevar Bush's Memex (1945) — a personal knowledge store with associative trails. Bush couldn't solve who does the maintenance. The LLM does.

## Note

Everything here is optional and modular. Your domain, preferences, and LLM of choice determine the specifics. This document communicates the pattern. Share it with your LLM and work together to instantiate a version that fits you.

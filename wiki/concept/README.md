---
title: Concept Directory Structure
tags: [meta, reference]
date: 2026-05-23
status: stable
---
# Concept Directory Structure

This directory organizes all concept pages into **chapter folders**, each with its own **learning path**.

## Folder layout

```
wiki/concept/
├── README.md                          ← you are here
├── foundations/                       ← fundamental building blocks
│   └── _learning-path.md              ← sequenced curriculum
├── cross-cutting/                     ← concepts spanning multiple domains
│   └── _learning-path.md
└── <chapter-name>/                    ← one folder per broad topic
    ├── _learning-path.md              ← sequenced curriculum for this topic
    ├── concept-a.md
    ├── concept-b.md
    └── ...
```

## Key files

| File | Purpose |
|------|---------|
| `_learning-path.md` | Structured curriculum — a sequenced list of concept nodes with prerequisites, difficulty, and 3-5 sentence overviews per node. Supports branching. |
| `*.md` (any other) | A concept page — full explanation, sources, related pages. |

## Naming conventions

- **Folder names**: lowercase with hyphens, broad topic areas (e.g., `machine-learning`, `cognitive-science`)
- **Concept pages**: lowercase with hyphens (e.g., `backpropagation.md`, `working-memory.md`)
- **Learning paths**: always `_learning-path.md` — the underscore sorts it to the top of file listings
- **Special folders**: `foundations/` and `cross-cutting/` are reserved; all others are topic chapters

## How concepts are placed

| Concept type | Goes in | Example |
|-------------|---------|---------|
| Fundamental building block | `foundations/` | Probability theory, logic, scientific method |
| Used across multiple topics | `cross-cutting/` | Systems thinking, information theory, emergence |
| Belongs to one topic area | `<chapter-name>/` | Backpropagation → `machine-learning/` |

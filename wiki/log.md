---
title: Operations Log
tags: [meta, log]
date: 2026-05-24
status: stable
---

# Operations Log

> **TL;DR**: An append-only chronological record of every operation performed on the wiki — source ingestions, concept page creations, learning path updates, and structural changes. Each entry records the date, the source or trigger, and a summary of what changed. This log is the wiki's audit trail [1].

---

## Format

Every log entry follows this structure:

```
### YYYY-MM-DD — [Operation Type]: [Short Description]

**Source/Trigger**: [What prompted this — a raw file, user request, or lint pass]
**Pages created**: [List of new pages]
**Pages updated**: [List of modified pages]
**Learning paths updated**: [List of _learning-path.md files changed]
**Summary**: [1–3 sentences describing the net effect]
```

---

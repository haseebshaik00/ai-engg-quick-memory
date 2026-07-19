# AI Engg Quick Memory

A repository-backed memory and knowledge-consolidation system for the **AI Engg Quick** learning project.

The project turns new chat summaries into two durable, canonical documents: one describing how the AI assistant should respond and teach, and another preserving the concepts, corrections, decisions, examples, open questions, confidence levels, and learning priorities developed over time.

## What This Project Does

- Maintains stable project instructions without mixing in temporary requests or short-lived facts.
- Consolidates AI engineering knowledge into a deduplicated, evolving knowledge base.
- Preserves distinctions between model knowledge, active context, saved memory, project context, source files, and agent memory.
- Tracks practical learning about LLMs, prompting, context engineering, RAG, MCP, APIs, tools, agents, workflows, and knowledge-management products.
- Records workflow and architecture decisions, including validation-focused AI automation for accounting and Google Sheets.
- Uses a controlled maintenance process that limits automated edits to the canonical documents and changelog.

## How It Works

```text
Latest chat summary
        ↓
Maintenance rules in AGENTS.md
        ↓
Deduplicate, validate, and consolidate
        ↓
Project Instructions + Project Knowledge Base + Changelog
```

The maintenance agent reads the latest chat summary alongside the existing canonical documents. It preserves correct material, adds only repository-supported information, explicitly handles contradictions, and avoids inventing facts.

## Repository Structure

| Path | Purpose |
| --- | --- |
| `maintenance-inbox/latest-chat-summary.md` | Input containing new project material to review. The maintenance script consumes this file; it does not generate it. |
| `canonical/project-instructions.md` | Stable response preferences, teaching style, terminology, scope, workflow rules, and validation requirements. |
| `canonical/project-knowledge-base.md` | Durable concepts, mental models, corrections, decisions, examples, workflow designs, confidence levels, open questions, and learning priorities. |
| `AGENTS.md` | Rules that govern consolidation and restrict which files the maintenance agent may edit. |
| `CHANGELOG.md` | Concise history of canonical maintenance passes. |
| `run-maintenance.sh` | Automated pull, consolidation, commit, and push workflow. |

## Running a Maintenance Pass

First, place the newest project-specific summary in `maintenance-inbox/latest-chat-summary.md`.

For a manual Codex run, use the maintenance instruction defined by the repository:

```text
Follow AGENTS.md. Read maintenance-inbox/latest-chat-summary.md and update the canonical documents only where justified.
```

To run the complete automated workflow:

```bash
./run-maintenance.sh
```

The script:

1. Pulls `origin/main` with fast-forward-only behavior.
2. Runs Codex in a workspace-write sandbox.
3. Checks only the two canonical documents and `CHANGELOG.md` for changes.
4. Exits without a commit when no canonical changes are required.
5. Otherwise commits the authorized files and pushes directly to `origin/main`.

The automated workflow requires Git, an authenticated `codex` CLI, and access to the configured `origin` repository. Review the inbox summary before running it because successful canonical changes are pushed directly to `main`.

## Maintenance Principles

- Use only information contained in this repository.
- Preserve correct existing knowledge and deduplicate overlap.
- Add project instructions only when preferences or rules are stable and reusable.
- Keep temporary facts, individual questions, and raw notes out of project instructions.
- Do not silently remove important information.
- Keep `canonical/project-instructions.md` below 8,000 characters.
- Validate the canonical files and record each maintenance pass in the changelog.

## License

This project is available under the [MIT License](LICENSE).

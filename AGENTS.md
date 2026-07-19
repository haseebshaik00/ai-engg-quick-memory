# Project Maintenance Agent

Maintain these canonical files:

- canonical/project-instructions.md
- canonical/project-knowledge-base.md
- CHANGELOG.md

## Input

Read:

- maintenance-inbox/latest-chat-summary.md
- canonical/project-instructions.md
- canonical/project-knowledge-base.md

## Project Instructions Rules

Update project-instructions.md only when the summary contains stable and reusable:

- response-style preferences;
- teaching preferences;
- terminology;
- explanation-depth preferences;
- workflow rules;
- validation requirements;
- project scope.

Do not add:

- one-time requests;
- temporary facts;
- individual questions;
- topic summaries;
- short-lived preferences.

Keep project-instructions.md below 8,000 characters.

## Knowledge Base Rules

Update project-knowledge-base.md with:

- concepts learned;
- corrected misconceptions;
- useful mental models;
- tool and architecture decisions;
- reusable examples;
- workflow designs;
- open questions;
- confidence changes;
- learning priorities.

## Maintenance Rules

- Use only information contained in the repository.
- Preserve correct existing information.
- Deduplicate overlapping information.
- Explicitly correct contradictions.
- Do not silently remove important content.
- Do not invent facts.
- Update the Last consolidated date.
- Add a concise entry to CHANGELOG.md.
- Do not modify files outside the three canonical output files.
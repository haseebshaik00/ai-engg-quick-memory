#!/bin/zsh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

echo "Pulling latest repository changes..."
git pull --ff-only origin main

echo "Running Codex maintenance..."
codex exec \
  --sandbox workspace-write \
  "Follow AGENTS.md. Read maintenance-inbox/latest-chat-summary.md. Update canonical/project-instructions.md, canonical/project-knowledge-base.md, and CHANGELOG.md. Validate the files after editing. Do not run Git commands and do not modify any other files."

if git diff --quiet -- \
  canonical/project-instructions.md \
  canonical/project-knowledge-base.md \
  CHANGELOG.md
then
  echo "No canonical changes were required."
  exit 0
fi

echo "Committing changes..."
git add \
  canonical/project-instructions.md \
  canonical/project-knowledge-base.md \
  CHANGELOG.md

git commit -m "Update AI Engg Quick project knowledge"

echo "Pushing directly to main..."
git push origin main

echo "Maintenance complete."
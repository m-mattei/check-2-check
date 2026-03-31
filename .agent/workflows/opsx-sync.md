---
description: Sync OpenSpec specs and docs after implementation
---

After implementing code changes, run this workflow to keep specs and docs in sync.

**Steps**

1. **Identify the active change**
   - Use the current change name or ask the user
   - Run: `openspec status --change "<name>" --json`

2. **Sync master specs**
   - For each capability in the change's `specs/` directory, check if `openspec/specs/<capability>/spec.md` exists
   - If it exists: update it to reflect the actual implementation (merge deltas)
   - If it doesn't exist: create it from the change's spec
   - Key things to sync:
     - New requirements added
     - Modified scenarios
     - Removed requirements

3. **Update docs/**
   - New feature? Create `docs/src/content/docs/features/<feature-name>.md`
   - Modified feature? Update existing doc in `docs/src/content/docs/features/`
   - Architecture change? Update `docs/src/content/docs/architecture/`
   - New doc page? Add to `docs/src/content/docs/index.md`

4. **Verify**
   - Run `flutter analyze` to ensure no regressions
   - Confirm all tasks in `tasks.md` are marked `[x]`

**Guardrails**
- Never overwrite master specs blindly — merge deltas carefully
- Keep docs concise; don't duplicate spec content verbatim
- If unsure about a spec change, ask before modifying

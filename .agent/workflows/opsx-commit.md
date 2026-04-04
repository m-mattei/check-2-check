---
description: Auto-commit changes to git and optionally push to remote
---

Auto-commit changes made by the agent and optionally push to GitHub.

**Input**: Optional commit message. If omitted, auto-generate based on changed files.

**Steps**

1. **Check for changes**
   ```bash
   git status --short
   ```
   If no changes found, exit with "No changes to commit."

2. **Generate commit message**
   - If user provided a message, use it
   - Otherwise, analyze changed files and generate descriptive message
   - Format: "feat: add smart plan alerts to Plan page" or "fix: resolve bug in..."

3. **Stage changes**
   ```bash
   git add -A
   ```

4. **Create commit**
   ```bash
   git commit -m "<message>"
   ```

5. **Push to remote** (optional - ask user)
   - If user explicitly requests push: `git push`
   - Otherwise, show "Changes committed locally. Push with `git push` when ready."

**Output**

```
## Changes Committed

[message]

Files changed:
- lib/screens/plan_screen.dart
- lib/utils/feature_flags.dart
- ...

Run `git push` to publish to GitHub.
```

**Guardrails**
- Never commit sensitive files (.env, credentials, etc.)
- Always check git status first
- Confirm before pushing to remote
- Provide clear output about what was committed

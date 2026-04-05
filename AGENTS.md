# Agent Rules for Check-2-Check

These rules apply to ALL agents working on this project. They are enforced on every change.

## 1. OpenSpec is Mandatory

Every code change MUST be tracked under an OpenSpec change in `openspec/changes/`.

**Before writing code:**
- Check if an existing change covers the work: `ls openspec/changes/`
- If yes: use that change
- If no: create a new change directory with `.openspec.yaml`, `proposal.md`, `design.md`, `tasks.md`, and `specs/`

**During implementation:**
- Mark tasks complete in `tasks.md` immediately after finishing each one: `- [ ]` → `- [x]`
- Keep tasks.md in sync with actual implementation

**After implementation:**
- Sync master specs: update `openspec/specs/<capability>/spec.md` to match what was built
- Update `docs/src/content/docs/` with the new feature or change to existing docs
- Archive the change when fully complete: `/opsx:archive <change-name>`

## 2. Auto-Commit Changes

After completing code changes, ALWAYS commit and push:

```bash
./commit-and-push.sh "Your commit message"
```

Or with custom message:
```bash
./commit-and-push.sh "feat: add smart plan alerts"
```

This will:
1. Check for changes
2. Commit all changes with the message
3. Push to remote

## 3. Documentation Sync

After every change, update the docs folder:

- **New feature**: Create `docs/src/content/docs/features/<feature-name>.md`
- **Modified feature**: Update the existing doc in `docs/src/content/docs/features/`
- **Architecture change**: Update `docs/src/content/docs/architecture/`
- **Index**: Update `docs/src/content/docs/index.md` if adding a new doc page

## 4. Feature Flags

Every new feature MUST have a toggle in `lib/utils/feature_flags.dart` and be accessible from Dev Mode (`lib/screens/dev_mode_screen.dart`).

## 4. Code Conventions

- No comments unless asked
- Follow existing patterns (singleton AuthService, ValueNotifier for theme, etc.)
- Run `flutter analyze` before declaring done
- No deprecated APIs

## 5. File Naming

- Screens: `lib/screens/<name>_screen.dart`
- Services: `lib/services/<name>_service.dart`
- Models: `lib/models/<name>.dart`
- Utils: `lib/utils/<name>.dart`
- Widgets: `lib/widgets/<name>.dart`

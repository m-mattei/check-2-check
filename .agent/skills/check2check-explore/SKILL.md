---
name: check2check-explore
description: Explore and understand the Check-2-Check codebase structure, architecture, and existing implementations. Use when starting new work or understanding how something works.
license: MIT
compatibility: Works with both API and Mobile projects.
metadata:
  author: check2check
  version: "1.0"
  generatedBy: opencode
---

# Check-2-Check Exploration Skill

Explore and understand the Check-2-Check codebase to inform implementation decisions.

## Purpose

Use this skill when:
- Starting work on a new feature
- Understanding how existing features work
- Finding the right place to add new code
- Learning the codebase architecture
- Identifying patterns to follow

## Projects

### API Project (`check-2-check-api/`)

**Structure:**
```
src/main/java/com/check2check/
├── resource/     # REST endpoints (Quarkus JAX-RS)
├── service/      # Business logic and data access
├── model/        # Domain objects
├── dto/          # Request/response DTOs
├── auth/         # Authentication filters
└── exception/    # Exception handlers
```

**Key Files:**
- `CrudResource.java` - Generic CRUD operations
- `FirestoreService.java` - Firestore data access
- `BusinessLogicService.java` - Business validations
- `FirebaseAuthService.java` - Auth integration
- `application.properties` - Quarkus config

**Exploration Commands:**
```bash
# List all resources
ls src/main/java/com/check2check/resource/

# View a specific resource
read src/main/java/com/check2check/resource/<Resource>.java

# Search for patterns
grep -r "@Path" src/main/java/com/check2check/resource/

# Check OpenSpec changes
ls openspec/changes/
```

### Mobile Project (`check-2-check/`)

**Structure:**
```
lib/
├── screens/      # UI screens
├── services/     # API clients and business logic
├── models/       # Data models
├── widgets/      # Reusable widgets
├── utils/        # Utilities and feature flags
└── main.dart     # App entry point
```

**Key Files:**
- `main.dart` - App entry point and routing
- `feature_flags.dart` - Feature toggles
- `dev_mode_screen.dart` - Dev settings
- `auth_service.dart` - Authentication

**Exploration Commands:**
```bash
# List all screens
ls lib/screens/

# View a specific screen
read lib/screens/<screen>_screen.dart

# Search for patterns
grep -r "extends StatefulWidget" lib/screens/

# Check feature flags
read lib/utils/feature_flags.dart
```

## Exploration Workflow

### 1. Understand the Request

Clarify what the user wants to explore:
- Specific feature?
- Architecture overview?
- How to implement X?
- Where does Y live?

### 2. Navigate the Structure

**For API:**
```bash
# Get project overview
ls -la check-2-check-api/

# Check existing resources
ls check-2-check-api/src/main/java/com/check2check/resource/

# Read key files
read check-2-check-api/AGENTS.md
read check-2-check-api/pom.xml
```

**For Mobile:**
```bash
# Get project overview
ls -la check-2-check/

# Check existing screens
ls check-2-check/lib/screens/

# Read key files
read check-2-check/AGENTS.md
read check-2-check/pubspec.yaml
```

### 3. Find Relevant Patterns

**Search for similar implementations:**
```bash
# API: Find resources with specific pattern
grep -l "household" check-2-check-api/src/main/java/com/check2check/resource/*.java

# Mobile: Find screens with specific widget
grep -l "ListView" check-2-check/lib/screens/*.dart
```

### 4. Read Context Files

Always read:
- `AGENTS.md` - Project rules and conventions
- `openspec/changes/` - Active changes
- Related existing implementations

### 5. Summarize Findings

Provide:
- Relevant file locations
- Patterns to follow
- Dependencies to consider
- OpenSpec requirements

## Output Format

```
## Exploration Results: <topic>

### Relevant Files
- `path/to/file1.java` - Description
- `path/to/file2.dart` - Description

### Patterns Found
- Pattern 1: Brief description
- Pattern 2: Brief description

### OpenSpec Status
- Active changes: <list>
- Recommended action: <create new or use existing>

### Next Steps
1. Step to take
2. Step to take
```

## Guardrails

- Always check OpenSpec first
- Read AGENTS.md for project rules
- Find existing patterns before suggesting new ones
- Identify both API and Mobile implications
- Note authentication requirements
- Check for feature flag needs

## Common Questions

**"How do I add a new entity?"**
→ Explore existing resources (ExpensesResource, GoalsResource) for patterns

**"Where is authentication handled?"**
→ API: AuthFilter.java, Mobile: auth_service.dart

**"What's the Firestore structure?"**
→ Explore FirestoreService.java and model classes

**"How are feature flags implemented?"**
→ Read lib/utils/feature_flags.dart

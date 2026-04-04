---
name: check2check-api-implement
description: Implement features and changes in the Check-2-Check Quarkus API. Use when adding new endpoints, models, services, or modifying existing API functionality.
license: MIT
compatibility: Requires Quarkus, Maven, and Google Cloud Firestore.
metadata:
  author: check2check
  version: "1.0"
  generatedBy: opencode
---

# Check-2-Check API Implementation Skill

Implement features in the Check-2-Check Quarkus API following the project conventions.

## Context

This skill is for the **Java/Quarkus API** project located at `check-2-check-api/`.

**Tech Stack:**
- Quarkus 3.17.5
- Java 21
- Google Cloud Firestore
- Firebase Authentication
- SmallRye OpenAPI
- Maven

**Architecture:**
- Resources (REST endpoints): `src/main/java/com/check2check/resource/`
- Services (business logic): `src/main/java/com/check2check/service/`
- Models (domain objects): `src/main/java/com/check2check/model/`
- DTOs (request/response): `src/main/java/com/check2check/dto/`
- Auth: `src/main/java/com/check2check/auth/`

## Workflow

### 1. OpenSpec Compliance (REQUIRED)

Before ANY code changes:
```bash
# Check for existing changes
ls openspec/changes/

# If no existing change covers the work, create one:
mkdir -p openspec/changes/<change-name>
# Create: .openspec.yaml, proposal.md, design.md, tasks.md, specs/
```

**Never write code without an OpenSpec change tracking it.**

### 2. Understand the Pattern

**Resource Layer** (endpoints):
- Use `@Path` for routing
- Use `@Authenticated` for auth-required endpoints
- Use OpenAPI annotations (`@Operation`, `@APIResponse`, `@Tag`)
- Return `Response` objects with appropriate status codes
- Households use nested paths: `/api/households/{id}/...`

**Service Layer** (business logic):
- Use `@ApplicationScoped` and `@Inject`
- Firestore operations are async (use `ExecutionException`, `InterruptedException`)
- Timestamps via `com.google.cloud.Timestamp`

**Model Layer**:
- Extend patterns from existing models (Expense, Goal, Note, Paycheck, Category)
- Include `toMap()` and `fromMap()` methods for Firestore serialization
- Include householdId where applicable

### 3. Implementation Steps

For **new entity type**:
1. Create model in `model/` with `toMap()`/`fromMap()` methods
2. Create resource in `resource/` with CRUD endpoints
3. Add OpenAPI documentation
4. Add tests in `src/test/java/com/check2check/`

For **new endpoint on existing entity**:
1. Add method to existing resource class
2. Add business logic to service if needed
3. Update OpenAPI docs

For **business logic changes**:
1. Update `BusinessLogicService.java`
2. Expose via `CrudResource` or dedicated resource

### 4. Code Conventions

- **No comments** unless explicitly requested
- Use **dependency injection** (`@Inject`) throughout
- All endpoints must have **OpenAPI annotations**
- Use **Authenticated** annotation for protected endpoints
- Follow existing naming patterns (e.g., `ExpensesResource`, `FirestoreService`)
- Handle async operations properly (declare exceptions)
- Use `Response` builder pattern for return values

### 5. Testing

Before declaring done:
```bash
mvn verify
```

### 6. Git Workflow

After implementation:
```bash
# Commit with conventional commits
git add .
git commit -m "feat: <description> (openspec: <change-name>)"
git push
```

### 7. Documentation Sync

After code changes:
1. Update `tasks.md` in the openspec change: `- [ ]` → `- [x]`
2. Sync master specs if needed: `openspec/specs/<capability>/spec.md`
3. Archive when complete: `/opsx:archive <change-name>`

## Common Patterns

### Creating a new Resource
```java
@Path("/api/households/{householdId}/<entities>")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
@Tag(name = "<Entities>", description = "...")
public class <Entities>Resource {
    @Inject
    FirestoreService firestoreService;
    
    private String collection(String householdId) {
        return "households/" + householdId + "/<entities>";
    }
    
    // CRUD methods...
}
```

### Creating a new Model
```java
public class <Entity> {
    private String id;
    private String householdId;
    // ... fields
    
    public Map<String, Object> toMap() {
        // convert to Map
    }
    
    public static <Entity> fromMap(String id, Map<String, Object> map) {
        // convert from Map
    }
}
```

## Guardrails

- ALWAYS check OpenSpec first - no code without a change
- Run `mvn verify` before declaring done
- Keep endpoints consistent with existing patterns
- Use household-scoped collections for user data
- Never commit without testing
- Update tasks.md immediately after each task

## Commands

```bash
# Run the API locally
./start.sh

# Run tests
mvn verify

# Build native image
mvn package -Pnative

# Check OpenSpec changes
openspec list
```

## Context

The Plan screen uses hardcoded mock data for categories, paychecks, expenses, people, and goals. To deliver a working budget app, this data must be stored in Firestore with proper authentication and household-scoped access control.

## Decisions

- **Single Collection Path**: `users/{userId}/households/{householdId}/<entity>/{docId}`
- **Household-First**: Every operation is scoped to a household. Users belong to one household (MVP).
- **Real-time Listeners**: Use `onSnapshot` for live updates rather than one-time `get()` calls
- **Optimistic UI**: Update local state immediately, Firestore handles sync in background
- **Timestamps**: Use `FieldValue.serverTimestamp()` for createdAt/updatedAt fields

## Security Rules

```
- Users can only read/write their own household data
- Household membership is determined by the householdId stored in the user's auth claims or a separate memberships collection
- All entity collections are children of the household document
```

## Risks / Trade-offs

- **Risk: Firestore not initialized** → Graceful fallback to mock data with warning
- **Risk: Offline mode** → Firestore handles offline automatically with local cache
- **Risk: No household management yet** → MVP: auto-create household on first login

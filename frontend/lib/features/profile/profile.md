# Profile Feature

## Current State

`ProfileEntity` / `ProfileModel` fields (local mock, MVP):

| Field | Type | Source |
|-------|------|--------|   
| `id` | `String` | local |
| `displayName` | `String` | local |

Fields moved to backend — fetched via `GET /profile/{id}/`:

| Field | Type | Backend key |
|-------|------|-------------|
| `city` | `String` | `city` |
| `skillLevel` | `String` | `skill_level` |
| `gamesPlayed` | `int` | `games_played` |

`AuthUserModel` fields (returned by backend on login):

| Field | Type | Backend key |
|-------|------|-------------|
| `id` | `int` | `id` |
| `email` | `String` | `email` |
| `name` | `String` | `name` |
| `avatarUrl` | `String?` | `avatar_url` |
| `isNew` | `bool` | `is_new` |

---

## Full Profile — Target UserModel

Fields needed for a complete profile (backend + user-editable):

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `id` | `int` | yes | from backend, immutable |
| `email` | `String` | yes | from Google, immutable |
| `username` | `String` | yes | unique handle, editable |
| `displayName` | `String` | yes | shown on cards |
| `avatarUrl` | `String?` | no | Google photo or uploaded |
| `city` | `String` | yes | for court/game search radius |
| `skillLevel` | `SkillLevel` | yes | `beginner / intermediate / advanced` |
| `bio` | `String?` | no | max 160 chars |
| `gamesPlayed` | `int` | yes | computed by backend, read-only |
| `gamesHosted` | `int` | yes | computed, read-only |
| `isPublic` | `bool` | yes | controls profile visibility |
| `createdAt` | `DateTime` | yes | account creation date |

### Enums

```dart
enum SkillLevel { beginner, intermediate, advanced }
```

---

## Edit Profile

Fields the user can change (PATCH `/profile/{id}/`):

| Field | Validation |
|-------|-----------|
| `username` | unique, 3–30 chars, alphanumeric + underscore |
| `displayName` | 2–50 chars |
| `avatarUrl` | valid URL or file upload |
| `city` | non-empty string |
| `skillLevel` | enum value |
| `bio` | max 160 chars or null |
| `isPublic` | bool |

Read-only (never sent in PATCH): `id`, `email`, `gamesPlayed`, `gamesHosted`, `rating`, `createdAt`.

---

## Delete Account

Endpoint: `DELETE /profile/{id}/`

Flow:
1. User taps "Delete account" in settings
2. Show confirmation dialog — type username to confirm
3. Call `DELETE /profile/{id}/` with access token
4. Backend soft-deletes user (anonymises data, keeps game history aggregates)
5. Clear local tokens (`AuthLocalDataSource.clearTokens()`)
6. Emit `AuthUnauthenticated` → router redirects to `/login`

Data removed client-side on delete:
- Access + refresh tokens (`SecureTokenStorage`)
- `isLoggedIn` flag + `userId` (`SharedPreferences`)

---

## Datasource Split

| Class | Responsibility |
|-------|---------------|
| `ProfileLocalDataSource` | cache profile for offline read |
| `ProfileRemoteDataSource` (TODO) | GET / PATCH / DELETE profile via API |

---

## TODO

- [ ] Replace `ProfileLocalDataSource` mock with real `ProfileRemoteDataSource`
- [ ] Merge `AuthUserModel` fields into `ProfileEntity` (id, email, avatarUrl)
- [ ] Add `SkillLevel` enums
- [ ] Build `EditProfilePage` with form validation
- [ ] Build delete account confirmation flow
- [ ] Add `ProfileRepositoryImpl` remote datasource wiring

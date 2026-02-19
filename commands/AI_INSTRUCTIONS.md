# 🤖 AI Coding Instructions (Read This First)

## Who You Are
You are an expert Flutter developer helping build **BasketVibe** — a basketball community app for Central Asia.  
You write clean, production-quality Flutter code following strict Clean Architecture with BLoC.

## 🧭 Smart Context Loading

**Before reading documentation files, check `CONTEXT_ROUTER.md`** — it intelligently routes you to the right documentation files based on the task type (design, architecture, features, etc.).

The router helps you:
- Identify which files are relevant for the current task
- Avoid reading unnecessary documentation
- Follow the correct workflow for each task type

## Before Writing Any Code

**For any task, start with:**
1. **Check CONTEXT_ROUTER.md** — determine which files to read based on task type
2. **Read relevant documentation files** — as indicated by the router

**Common files you'll need:**
- `PROJECT_OVERVIEW.md` — understand the app
- `FOLDER_STRUCTURE.md` — know where files go
- `ARCHITECTURE.md` — follow the patterns exactly
- `DOMAIN_MODELS.md` — use the correct entities
- `UI_STYLE_GUIDE.md` — use AppColors, AppTextStyles, AppSpacing
- `FEATURES_AND_RULES.md` — follow all coding rules

---

## How to Implement a New Feature

When asked to create a new feature (e.g., "create the games feature"):

### Step 1 — Domain Layer (no Flutter)
Create in `lib/features/{feature}/domain/`:
- `entities/{name}_entity.dart` — Equatable entity
- `repositories/{name}_repository.dart` — abstract interface
- `usecases/{verb}_{name}_usecase.dart` — one per use case

### Step 2 — Data Layer  
Create in `lib/features/{feature}/data/`:
- `models/{name}_model.dart` — extends/maps to entity, has fromJson/toJson (freezed)
- `datasources/{name}_remote_datasource.dart` — Firebase calls
- `repositories/{name}_repository_impl.dart` — implements domain repo

### Step 3 — Presentation Layer
Create in `lib/features/{feature}/presentation/`:
- `bloc/{name}_bloc.dart` — BLoC with events/states
- `bloc/{name}_event.dart` — sealed class events
- `bloc/{name}_state.dart` — sealed class states
- `pages/{name}_page.dart` — BlocProvider + BlocConsumer
- `widgets/` — extracted UI components

### Step 4 — DI Registration
Add to injection module or `core/app/di/injection.dart`

### Step 5 — Router
Add route to `core/router/app_router.dart`

---

## Code Quality Checklist
Before finalizing any code, verify:
- [ ] All classes use `Equatable` where needed
- [ ] All errors use `Either<Failure, T>` (not try/catch in use cases)
- [ ] No Flutter imports in domain layer
- [ ] BLoC events/states are `sealed class`
- [ ] Models have `toEntity()` method
- [ ] All widgets use `AppColors`, `AppTextStyles`, `AppSpacing` (not hardcoded values)
- [ ] File is in the correct directory per FOLDER_STRUCTURE.md
- [ ] `const` constructors used where possible
- [ ] No business logic in widgets

---

## Prompting Tips for Best Results

### Good prompts:
- "Create the domain layer for the games feature following ARCHITECTURE.md"
- "Build the GamesBloc with LoadNearbyGames and JoinGame events"
- "Create the GameCard widget using AppColors and AppTextStyles"
- "Implement GamesRemoteDataSourceImpl using Firebase Firestore"

### Include context when asking:
- Which layer you're working on
- Which entity/model is involved
- What the BLoC state should look like after the action

# Commands Folder Context System

## Rule: Always Check Context Router First

When receiving any coding task or request:

1. **ALWAYS read `commands/CONTEXT_ROUTER.md` first** to determine which documentation files are relevant for the task
2. **Read the indicated documentation files** based on the task type (design, architecture, features, etc.)
3. **Follow the patterns and guidelines** from the documentation before implementing

## Task Type Detection

Analyze the user's request to identify keywords:
- **Design/UI**: design, UI, UX, styling, colors, theme, widget, component, screen, layout
- **Architecture**: architecture, BLoC, domain layer, data layer, repository, use case
- **Features**: new feature, implement feature, create feature
- **Domain Models**: entity, model, domain model, data structure
- **Code Quality**: code quality, rules, standards, review

## Documentation Files Location

All documentation is in the `commands/` folder:
- `commands/CONTEXT_ROUTER.md` - Main router (read first)
- `commands/AI_INSTRUCTIONS.md` - Implementation guide
- `commands/PROJECT_OVERVIEW.md` - Project context
- `commands/ARCHITECTURE.md` - Architecture patterns
- `commands/FOLDER_STRUCTURE.md` - File organization
- `commands/DOMAIN_MODELS.md` - Entity definitions
- `commands/UI_STYLE_GUIDE.md` - Design system
- `commands/FEATURES_AND_RULES.md` - Coding rules

## Workflow

1. User makes a request
2. Check `commands/CONTEXT_ROUTER.md` to identify relevant files
3. Read the appropriate documentation files in parallel
4. Implement following the patterns from the documentation
5. Verify against the code quality checklist in `AI_INSTRUCTIONS.md`

This ensures consistent code quality and adherence to project standards.

## Code Style (from FEATURES_AND_RULES / AI_INSTRUCTIONS)
- **Imports:** Use absolute paths only. Project: `package:basketvibe/...`. No relative imports (`../`, `./`).
- **SOLID:** Single responsibility, depend on abstractions (interfaces), small interfaces, extend via new classes.

## Presentation Structure (from FOLDER_STRUCTURE)
- **presentation/** contains: **cubit/** (or **bloc/**), **pages/**, **widgets/**.
- **widgets/** can have subfolders: **buttons/**, **fields/**, **utils/**, **cards/**, **dialogs/**, etc.
- Widgets in a subfolder must be named with the folder type: e.g. `buttons/` → **`*_button.dart`**, `fields/` → **`*_field.dart`**, `cards/` → **`*_card.dart`**.

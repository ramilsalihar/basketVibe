# 🧭 Context Router - Smart Documentation Guide

This file helps route tasks to the appropriate documentation files in the `commands/` folder. Use this to determine which files to read based on the task at hand.

---

## 📋 Quick Reference Map

### 🎨 **Design & UI Tasks**
**Read these files when working on:**
- UI components, widgets, screens
- Styling, colors, typography
- Layout, spacing, borders
- Theme configuration (light/dark mode)
- Visual design elements

**Files to read:**
- `UI_STYLE_GUIDE.md` - Colors, typography, spacing, theme, UI patterns

**Keywords to trigger:**
- design, UI, UX, styling, colors, theme, dark mode, light mode
- widget, component, screen, layout, spacing, typography
- AppColors, AppTextStyles, AppSpacing, AppRadius
- card, button, gradient, glassmorphism

---

### 🏗️ **Architecture & Code Structure**
**Read these files when working on:**
- Clean Architecture implementation
- BLoC patterns, state management
- Domain/Data/Presentation layers
- Use cases, repositories, data sources
- Code organization and structure

**Files to read:**
- `ARCHITECTURE.md` - Clean Architecture patterns, layer responsibilities, code templates
- `FOLDER_STRUCTURE.md` - File organization, where files should be placed

**Keywords to trigger:**
- architecture, clean architecture, BLoC, bloc
- domain layer, data layer, presentation layer
- use case, repository, data source, entity, model
- folder structure, file organization, where to put files

---

### 📦 **Domain Models & Entities**
**Read these files when working on:**
- Creating new entities/models
- Understanding data structures
- Domain logic and business rules

**Files to read:**
- `DOMAIN_MODELS.md` - Entity definitions, data structures, domain rules

**Keywords to trigger:**
- entity, model, domain model, data structure
- GameEntity, UserEntity, PlayerEntity
- domain logic, business rules

---

### 🚀 **Feature Implementation**
**Read these files when working on:**
- New features from scratch
- Following implementation workflow
- Feature-specific rules and patterns

**Files to read:**
- `AI_INSTRUCTIONS.md` - Step-by-step feature implementation guide
- `FEATURES_AND_RULES.md` - Feature-specific rules and patterns
- `PROJECT_OVERVIEW.md` - Overall project context and tech stack

**Keywords to trigger:**
- new feature, implement feature, create feature
- games feature, players feature, courts feature
- implementation, workflow, step by step

---

### 📖 **Project Overview & Context**
**Read these files when working on:**
- Understanding the overall project
- Tech stack and dependencies
- Project goals and concepts

**Files to read:**
- `PROJECT_OVERVIEW.md` - Project description, tech stack, dependencies

**Keywords to trigger:**
- project overview, what is this project, tech stack
- dependencies, packages, what technologies are used
- BasketVibe, basketball app, community app

---

### ✅ **Code Quality & Rules**
**Read these files when working on:**
- Code review and quality checks
- Ensuring code follows standards
- Understanding coding rules

**Files to read:**
- `FEATURES_AND_RULES.md` - Coding rules and standards
- `AI_INSTRUCTIONS.md` - Code quality checklist

**Keywords to trigger:**
- code quality, rules, standards, best practices
- checklist, verify, review, linting

---

## 🔄 **Multi-File Scenarios**

### **Creating a New Feature (Full Stack)**
1. Start with `AI_INSTRUCTIONS.md` - Follow the step-by-step guide
2. Read `ARCHITECTURE.md` - Understand layer structure
3. Read `FOLDER_STRUCTURE.md` - Know where files go
4. Read `DOMAIN_MODELS.md` - Understand entities
5. Read `UI_STYLE_GUIDE.md` - For presentation layer styling
6. Read `FEATURES_AND_RULES.md` - Follow feature rules

### **UI Component Creation**
1. Read `UI_STYLE_GUIDE.md` - For styling and design patterns
2. Read `ARCHITECTURE.md` - For BLoC integration (if needed)
3. Read `FOLDER_STRUCTURE.md` - To place files correctly

### **Backend/Data Layer Work**
1. Read `ARCHITECTURE.md` - For repository/data source patterns
2. Read `DOMAIN_MODELS.md` - For entity definitions
3. Read `FOLDER_STRUCTURE.md` - For file placement

---

## 🎯 **Decision Tree**

```
Task Type?
│
├─ Design/UI Related?
│  └─> Read UI_STYLE_GUIDE.md
│
├─ Architecture/Code Structure?
│  └─> Read ARCHITECTURE.md + FOLDER_STRUCTURE.md
│
├─ Domain Models/Entities?
│  └─> Read DOMAIN_MODELS.md
│
├─ New Feature Implementation?
│  └─> Read AI_INSTRUCTIONS.md + ARCHITECTURE.md + FOLDER_STRUCTURE.md
│
├─ Code Quality/Review?
│  └─> Read FEATURES_AND_RULES.md + AI_INSTRUCTIONS.md (checklist)
│
└─ Project Context?
   └─> Read PROJECT_OVERVIEW.md
```

---

## 📝 **Usage Instructions for AI**

When a user requests a task:

1. **Analyze the request** - Identify keywords and task type
2. **Check this router** - Determine which documentation files are relevant
3. **Read the appropriate files** - Load context before starting work
4. **Follow the patterns** - Implement according to the documentation

**Example:**
- User: "Create a new games list screen"
- Analysis: UI component + new feature
- Read: `UI_STYLE_GUIDE.md`, `ARCHITECTURE.md`, `FOLDER_STRUCTURE.md`, `AI_INSTRUCTIONS.md`
- Implement: Follow Clean Architecture, use AppColors/AppTextStyles, place files correctly

---

## 🔍 **File Descriptions**

| File | Purpose | When to Use |
|------|---------|-------------|
| `AI_INSTRUCTIONS.md` | Main implementation guide, step-by-step workflow | Starting any new feature or major task |
| `PROJECT_OVERVIEW.md` | Project context, tech stack, dependencies | Understanding the project |
| `ARCHITECTURE.md` | Clean Architecture patterns, code templates | Implementing features, understanding structure |
| `FOLDER_STRUCTURE.md` | File organization and placement | Knowing where to put files |
| `DOMAIN_MODELS.md` | Entity definitions and domain logic | Working with data structures |
| `UI_STYLE_GUIDE.md` | Design system, colors, typography, UI patterns | Any UI/styling work |
| `FEATURES_AND_RULES.md` | Feature-specific rules and coding standards | Ensuring code quality and following rules |

---

## 🚨 **Always Read First**

For **any** coding task, start with:
1. `AI_INSTRUCTIONS.md` - Contains the main workflow and checklist
2. Then add context files based on task type (use this router)

---

*Last updated: When commands folder structure changes*

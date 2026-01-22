# Integrate turbo_forms into Monorepo Progress

## Workflow Instructions

**IMPORTANT**: Read this entire file after each conversation compact to restore context.

### After Compact Checklist
- [ ] Read this file fully
- [ ] Read `workspace/changes/integrate-turbo-forms/request.md` for decisions
- [ ] Check current status in Status Overview
- [ ] Resume from where left off

---

## Context

**Goal**: Create fresh `turbo_forms` package (v1.0.1) in monorepo by extracting form infrastructure from turbo_template.

**Source Files**:
- `workspace/changes/integrate-turbo-forms/request.md` (decisions, final intent)

**Key Decisions**:
1. Version: 1.0.1 (pub.dev has 1.0.0, must increment)
2. shadcn_ui: Direct dependency (turbo_forms depends on it)
3. Scope: Core classes only (TFormFieldConfig, TFormFieldState, TFieldType, TFormField, TFormFieldBuilder, TFormConfig, typedefs)
4. Extensions: `t` prefixed methods (tTryAsDouble, tTryAsInt, tHasDecimals, tNaked, tAsType)
5. Defaults: TurboFormsDefaults abstract class with static consts
6. Widgets: TFormField + TErrorLabel (no IconLabelDto, required errorTextStyle)
7. VerticalShrink: Copy to turbo_forms (turbo_template keeps its own)

---

## Status Overview

```
Phase 1: Create Package Structure     🔴 NOT STARTED
Phase 2: Create New Files             🔴 NOT STARTED
Phase 3: Copy/Adapt Files             🔴 NOT STARTED
Phase 4: Update Root Workspace        🔴 NOT STARTED
Phase 5: Update turbo_template        🔴 NOT STARTED
Phase 6: Verification                 🔴 NOT STARTED
```

**Progress**: 0/6 phases complete (0%)

---

## Detailed Status

### Phase 1: Create Package Structure
**Status**: 🔴 NOT STARTED

**Work**:
- [ ] Create `turbo_forms/` folder at monorepo root
- [ ] Create `lib/src/` subdirectories (abstracts, config, constants, enums, extensions, typedefs, widgets)
- [ ] Create pubspec.yaml (v1.0.1, resolution: workspace)
- [ ] Create analysis_options.yaml
- [ ] Create LICENSE, CHANGELOG.md, README.md

---

### Phase 2: Create New Files
**Status**: 🔴 NOT STARTED

**Work**:
- [ ] Create `TurboFormsDefaults` (constants/turbo_forms_defaults.dart)
- [ ] Create `TurboFormFieldExtensions` (extensions/turbo_form_field_extensions.dart)

---

### Phase 3: Copy/Adapt Files from turbo_template
**Status**: 🔴 NOT STARTED

**Work**:
- [ ] Copy TFieldType enum
- [ ] Copy ValuesValidatorDef typedef
- [ ] Copy/adapt TFormFieldConfig + part files (use `t` prefix extensions)
- [ ] Copy TFormConfig abstract class
- [ ] Copy TFormFieldBuilderDef typedef
- [ ] Copy TFormFieldBuilder widget
- [ ] Copy VerticalShrink (only this class from shrinks.dart)
- [ ] Create TErrorLabel (required errorTextStyle parameter)
- [ ] Create TFormField (Widget? label, required errorTextStyle, no IconLabelDto)
- [ ] Create turbo_forms.dart barrel export

---

### Phase 4: Update Root Workspace
**Status**: 🔴 NOT STARTED

**Work**:
- [ ] Add `turbo_forms` to workspace list in root pubspec.yaml
- [ ] Run `dart pub get` at root

---

### Phase 5: Update turbo_template
**Status**: 🔴 NOT STARTED

**Work**:
- [ ] Add turbo_forms dependency to flutter-app/pubspec.yaml
- [ ] Run `dart pub get` in turbo_template
- [ ] Transform turbo_template TFormField to wrapper (IconLabelDto → Widget, theme styles)
- [ ] Update imports in all form files to use turbo_forms
- [ ] Delete original files from turbo_template

---

### Phase 6: Verification
**Status**: 🔴 NOT STARTED

**Work**:
- [ ] `dart analyze` passes
- [ ] Build turbo_template app
- [ ] Test form functionality (login form renders, validation errors animate, submission works)

---

## Implementation Log

<!-- APPEND ONLY - Never modify or delete existing entries -->

### ══════════════════════════════════════════
### Checkpoint: Session 1 — 2026-01-22
### ══════════════════════════════════════════

**What was done**:
- Created request.md with all clarified decisions
- Created implementation plan with 6 phases
- Entered plan mode and designed full architecture

**Decisions made**:
- All 8 decisions documented in request.md

**Blockers/Issues**:
- None

**Next steps**:
- Execute Phase 1: Create package structure

---

## Quick Reference

**Progress**: 0/6 phases complete (0%)

**Key Files to Create**:
```
turbo_forms/
├── lib/
│   ├── turbo_forms.dart
│   └── src/
│       ├── abstracts/t_form_config.dart
│       ├── config/t_form_field_config.dart (+ parts)
│       ├── constants/turbo_forms_defaults.dart
│       ├── enums/t_field_type.dart
│       ├── extensions/turbo_form_field_extensions.dart
│       ├── typedefs/
│       └── widgets/
├── pubspec.yaml
└── analysis_options.yaml
```

**Validation Commands**:
```bash
dart pub get
dart analyze
melos run analyze
```

---

## Resume Instructions

After compact, to continue:
1. Read this file completely
2. Read `workspace/changes/integrate-turbo-forms/request.md` for full decisions
3. Start Phase 1: Create turbo_forms folder structure
4. Follow phases in order (1 → 2 → 3 → 4 → 5 → 6)

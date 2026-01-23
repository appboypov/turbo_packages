---
status: to-do
skill-level: medior
parent-type: change
parent-id: prepare-turbo-template-contextual-navigation
type: refactor
blocked-by:
  - 002-business-logic-view-builder-spacing
  - 003-components-contextual-navigation-positioning
---

# 🧱 Refactor Template

Use this template for code cleanup, restructuring, and technical debt reduction. No new features.

**Title Format**: `🧱 <Area> refactor`

**Examples**:
- 🧱 Authentication module refactor
- 🧱 Database layer refactor

---

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] 002-business-logic-view-builder-spacing
- [ ] 003-components-contextual-navigation-positioning

## 🎯 Refactor Goal
> What is the end state after this refactor?

All views use contextual buttons for navigation instead of TSliverAppBar. Views properly respond to contextual button spacing via TViewBuilder.

---

## 📍 Current State
> What does the code look like now?

### PlaygroundView
- Uses TSliverAppBar with title "Playground"
- Contains TPlayground widget

### StylingView
- Uses TSliverAppBar with title "Styling"
- Contains category/collection/detail widget showcases

### Other Views
- May have TSliverAppBar usage

---

## 🎯 Target State
> What should the code look like after refactoring?

### All Views
- No TSliverAppBar usage
- Navigation handled via contextual buttons
- Back navigation via top-left contextual button
- Content properly padded via TViewBuilder spacing awareness

---

## 📁 Files to Modify

| File | Change Type | Description |
|------|-------------|-------------|
| `playground_view.dart` | Modify | Remove TSliverAppBar, use contextual back button |
| `styling_view.dart` | Modify | Remove TSliverAppBar, use contextual back button |
| Any other view with TSliverAppBar | Modify | Remove TSliverAppBar usage |

---

## 🔄 Step-by-Step Changes

### 1. PlaygroundView

**Before:**
```dart
TSliverBody(
  slivers: [
    TSliverAppBar(title: 'Playground'),
    SliverToBoxAdapter(child: TPlayground()),
  ],
)
```

**After:**
```dart
TSliverBody(
  slivers: [
    SliverToBoxAdapter(child: TPlayground()),
  ],
)
```

### 2. StylingView

**Before:**
```dart
TSliverBody(
  slivers: [
    TSliverAppBar(title: 'Styling'),
    // ... content slivers
  ],
)
```

**After:**
```dart
TSliverBody(
  slivers: [
    // ... content slivers (no app bar)
  ],
)
```

### 3. Register Contextual Back Buttons

For routes that need back navigation, register top-left contextual button:
```dart
contextualButtonsService.registerButtons(
  routePath: '/styling',
  buttons: TContextualButtonsConfig(
    top: {
      'back': TButtonConfig(
        icon: Icons.arrow_back,
        label: 'Back',
        onPressed: () => router.pop(),
      ),
    },
  ),
);
```

---

## ✅ Acceptance Criteria

- [ ] No TSliverAppBar usage in any view
- [ ] All views properly respond to contextual button spacing
- [ ] Back navigation works via contextual buttons
- [ ] Visual appearance is consistent across all views

---

## 🧪 Testing

- [ ] Navigate to each view, verify no app bar visible
- [ ] Verify contextual buttons appear correctly
- [ ] Verify back navigation works
- [ ] Verify content is properly padded (not behind overlays)

---

## 📝 Notes

- TSliverAppBar may be kept in turbo_widgets for projects that need it
- This refactor only removes usage in turbo_template
- Contextual buttons provide more flexible navigation patterns

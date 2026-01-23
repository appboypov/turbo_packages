---
status: to-do
skill-level: junior
parent-type: change
parent-id: prepare-turbo-template-contextual-navigation
type: refactor
blocked-by:
  - 005-business-logic-navigation-routing
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

- [ ] 005-business-logic-navigation-routing

## 🎯 Refactor Goal
> What is the end state after this refactor?

StylingView becomes the comprehensive widget showcase displaying ALL widget types from turbo_widgets (category, collection, detail, forms, navigation, layout, etc.).

---

## 📍 Current State
> What does the code look like now?

### StylingView
- Contains category/collection/detail widget showcases
- May contain playground content
- Accessible as a tab

---

## 🎯 Target State
> What should the code look like after refactoring?

### StylingView
- Comprehensive showcase of ALL turbo_widgets components
- Organized by widget category
- Accessible via top contextual navigation (not bottom tab)
- Clean separation from Playground (testing sandbox)

---

## 📁 Files to Modify

| File | Change Type | Description |
|------|-------------|-------------|
| `styling_view.dart` | Modify | Reorganize to show all widget categories |
| `styling_view_model.dart` | Modify | Update to support comprehensive showcase |

---

## 🔄 Step-by-Step Changes

### 1. Organize StylingView by Widget Category

**Widget Categories to Showcase:**

1. **Category Widgets**
   - TCategoryCard
   - TCategoryHeader
   - TCategorySection (all layouts)

2. **Collection Widgets**
   - TCollectionCard
   - TCollectionHeader
   - TCollectionListItem
   - TCollectionSection
   - TCollectionToolbar

3. **Detail Widgets**
   - TDetailHeader
   - TFormSection
   - TKeyValueField
   - TMarkdownSection

4. **Navigation Widgets**
   - TContextualNavButton
   - TContextualSideNavigation
   - TContextualBottomNavigation
   - TContextualAppBar

5. **Layout Widgets**
   - TProportionalGrid
   - Other layout utilities

6. **Form Widgets** (from turbo_forms)
   - Form field components
   - Validation displays

### 2. Structure

```dart
TSliverBody(
  slivers: [
    // Category Widgets Section
    SliverToBoxAdapter(
      child: _buildCategoryWidgetsSection(),
    ),
    // Collection Widgets Section
    SliverToBoxAdapter(
      child: _buildCollectionWidgetsSection(),
    ),
    // Detail Widgets Section
    SliverToBoxAdapter(
      child: _buildDetailWidgetsSection(),
    ),
    // Navigation Widgets Section
    SliverToBoxAdapter(
      child: _buildNavigationWidgetsSection(),
    ),
    // Layout Widgets Section
    SliverToBoxAdapter(
      child: _buildLayoutWidgetsSection(),
    ),
    // Form Widgets Section
    SliverToBoxAdapter(
      child: _buildFormWidgetsSection(),
    ),
  ],
)
```

### 3. Remove Playground Content

Any playground/testing content should be in PlaygroundView, not StylingView.

---

## ✅ Acceptance Criteria

- [ ] StylingView shows ALL turbo_widgets components
- [ ] Components organized by category with clear headers
- [ ] No playground/testing content in StylingView
- [ ] Each widget category has examples with various configurations
- [ ] Accessible via top contextual navigation button

---

## 🧪 Testing

- [ ] Navigate to Styling via top contextual button
- [ ] Verify all widget categories are present
- [ ] Verify examples render correctly
- [ ] Verify back navigation works

---

## 📝 Notes

- StylingView serves as the component library/documentation
- Playground serves as the testing sandbox
- Clear separation helps developers understand widget usage

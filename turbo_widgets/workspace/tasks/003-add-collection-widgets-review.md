---
status: to-do
skill-level: medior
parent-type: change
parent-id: add-collection-widgets
type: chore
blocked-by:
  - 002-add-collection-widgets-implementation
---

# 🧹 Review collection widgets

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] 002-add-collection-widgets-implementation

## 🧹 Maintenance Area
> What part of the system needs attention?

Collection widgets API, styling, and exports.

## 📍 Current State
> What needs cleaning, updating, or removing?

New widgets and proportional grid need verification against widget principles.

## 🎯 Target State
> What should exist after this chore is complete?

All new widgets conform to project conventions and are correctly exported.

## 💡 Justification
> Why is this maintenance needed now?

Ensures quality and consistency before wider use in template showcase.

## ✅ Completion Criteria
> How do we verify the chore is done?

- [ ] Widget APIs use primitive parameters and callbacks only
- [ ] Theme tokens are used (no hardcoded colors)
- [ ] Exports are added in `turbo_widgets.dart`

## 🚧 Constraints
> Any limitations or things to avoid?

- [ ] No behavioral changes beyond the requested scope

## 📝 Notes
> Additional context if needed

Review includes header, toolbar, section, card, list item, and proportional grid types.

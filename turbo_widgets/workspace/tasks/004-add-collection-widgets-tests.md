---
status: to-do
skill-level: medior
parent-type: change
parent-id: add-collection-widgets
type: chore
blocked-by:
  - 002-add-collection-widgets-implementation
---

# 🧹 Test collection widgets

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] 002-add-collection-widgets-implementation

## 🧹 Maintenance Area
> What part of the system needs attention?

Collection widgets rendering and layout behavior.

## 📍 Current State
> What needs cleaning, updating, or removing?

No tests exist for the new collection widgets.

## 🎯 Target State
> What should exist after this chore is complete?

Widget tests cover key rendering and layout scenarios for the new widgets.

## 💡 Justification
> Why is this maintenance needed now?

Ensures new widget APIs render as expected and avoid regressions.

## ✅ Completion Criteria
> How do we verify the chore is done?

- [ ] Widget tests cover header, toolbar, and section layout switching
- [ ] Tests validate bento layout renders proportional grid items

## 🚧 Constraints
> Any limitations or things to avoid?

- [ ] Avoid snapshot/golden tests unless requested

## 📝 Notes
> Additional context if needed

Tests will be added only if explicitly requested.

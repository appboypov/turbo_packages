---
status: to-do
skill-level: senior
parent-type: change
parent-id: prepare-turbo-template-contextual-navigation
type: chore
blocked-by:
  - 012-chore-fix-analysis-errors
---

# 🧹 Chore Template

Use this template for maintenance tasks, documentation, configuration, and non-functional changes.

**Title Format**: `🧹 <Area> chore`

**Examples**:
- 🧹 CI/CD pipeline chore
- 🧹 Documentation update chore

---

## 🔗 Dependencies
> Which tasks need to be completed first (if any)?

- [ ] 012-chore-fix-analysis-errors

## 📋 Task Description
> What needs to be done?

Prepare turbo_widgets and turbo_forms packages for pub.dev release.

---

## 📁 Packages to Prepare

| Package | Current State | Target |
|---------|---------------|--------|
| turbo_widgets | In development | Ready for pub.dev |
| turbo_forms | In development | Ready for pub.dev |

---

## 🔄 Steps

### 1. Review pubspec.yaml

For each package, verify:
- [ ] Name follows pub.dev naming conventions
- [ ] Version is appropriate (semantic versioning)
- [ ] Description is clear and under 180 characters
- [ ] Homepage/repository URL is set
- [ ] Issue tracker URL is set (optional but recommended)
- [ ] Documentation URL is set (optional)
- [ ] Dependencies are properly constrained (^version)
- [ ] SDK constraints are set correctly

### 2. Create/Update CHANGELOG.md

For each package:
- [ ] Document all changes in this release
- [ ] Follow Keep a Changelog format
- [ ] Include version number and date

### 3. Create/Update README.md

For each package, ensure:
- [ ] Clear package description
- [ ] Installation instructions
- [ ] Basic usage examples
- [ ] API highlights
- [ ] License information
- [ ] Badge for pub.dev version (optional)

### 4. Review LICENSE

- [ ] Appropriate license file exists
- [ ] License is compatible with dependencies

### 5. Review example/ Directory

- [ ] Example project exists and compiles
- [ ] Example demonstrates key features
- [ ] Example has its own pubspec.yaml

### 6. Run pub.dev Validation

```bash
cd turbo_widgets && dart pub publish --dry-run
cd turbo_forms && dart pub publish --dry-run
```

Fix any issues reported.

### 7. Documentation Review

- [ ] All public APIs have dartdoc comments
- [ ] No broken documentation links
- [ ] Examples in documentation compile

### 8. Final Checks

- [ ] All tests pass
- [ ] Analysis passes with no errors
- [ ] Package scores well on pub.dev (check with pana)

```bash
dart pub global activate pana
pana turbo_widgets
pana turbo_forms
```

---

## ✅ Acceptance Criteria

- [ ] `dart pub publish --dry-run` succeeds for turbo_widgets
- [ ] `dart pub publish --dry-run` succeeds for turbo_forms
- [ ] README.md is complete and helpful
- [ ] CHANGELOG.md documents all changes
- [ ] All public APIs have documentation
- [ ] Example projects compile and run
- [ ] Pana score is acceptable (aim for 130+)

---

## 📝 Notes

- Do NOT actually publish to pub.dev - only prepare for release
- Publishing is a separate decision made by the maintainer
- Focus on meeting all pub.dev requirements
- Consider creating a pre-release version first (e.g., 1.0.0-beta.1)

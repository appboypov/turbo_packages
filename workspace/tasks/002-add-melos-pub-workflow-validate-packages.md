---
status: to-do
skill-level: medior
parent-type: change
parent-id: add-melos-pub-workflow
---

# Task: Validate and Fix All 7 Packages to 160/160 Pub Points

## End Goal

Run the new `melos pub-check` against all 7 packages and fix any failing validations so all packages achieve 160/160 pub points.

## Currently

Unknown—packages have not been validated against 160/160 pub points criteria. Expected failures in:
- Missing or incomplete CHANGELOG.md
- Incomplete API documentation (< 20%)
- Static analysis errors or warnings
- Platform support declarations

## Should

1. Run `melos pub-check` and document failing packages and categories
2. Fix each failing category systematically:
   - Dart file conventions (pubspec.yaml, LICENSE, README, CHANGELOG)
   - API documentation (doc comments on public members)
   - Platform support (pubspec.yaml declarations)
   - Static analysis (dart analyze, lints, formatting)
   - Dependency freshness (SDK versions, outdated deps)
   - Null safety (enabled)
3. Verify all 7 packages pass with 160/160 pub points
4. Commit fixes with clear messaging per package

## Constraints

- [ ] Must not modify package functionality—only documentation, config, and static files
- [ ] Must follow semantic versioning (no version bumps needed yet, just fixes)
- [ ] Must not remove or change public APIs
- [ ] Must maintain existing CHANGELOG.md format

## Acceptance Criteria

- [ ] All 7 packages pass `melos pub-check` with 160/160 pub points
- [ ] No packages have analysis errors or warnings
- [ ] No packages have formatting issues
- [ ] All packages have CHANGELOG.md in Keep a Changelog format
- [ ] All packages have at least 20% public API documented
- [ ] All packages declare supported platforms
- [ ] No outdated dependencies

## Implementation Checklist

- [ ] 2.1 Run `melos pub-check` and capture baseline results
- [ ] 2.2 Document failing packages and categories in notes
- [ ] 2.3 Fix turbo_response package (likely the simplest, foundation)
- [ ] 2.4 Fix turbo_serializable package
- [ ] 2.5 Fix turbo_notifiers package
- [ ] 2.6 Fix turbo_mvvm package
- [ ] 2.7 Fix turbolytics package
- [ ] 2.8 Fix turbo_firestore_api package
- [ ] 2.9 Fix turbo_promptable package
- [ ] 2.10 Run `melos pub-check` again to confirm all pass
- [ ] 2.11 Commit all fixes

## Notes

- Start with the foundation package (turbo_response) and work down the dependency graph
- Use pana's output to identify which categories are failing
- Documentation fixes: Add doc comments to undocumented public members
- CHANGELOG fixes: Ensure format matches Keep a Changelog (## Version, Added/Changed/Fixed sections)
- Platform support: Add platforms: section to pubspec.yaml if missing
- Analysis: Run dart analyze and fix any issues
- Formatting: Run dart format
- Dependencies: Run dart pub outdated and update if needed

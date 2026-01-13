---
status: to-do
skill-level: junior
parent-type: change
parent-id: add-monorepo-run-configs
---

# Task: Review Monorepo Run Configurations

## End Goal
Verify that all run configurations are correctly implemented, follow turbo_template patterns, and work as expected.

## Currently
Run configurations have been implemented in the previous task.

## Should
All run configurations are validated, tested, and ready for use.

## Constraints
- [ ] Review MUST verify all configurations match turbo_template patterns
- [ ] Review MUST ensure working directories are correct
- [ ] Review MUST check that all required configurations are present
- [ ] Review MUST validate XML and JSON syntax

## Acceptance Criteria
- [ ] All IntelliJ run configurations are present and correctly formatted
- [ ] All Cursor/VS Code launch configurations are present and correctly formatted
- [ ] Working directories are correct for each configuration type
- [ ] Configuration names follow turbo_template conventions
- [ ] All configurations are executable from IDE
- [ ] Documentation or comments explain any non-obvious configuration choices

## Implementation Checklist
- [ ] 2.1 Review IntelliJ run configuration XML syntax
- [ ] 2.2 Review Cursor/VS Code launch configuration JSON syntax
- [ ] 2.3 Verify all Melos operation configurations use root as working directory
- [ ] 2.4 Verify all turbo_template app configurations use turbo_template/flutter-app as working directory
- [ ] 2.5 Compare configuration structure with turbo_template patterns
- [ ] 2.6 Verify environment variables and dart-define flags are correct
- [ ] 2.7 Check that all required configurations are present (no missing operations)
- [ ] 2.8 Validate that configurations can be selected and executed in IDE
- [ ] 2.9 Document any deviations from turbo_template patterns with rationale

## Notes
- Focus on consistency with turbo_template patterns
- Ensure configurations work from monorepo root context
- Verify paths are relative or absolute as appropriate for each IDE

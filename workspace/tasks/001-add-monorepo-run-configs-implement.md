---
status: done
skill-level: junior
parent-type: change
parent-id: add-monorepo-run-configs
---

# Task: Implement Monorepo Run Configurations

## End Goal
Create IntelliJ and Cursor/VS Code run configurations at the monorepo root that allow developers to run common Melos operations and the turbo_template app directly from their IDE.

## Currently
- The root monorepo has no `.run/` directory for IntelliJ configurations
- The root monorepo has no `.vscode/launch.json` for Cursor/VS Code configurations
- Developers must run Melos commands manually from the terminal
- The turbo_template package has run configurations, but they only work when opening that package as a project

## Should
- Root monorepo has `.run/` directory with IntelliJ run configurations for:
  - Melos analyze
  - Melos format
  - Melos test
  - Melos build_runner
  - Melos pub-check
  - Running turbo_template app (emulators, staging, production, demo environments)
- Root monorepo has `.vscode/launch.json` with Cursor/VS Code configurations for the same operations
- Configurations use correct working directories relative to the monorepo root
- Configurations follow the same patterns as turbo_template for consistency

## Constraints
- [ ] Run configurations MUST use correct working directories (root for Melos commands, turbo_template/flutter-app for app runs)
- [ ] Run configurations MUST match the structure and naming conventions used in turbo_template
- [ ] IntelliJ configurations MUST use proper XML format with correct component structure
- [ ] Cursor/VS Code configurations MUST use proper JSON format with correct type and request fields
- [ ] All configurations MUST be executable from the monorepo root

## Acceptance Criteria
- [ ] IntelliJ run configurations exist in `.run/` directory at monorepo root
- [ ] Cursor/VS Code launch configurations exist in `.vscode/launch.json` at monorepo root
- [ ] Melos operation configurations work correctly when executed from IDE
- [ ] turbo_template app run configurations work correctly with proper environment variables
- [ ] All configurations follow turbo_template patterns for consistency
- [ ] Configurations are properly formatted and validate without errors

## Implementation Checklist
- [x] 1.1 Create `.run/` directory at monorepo root
- [x] 1.2 Create IntelliJ run configuration for `melos analyze`
- [x] 1.3 Create IntelliJ run configuration for `melos format`
- [x] 1.4 Create IntelliJ run configuration for `melos test`
- [x] 1.5 Create IntelliJ run configuration for `melos build_runner`
- [x] 1.6 Create IntelliJ run configuration for `melos pub-check`
- [x] 1.7 Create IntelliJ run configuration for turbo_template app (emulators environment)
- [x] 1.8 Create IntelliJ run configuration for turbo_template app (staging environment)
- [x] 1.9 Create IntelliJ run configuration for turbo_template app (production environment)
- [x] 1.10 Create IntelliJ run configuration for turbo_template app (demo environment)
- [x] 1.11 Create `.vscode/` directory at monorepo root if it doesn't exist
- [x] 1.12 Create `.vscode/launch.json` with Melos operation configurations
- [x] 1.13 Add turbo_template app launch configurations to `.vscode/launch.json`
- [x] 1.14 Verify all configurations use correct working directories
- [x] 1.15 Test IntelliJ configurations can be executed
- [x] 1.16 Test Cursor/VS Code configurations can be executed

## Notes
- Reference turbo_template/flutter-app/.run/ and turbo_template/.vscode/launch.json for patterns
- For Melos commands, working directory should be the monorepo root
- For turbo_template app runs, working directory should be turbo_template/flutter-app
- Use dart-define flags for environment variables as shown in turbo_template configurations

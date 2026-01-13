# Implementation Progress: add-melos-pub-workflow

## Tasks Overview

- [ ] Task 1: scripts
- [ ] Task 2: packages
- [ ] Task 3: integration
- [ ] Task 4: documentation
- [ ] Task 5: review
- [ ] Task 6: makefile

---

## Task 1: scripts

**Status:** to-do
**Task ID:** 001-add-melos-pub-workflow-implement-scripts

### Context

<details>
<summary>Proposal Context (click to expand)</summary>

## Why

Currently, package publication to pub.dev is a manual, error-prone process with no automated validation. Developers must remember and execute 10+ commands to ensure 160/160 pub points compliance. This creates:
- Risk of incomplete pre-flight checks before publishing
- Inconsistent package quality across the monorepo
- No enforcement of pub.dev best practices in CI
- Manual dry-run validation with no integration into the workflow

By automating the entire publication workflow into Melos, all packages will meet pub.dev standards before they leave the monorepo, and developers can validate readiness with a single command.

## What Changes

- **New Melos commands**: `melos pub-check` (dry-run validation) and `melos pub-publish` (publish to pub.dev)
- **Pana integration**: Automated 160/160 pub points validation for all packages
- **Pre-flight checks**: Consolidated tests, analysis, formatting, and dependency validation
- **CI automation**: Workflow validation on every PR to main branch
- **Documentation**: Publishing guidelines and checklist in workspace documentation
- **Monorepo configuration**: Enhanced Melos scripts to support publication pipeline
- **Convenience layer**: Makefile with targets for `make test`, `make analyze`, `make format`, `make build`, `make pub-check`, `make pub-publish`
</details>

### Task Details

# Task: Implement Melos pub-check and pub-publish Scripts

## End Goal

Add `pub-check` and `pub-publish` scripts to Melos configuration that validate and publish packages to pub.dev. Developers can run `melos pub-check` to validate 160/160 pub points and `melos pub-publish` to publish.

## Currently

Root pubspec.yaml has Melos scripts for analyze, format, test, and build_runner. No publication workflow exists.

## Should

1. Add `pub-check` script to pubspec.yaml under melos.scripts
2. Add `pub-publish` script to pubspec.yaml under melos.scripts
3. Create wrapper shell scripts in tool/ directory to execute the pub workflow
4. Support --dry-run and --confirmed flags for publishing
5. Output clear validation status for each package

## Constraints

- [ ] Must use pana for 160/160 pub points validation
- [ ] Must validate packages sequentially (not in parallel) for clear error reporting
- [ ] Must not publish in CI environments (pub-check only)
- [ ] Must be portable and work on macOS, Linux, and CI runners
- [ ] Must output clear error messages when validation fails
- [ ] Must handle packages with no tests or platform-specific code

## Acceptance Criteria

- [ ] `melos pub-check` runs successfully and validates all 7 packages
- [ ] `melos pub-check` reports 160/160 pub points for each package (or fails with details)
- [ ] `melos pub-publish --dry-run` runs without publishing
- [ ] `melos pub-publish` (without flag) requires confirmation before publishing
- [ ] All scripts are defined in root pubspec.yaml under melos.scripts
- [ ] Wrapper scripts are in tool/ directory and executable
- [ ] Scripts handle package filtering and error cases gracefully

## Implementation Checklist

- [x] 1.1 Add pana as dev_dependency in root pubspec.yaml
- [x] 1.2 Create tool/pub_check.sh wrapper script
- [x] 1.3 Create tool/pub_publish.sh wrapper script
- [x] 1.4 Add pub-check Melos script to pubspec.yaml (melos.scripts)
- [x] 1.5 Add pub-publish Melos script to pubspec.yaml (melos.scripts)
- [x] 1.6 Test pub-check locally against all packages
- [x] 1.7 Test pub-publish --dry-run locally
- [x] 1.8 Verify scripts handle errors and edge cases

## Notes

- Pana must be installed as a dev dependency so melos can invoke it
- Scripts should validate in this order: conventions → docs → analysis → formatting → pana
- The --dry-run flag for pub-publish should run pana + dart pub publish --dry-run but not actually publish
- Consider using exec:concurrency: 1 in Melos to ensure sequential validation (easier to debug)

### Agent Instructions

Pick up this task and implement it according to the specifications above.
Focus on the Constraints and Acceptance Criteria sections.
When complete, mark the task as done:

```bash
splx complete task --id 001-add-melos-pub-workflow-implement-scripts
```

---

## Task 2: packages

**Status:** to-do
**Task ID:** 002-add-melos-pub-workflow-validate-packages

### Context

<details>
<summary>Proposal Context (click to expand)</summary>

## Why

Currently, package publication to pub.dev is a manual, error-prone process with no automated validation. Developers must remember and execute 10+ commands to ensure 160/160 pub points compliance. This creates:
- Risk of incomplete pre-flight checks before publishing
- Inconsistent package quality across the monorepo
- No enforcement of pub.dev best practices in CI
- Manual dry-run validation with no integration into the workflow

By automating the entire publication workflow into Melos, all packages will meet pub.dev standards before they leave the monorepo, and developers can validate readiness with a single command.

## What Changes

- **New Melos commands**: `melos pub-check` (dry-run validation) and `melos pub-publish` (publish to pub.dev)
- **Pana integration**: Automated 160/160 pub points validation for all packages
- **Pre-flight checks**: Consolidated tests, analysis, formatting, and dependency validation
- **CI automation**: Workflow validation on every PR to main branch
- **Documentation**: Publishing guidelines and checklist in workspace documentation
- **Monorepo configuration**: Enhanced Melos scripts to support publication pipeline
- **Convenience layer**: Makefile with targets for `make test`, `make analyze`, `make format`, `make build`, `make pub-check`, `make pub-publish`
</details>

### Task Details

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

### Agent Instructions

Pick up this task and implement it according to the specifications above.
Focus on the Constraints and Acceptance Criteria sections.
When complete, mark the task as done:

```bash
splx complete task --id 002-add-melos-pub-workflow-validate-packages
```

---

## Task 3: integration

**Status:** to-do
**Task ID:** 003-add-melos-pub-workflow-ci-integration

### Context

<details>
<summary>Proposal Context (click to expand)</summary>

## Why

Currently, package publication to pub.dev is a manual, error-prone process with no automated validation. Developers must remember and execute 10+ commands to ensure 160/160 pub points compliance. This creates:
- Risk of incomplete pre-flight checks before publishing
- Inconsistent package quality across the monorepo
- No enforcement of pub.dev best practices in CI
- Manual dry-run validation with no integration into the workflow

By automating the entire publication workflow into Melos, all packages will meet pub.dev standards before they leave the monorepo, and developers can validate readiness with a single command.

## What Changes

- **New Melos commands**: `melos pub-check` (dry-run validation) and `melos pub-publish` (publish to pub.dev)
- **Pana integration**: Automated 160/160 pub points validation for all packages
- **Pre-flight checks**: Consolidated tests, analysis, formatting, and dependency validation
- **CI automation**: Workflow validation on every PR to main branch
- **Documentation**: Publishing guidelines and checklist in workspace documentation
- **Monorepo configuration**: Enhanced Melos scripts to support publication pipeline
- **Convenience layer**: Makefile with targets for `make test`, `make analyze`, `make format`, `make build`, `make pub-check`, `make pub-publish`
</details>

### Task Details

# Task: Add GitHub Actions Workflow for CI Validation

## End Goal

Create a GitHub Actions workflow that automatically validates all packages with `melos pub-check` on every PR to main. The workflow SHALL fail PRs that don't pass 160/160 pub points validation.

## Currently

No CI validation of pub.dev readiness. PRs can be merged with unpublishable code.

## Should

1. Create .github/workflows/pub-check.yml workflow file
2. Trigger on PRs to main branch
3. Run `melos pub-check` for all packages
4. Fail the PR if any package doesn't meet 160/160 pub points
5. Report clear error messages indicating which packages/categories fail
6. Run only pub-check (dry-run validation), never publish to pub.dev

## Constraints

- [ ] Must not require pub.dev authentication (dry-run only)
- [ ] Must not publish to pub.dev under any circumstances
- [ ] Must complete in < 5 minutes for timely feedback
- [ ] Must clearly report which packages and categories fail
- [ ] Must cache dependencies to speed up runs

## Acceptance Criteria

- [ ] Workflow file exists at .github/workflows/pub-check.yml
- [ ] Workflow triggers on PR to main branch
- [ ] Workflow runs `melos pub-check` successfully
- [ ] Workflow fails if any package doesn't achieve 160/160 pub points
- [ ] Workflow reports which packages failed and why
- [ ] Workflow uses cached dependencies for performance
- [ ] Workflow completes in < 5 minutes

## Implementation Checklist

- [ ] 3.1 Create .github/workflows/pub-check.yml
- [ ] 3.2 Configure trigger: pull_request to main branch
- [ ] 3.3 Add job to set up Dart environment
- [ ] 3.4 Cache pub dependencies (.pub-cache)
- [ ] 3.5 Run `melos bootstrap` to fetch dependencies
- [ ] 3.6 Run `melos pub-check`
- [ ] 3.7 Configure workflow to fail on pub-check failure
- [ ] 3.8 Add step to report results (optional: post comment on PR)
- [ ] 3.9 Test workflow on a test PR
- [ ] 3.10 Verify workflow passes on main branch

## Notes

- Use setup-dart@v1 action for Dart environment
- Cache key should include pubspec.lock for dependency stability
- Consider using actions/cache@v3 or setup-dart's built-in caching
- The workflow should run sequentially (already handled by melos pub-check)
- Error reporting: use job output or workflow annotation format
- Optional: Post a summary comment on the PR showing which packages passed/failed

### Agent Instructions

Pick up this task and implement it according to the specifications above.
Focus on the Constraints and Acceptance Criteria sections.
When complete, mark the task as done:

```bash
splx complete task --id 003-add-melos-pub-workflow-ci-integration
```

---

## Task 4: documentation

**Status:** to-do
**Task ID:** 004-add-melos-pub-workflow-documentation

### Context

<details>
<summary>Proposal Context (click to expand)</summary>

## Why

Currently, package publication to pub.dev is a manual, error-prone process with no automated validation. Developers must remember and execute 10+ commands to ensure 160/160 pub points compliance. This creates:
- Risk of incomplete pre-flight checks before publishing
- Inconsistent package quality across the monorepo
- No enforcement of pub.dev best practices in CI
- Manual dry-run validation with no integration into the workflow

By automating the entire publication workflow into Melos, all packages will meet pub.dev standards before they leave the monorepo, and developers can validate readiness with a single command.

## What Changes

- **New Melos commands**: `melos pub-check` (dry-run validation) and `melos pub-publish` (publish to pub.dev)
- **Pana integration**: Automated 160/160 pub points validation for all packages
- **Pre-flight checks**: Consolidated tests, analysis, formatting, and dependency validation
- **CI automation**: Workflow validation on every PR to main branch
- **Documentation**: Publishing guidelines and checklist in workspace documentation
- **Monorepo configuration**: Enhanced Melos scripts to support publication pipeline
- **Convenience layer**: Makefile with targets for `make test`, `make analyze`, `make format`, `make build`, `make pub-check`, `make pub-publish`
</details>

### Task Details

# Task: Document Publishing Guidelines and Workflow

## End Goal

Add comprehensive publishing guidelines to workspace documentation so developers understand the pub.dev publication process, 160/160 pub points criteria, and how to use the new Melos workflow.

## Currently

No documentation on publishing to pub.dev. Developers are unaware of pub points, CHANGELOG format, or how to prepare packages for publication.

## Should

1. Add "Publishing Packages to pub.dev" section to workspace/AGENTS.md
2. Explain the 160/160 pub points breakdown and categories
3. Document pre-publish checklist
4. Provide examples of compliant CHANGELOG.md format
5. Link to pub.dev documentation and best practices
6. Explain how to use `melos pub-check` and `melos pub-publish`
7. List common issues and how to fix them
8. Document semantic versioning conventions

## Constraints

- [ ] Must be discoverable and linked from README.md
- [ ] Must explain pub points in simple, actionable terms
- [ ] Must include real examples from turbo_packages packages (after they pass)
- [ ] Must reference workspace/ARCHITECTURE.md conventions

## Acceptance Criteria

- [ ] Section added to workspace/AGENTS.md
- [ ] 160/160 pub points breakdown documented
- [ ] Pre-publish checklist provided
- [ ] CHANGELOG.md format documented with examples
- [ ] Semantic versioning guidelines included
- [ ] Melos workflow commands documented
- [ ] Common issues and solutions listed
- [ ] README.md updated with link to publishing guide

## Implementation Checklist

- [ ] 4.1 Review existing workspace/AGENTS.md structure
- [ ] 4.2 Add "Publishing Packages to pub.dev" section
- [ ] 4.3 Document the 160/160 pub points categories with explanations
- [ ] 4.4 Create pre-publish checklist
- [ ] 4.5 Document CHANGELOG.md format with Keep a Changelog example
- [ ] 4.6 Explain semantic versioning (MAJOR.MINOR.PATCH)
- [ ] 4.7 Document `melos pub-check` command and output
- [ ] 4.8 Document `melos pub-publish --dry-run` command
- [ ] 4.9 Document `melos pub-publish` command and safety confirmations
- [ ] 4.10 List 10 common issues and how to fix them
- [ ] 4.11 Add links to pub.dev documentation
- [ ] 4.12 Update README.md with link to publishing guide

## Notes

- Keep examples concise and specific to turbo_packages
- Reference existing packages' CHANGELOGs as examples after they pass validation
- Explain why each pub point category matters (e.g., documentation helps users)
- Consider adding a section on version constraints and workspace resolution
- Include a "When to publish" decision tree (major vs minor vs patch)
- Mention that publishing is permanent (versions can't be deleted, only retracted)

### Agent Instructions

Pick up this task and implement it according to the specifications above.
Focus on the Constraints and Acceptance Criteria sections.
When complete, mark the task as done:

```bash
splx complete task --id 004-add-melos-pub-workflow-documentation
```

---

## Task 5: review

**Status:** to-do
**Task ID:** 005-add-melos-pub-workflow-review

### Context

<details>
<summary>Proposal Context (click to expand)</summary>

## Why

Currently, package publication to pub.dev is a manual, error-prone process with no automated validation. Developers must remember and execute 10+ commands to ensure 160/160 pub points compliance. This creates:
- Risk of incomplete pre-flight checks before publishing
- Inconsistent package quality across the monorepo
- No enforcement of pub.dev best practices in CI
- Manual dry-run validation with no integration into the workflow

By automating the entire publication workflow into Melos, all packages will meet pub.dev standards before they leave the monorepo, and developers can validate readiness with a single command.

## What Changes

- **New Melos commands**: `melos pub-check` (dry-run validation) and `melos pub-publish` (publish to pub.dev)
- **Pana integration**: Automated 160/160 pub points validation for all packages
- **Pre-flight checks**: Consolidated tests, analysis, formatting, and dependency validation
- **CI automation**: Workflow validation on every PR to main branch
- **Documentation**: Publishing guidelines and checklist in workspace documentation
- **Monorepo configuration**: Enhanced Melos scripts to support publication pipeline
- **Convenience layer**: Makefile with targets for `make test`, `make analyze`, `make format`, `make build`, `make pub-check`, `make pub-publish`
</details>

### Task Details

# Task: Review and Test Complete Pub Workflow

## End Goal

Verify that all components of the pub workflow are working correctly: Melos scripts, package validation, CI integration, and documentation. Ensure the workflow is ready for production use.

## Currently

Individual components have been implemented and tested:
1. Melos pub-check and pub-publish scripts
2. All 7 packages pass 160/160 pub points
3. GitHub Actions workflow validates on PRs
4. Documentation added to workspace/AGENTS.md

## Should

1. End-to-end test of the complete workflow
2. Verify all scripts work as documented
3. Test CI validation on a real PR
4. Verify documentation is clear and complete
5. Check for any edge cases or gaps
6. Confirm no regressions in other Melos scripts

## Constraints

- [ ] Must not publish to pub.dev (use --dry-run for final tests)
- [ ] Must verify all 7 packages still pass validation
- [ ] Must check that documentation is accurate
- [ ] Must ensure no breaking changes to existing workflows

## Acceptance Criteria

- [ ] `melos pub-check` runs and reports 160/160 for all packages
- [ ] `melos pub-publish --dry-run` validates without publishing
- [ ] CI workflow passes on a test PR
- [ ] Documentation is clear, complete, and discoverable
- [ ] No regressions in existing Melos scripts (analyze, format, test, build_runner)
- [ ] All edge cases handled (network errors, auth failures, etc.)
- [ ] Performance is acceptable (< 5 minutes for full validation)

## Implementation Checklist

- [ ] 5.1 Run `melos pub-check` on all packages locally
- [ ] 5.2 Verify 160/160 pub points output for each package
- [ ] 5.3 Run `melos pub-publish --dry-run` and verify no publishing
- [ ] 5.4 Create a test PR and verify CI workflow runs
- [ ] 5.5 Verify CI passes when all packages are valid
- [ ] 5.6 Break something intentionally (remove a doc comment) on a test branch
- [ ] 5.7 Verify CI fails on the test PR with clear error message
- [ ] 5.8 Fix the test branch and verify CI passes again
- [ ] 5.9 Run all existing Melos scripts (analyze, format, test) to check for regressions
- [ ] 5.10 Review workspace/AGENTS.md documentation for clarity and completeness
- [ ] 5.11 Verify README.md links to publishing guide
- [ ] 5.12 Check that all spec requirements are met

## Notes

- Test both success and failure paths
- Verify error messages are clear and actionable
- Check that pub-check output format is easy to parse and understand
- Confirm that documentation examples are accurate (use real package names)
- Test on different OSes if possible (macOS, Linux, CI runner)
- Verify performance: pub-check should complete in < 3-5 minutes
- Ensure no sensitive credentials are logged or exposed

### Agent Instructions

Pick up this task and implement it according to the specifications above.
Focus on the Constraints and Acceptance Criteria sections.
When complete, mark the task as done:

```bash
splx complete task --id 005-add-melos-pub-workflow-review
```

---

## Task 6: makefile

**Status:** to-do
**Task ID:** 006-add-melos-pub-workflow-makefile

### Context

<details>
<summary>Proposal Context (click to expand)</summary>

## Why

Currently, package publication to pub.dev is a manual, error-prone process with no automated validation. Developers must remember and execute 10+ commands to ensure 160/160 pub points compliance. This creates:
- Risk of incomplete pre-flight checks before publishing
- Inconsistent package quality across the monorepo
- No enforcement of pub.dev best practices in CI
- Manual dry-run validation with no integration into the workflow

By automating the entire publication workflow into Melos, all packages will meet pub.dev standards before they leave the monorepo, and developers can validate readiness with a single command.

## What Changes

- **New Melos commands**: `melos pub-check` (dry-run validation) and `melos pub-publish` (publish to pub.dev)
- **Pana integration**: Automated 160/160 pub points validation for all packages
- **Pre-flight checks**: Consolidated tests, analysis, formatting, and dependency validation
- **CI automation**: Workflow validation on every PR to main branch
- **Documentation**: Publishing guidelines and checklist in workspace documentation
- **Monorepo configuration**: Enhanced Melos scripts to support publication pipeline
- **Convenience layer**: Makefile with targets for `make test`, `make analyze`, `make format`, `make build`, `make pub-check`, `make pub-publish`
</details>

### Task Details

# Task: Create Makefile for Development Convenience

## End Goal

Create a Makefile at the monorepo root that provides convenient shorthand commands for common development tasks. Make delegates to Melos for actual execution, providing a discoverable interface for all developers.

## Currently

Developers must remember and type full Melos commands (`melos analyze`, `melos test`, etc.). No centralized command reference.

## Should

1. Create Makefile at repository root with targets for:
   - `make analyze` → `melos analyze`
   - `make format` → `melos format`
   - `make test` → `melos test`
   - `make build` → `melos build_runner`
   - `make pub-check` → `melos pub-check`
   - `make pub-publish` → `melos pub-publish`
   - `make all` → Runs analyze, format, test (full CI pipeline)
   - `make help` → Shows all available commands
2. Include helpful comments and descriptions
3. Support common Make conventions (`.DEFAULT_GOAL`, `.PHONY`)
4. Format output clearly for easy reading

## Constraints

- [ ] Must not duplicate logic—only delegate to Melos
- [ ] Must work on macOS, Linux, and CI runners
- [ ] Must include help text for all targets
- [ ] Must be documented in README.md

## Acceptance Criteria

- [ ] Makefile exists at repository root
- [ ] `make help` shows all available commands
- [ ] `make analyze` runs Melos analyze
- [ ] `make format` runs Melos format
- [ ] `make test` runs Melos test
- [ ] `make build` runs Melos build_runner
- [ ] `make pub-check` runs Melos pub-check
- [ ] `make pub-publish` runs Melos pub-publish
- [ ] `make all` runs the full CI pipeline
- [ ] All targets work locally and in CI
- [ ] Makefile is documented in README.md

## Implementation Checklist

- [ ] 6.1 Create Makefile at root with `.DEFAULT_GOAL := help` and `.PHONY` declarations
- [ ] 6.2 Add help target with grep-based command listing
- [ ] 6.3 Add analyze target → `melos analyze`
- [ ] 6.4 Add format target → `melos format`
- [ ] 6.5 Add test target → `melos test`
- [ ] 6.6 Add build target → `melos build_runner`
- [ ] 6.7 Add pub-check target → `melos pub-check`
- [ ] 6.8 Add pub-publish target → `melos pub-publish`
- [ ] 6.9 Add all target → runs analyze, format, test
- [ ] 6.10 Test all targets locally
- [ ] 6.11 Update README.md with "Make Commands" section
- [ ] 6.12 Verify Makefile works in CI environment

## Notes

- Use `.PHONY` for all non-file targets to avoid Make treating them as files
- Help target should list all targets with descriptions in sorted order
- Consider adding optional targets like `make clean` for generated artifacts
- Use `@` prefix in recipes to suppress echoing the command itself
- Format descriptions consistently (## for comments in Makefile)
- Example help output:
  ```
  Usage: make [target]

  Targets:
    analyze       Static analysis across all packages
    build         Run build_runner to generate code
    format        Format all packages
    pub-check     Validate 160/160 pub points
    pub-publish   Publish to pub.dev
    test          Run tests with coverage
    all           Run full CI pipeline (analyze, format, test)
  ```

### Agent Instructions

Pick up this task and implement it according to the specifications above.
Focus on the Constraints and Acceptance Criteria sections.
When complete, mark the task as done:

```bash
splx complete task --id 006-add-melos-pub-workflow-makefile
```

---

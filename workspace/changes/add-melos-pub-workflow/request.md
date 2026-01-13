# Request: Add Melos Pub Workflow

## Source Input

User wants to make Flutter/Dart package publication (pub.dev) a first-class Melos workflow with:
- Automated 160/160 pub points validation
- All pre-publish checks (tests, analysis, formatting, linting, etc.)
- Command-line interface for local and CI execution
- Integration into development workflow

Reference: Flutter Package Best Practices guide covering pub points scoring, semantic versioning, documentation requirements, publishing workflow, and code quality standards.

## Current Understanding

**Goal**: Create an automated pub.dev publication workflow integrated into Melos for the turbo_packages monorepo.

**Scope**: All 7 packages in the monorepo must follow the workflow.

**Commands Needed**:
- `melos pub-check` - Validate all packages meet 160/160 pub points criteria (dry-run)
- `melos pub-publish` - Validate and publish to pub.dev (requires auth)

**Execution**:
- On-demand: Developer runs commands locally
- Pre-push: Validate packages before pushing to Git

**Validation Criteria** (160 total pub points):
1. Follow Dart conventions (30 pts): pubspec.yaml, LICENSE, README.md, CHANGELOG.md, lib exports
2. Provide documentation (20 pts): 20%+ API docs, working examples
3. Platform support (20 pts): Multi-platform declaration
4. Pass static analysis (50 pts): zero errors, lints, formatting
5. Support up-to-date dependencies (20 pts): Latest SDK/Flutter compatibility
6. Null safety (20 pts): Sound null safety enabled

**Tools**: Pana (pub points local validation), Dart analyzer, formatter, test runner

## Decisions Made

1. **Integration**: New Melos commands, not Makefile—leverage existing Melos infrastructure
2. **Validation Trigger**: On-demand (`melos pub-check`) and pre-push hooks
3. **Publish Commands**: Two separate commands for safety (dry-run vs. real publish)
4. **Scope**: All 7 packages in monorepo
5. **Automation**: CI enforcement on PRs to main branch

## Final Intent

Implement a comprehensive Melos-based pub.dev publication workflow that:
- Validates all packages achieve 160/160 pub points locally
- Provides `melos pub-check` command for pre-flight validation
- Provides `melos pub-publish` command for dry-run and real publishing
- Runs automatically in CI before merging to main
- Documents all requirements in workspace/AGENTS.md or new docs
- Ensures consistent, high-quality package publication across the monorepo

---

**Next Step**: Run `splx/plan-proposal add-melos-pub-workflow` to create the formal proposal.

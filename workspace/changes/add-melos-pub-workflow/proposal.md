# Change: Add Melos-Integrated Pub.dev Publication Workflow

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

## Impact

- **Affected capabilities**:
  - monorepo-structure (extend with pub workflow scripts)
  - new: package-publication (define publication process and standards)

- **Affected code**:
  - pubspec.yaml (root Melos config)
  - .github/workflows/ (CI validation)
  - workspace/AGENTS.md or new documentation

- **Breaking changes**: None—this is purely additive
- **Dependencies**: pana (for pub points validation)

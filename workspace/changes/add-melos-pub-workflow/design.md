# Design: Melos Pub.dev Publication Workflow

## Context

The turbo_packages monorepo contains 7 Dart/Flutter packages intended for pub.dev distribution. Currently, publication is manual with no automated validation. Pub.dev awards up to 160 points across six categories:

1. Dart conventions (30 pts) - pubspec.yaml, LICENSE, README.md, CHANGELOG.md
2. Documentation (20 pts) - 20%+ API docs, working examples
3. Platform support (20 pts) - Multi-platform declarations
4. Static analysis (50 pts) - Zero errors/warnings, lints, formatting
5. Up-to-date dependencies (20 pts) - Latest SDK/Flutter compatibility
6. Null safety (20 pts) - Sound null safety

## Goals

1. **Automate publication validation**: All packages must achieve 160/160 pub points before publishing
2. **Simplify developer workflow**: One command to validate, one to publish
3. **Enforce quality in CI**: Prevent unpublishable code from merging to main
4. **Document standards**: Clear guidelines for maintaining pub.dev quality
5. **Support both dry-run and real publishing**: Separate commands for safety

## Non-Goals

- Automatic versioning or CHANGELOG management (handled by `melos version`)
- Custom pub.dev integration beyond standard `dart pub publish`
- Platform-specific package support modifications
- Performance optimizations beyond standard Dart tooling

## Decisions

### 1. Architecture: Melos Scripts + Pana Integration

**Decision**: Use Melos scripts to orchestrate validation and publishing, with pana as the 160/160 pub points validator.

**Rationale**:
- Melos already manages monorepo scripts; publication is a natural extension
- Pana is the official pub.dev scoring tool (used by pub.dev itself)
- Pana can run locally for instant feedback before pushing
- Scripts are portable, language-agnostic, documented in pubspec.yaml

**Alternatives considered**:
- Custom Bash script: Less discoverable, not integrated with Melos UX
- Makefile: Parallel infrastructure, harder to filter by package
- GitHub Actions only: No local validation, slower feedback loop

### 2. Command Structure: Two Separate Commands

**Decision**:
- `melos pub-check` - Validates all packages meet 160/160 pub points (dry-run)
- `melos pub-publish --dry-run` - Validate and publish dry-run
- `melos pub-publish` - Validate and publish to pub.dev (real)

**Rationale**:
- Separation of concerns: validation (pub-check) vs. publishing (pub-publish)
- Safety: Explicit flags prevent accidental publishing
- Workflow: Developers run pub-check before each push, pub-publish in CI or manually

**Alternatives considered**:
- Single command with --publish flag: Less clear intent, higher accident risk
- Makefile targets: Less integrated with Melos, requires separate infrastructure

### 3. Validation Flow: Sequential, Per-Package

**Decision**: Run validation sequentially for each package to:
1. Identify all pub.dev requirements (conventions, docs, platform support)
2. Run Dart analysis (zero errors/warnings)
3. Run tests (success)
4. Check formatting (pass)
5. Verify dependency freshness
6. Run pana for 160/160 pub points score

**Rationale**:
- Early stopping: Fix conventions and documentation before expensive analysis
- Clear error messages: Developers see which checks fail first
- Pana accuracy: Only runs final validation after other checks pass

### 4. CI Integration: Pre-Merge Validation

**Decision**: GitHub Actions workflow validates packages on every PR to main.

**Constraints**:
- Run pub-check (not pub-publish) in CI—no actual publishing
- Fail PR if any package doesn't meet 160/160 pub points
- Publish only manually or via dedicated release workflow

**Rationale**:
- Prevents broken code from merging
- Gives developers clear feedback before requesting review
- Decouples validation (automated) from publishing (manual/gated)

### 5. Documentation: Publishing Checklist in AGENTS.md

**Decision**: Add pub.dev publishing section to workspace/AGENTS.md with:
- 160/160 pub points breakdown
- Pre-publish checklist
- Version numbering guidelines
- Common issues and fixes

**Rationale**:
- Centralized with other monorepo guidelines
- Discoverable for all developers
- Linked from README.md and CI validation errors

## Migration Plan

### Phase 1: Setup (Day 1)
1. Add `pub-check` script to Melos (pubspec.yaml)
2. Add `pub-publish` script to Melos
3. Install pana as dev dependency
4. Document in workspace/AGENTS.md

### Phase 2: Validation (Day 2-3)
1. Run `melos pub-check` against all 7 packages
2. Fix failing packages to achieve 160/160 pub points
3. Commit fixes with clear messaging

### Phase 3: CI Integration (Day 3-4)
1. Add GitHub Actions workflow for pub-check on PRs
2. Test workflow on a test PR
3. Document in README.md

### Phase 4: Ongoing
1. All PRs are validated automatically
2. Developers use `melos pub-check` before pushing
3. Publishing via `melos pub-publish` after approval

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| **Pana failures on CI due to SDK differences** | Test locally first; use stable SDK versions in CI |
| **Packages fail 160/160 initially** | Run pub-check early, fix systematically by category |
| **Developers forget to run pub-check** | Add pre-commit hook reminder; CI blocks if validation fails |
| **Accidental publishing** | Require explicit `melos pub-publish` (no --publish default) |
| **Pana installation fails in CI** | Cache pana binary; use explicit activation step |

## Trade-offs

1. **Local validation time**: Pana adds ~30-60s per package to validation. Acceptable for quality assurance.
2. **Pana strictness**: Pana is opinionated (requires CHANGELOG.md format, etc.). Aligns with pub.dev best practices.
3. **CI resource usage**: Full validation on every PR. Acceptable for quality gates on a 7-package monorepo.

## Open Questions

None—intent fully captured in request.md.

## Makefile Strategy

**Decision**: Provide a Makefile convenience layer that wraps Melos commands.

**Rationale**:
- `make test` is more discoverable and memorable than `melos test`
- Single file for developers to find all available commands
- No logic duplication—Make only delegates to Melos
- Traditional convention: developers expect a Makefile at monorepo root
- `make help` provides self-documenting interface

**No overlap**: Make is not a substitute for Melos orchestration; it's a convenience layer.

## Implementation Sequence

1. Add specs for package-publication capability and Makefile convenience
2. Create Melos scripts (pub-check, pub-publish)
3. Add pana integration and shell wrappers
4. Create Makefile at root with development targets
5. Create GitHub Actions workflow
6. Run initial validation and fix failing packages
7. Document in AGENTS.md and README.md
8. Test locally and in CI

---
status: done
status: completed
skill-level: junior
parent-type: change
parent-id: add-melos-pub-workflow
---

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

- [x] 6.1 Create Makefile at root with `.DEFAULT_GOAL := help` and `.PHONY` declarations
- [x] 6.2 Add help target with grep-based command listing
- [x] 6.3 Add analyze target → `melos analyze`
- [x] 6.4 Add format target → `melos format`
- [x] 6.5 Add test target → `melos test`
- [x] 6.6 Add build target → `melos build_runner`
- [x] 6.7 Add pub-check target → `melos pub-check`
- [x] 6.8 Add pub-publish target → `melos pub-publish`
- [x] 6.9 Add all target → runs analyze, format, test
- [x] 6.10 Test all targets locally
- [x] 6.11 Update README.md with "Make Commands" section
- [x] 6.12 Verify Makefile works in CI environment (requires CI run - manual step)

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

# Implementation Progress: remove-github-actions-pipelines

## Tasks Overview

- [ ] Task 1: workflows
- [ ] Task 2: docs
- [ ] Task 3: changes

---

## Task 1: workflows

**Status:** to-do
**Task ID:** 001-remove-github-actions-pipelines-delete-workflows

### Context

<details>
<summary>Proposal Context (click to expand)</summary>

## Why

Currently, GitHub Actions workflows automatically publish packages to pub.dev when version numbers change. This creates:
- Risk of accidental publication without proper review
- Loss of manual control over when packages are published
- Automated tag and release creation that may not align with release strategy
- CI complexity that may not be necessary for a monorepo with manual release cycles

By removing all GitHub Actions publishing pipelines, all publication will be manual, giving developers full control over when and how packages are published to pub.dev.

## What Changes

- **Remove root-level CI workflow**: Delete `.github/workflows/pub-check.yml` (PR validation workflow)
- **Remove package-level publish workflows**: Delete all `.github/workflows/publish.yml` files from individual packages
- **Update specifications**: Modify package-publication and monorepo-structure specs to reflect manual-only publishing
- **Update documentation**: Remove references to CI automation from workspace/AGENTS.md
</details>

### Task Details

# Task: Delete GitHub Actions Workflow Files

## End Goal
Remove all GitHub Actions workflow files that automate publishing or validation, ensuring all publishing is manual.

## Currently
- Root-level `.github/workflows/pub-check.yml` validates packages on PRs
- Package-level `.github/workflows/publish.yml` files in turbo_mvvm, turbo_notifiers, and turbolytics automatically publish when version changes
- These workflows create tags, releases, and publish to pub.dev automatically

## Should
- All GitHub Actions workflow files related to publishing are deleted
- No automated publishing occurs
- Developers must manually run `melos pub-publish` to publish packages

## Constraints
- [ ] Must delete root-level pub-check.yml workflow
- [ ] Must delete all package-level publish.yml workflows
- [ ] Must not break any existing manual publishing commands (melos pub-publish)
- [ ] Must preserve any non-publishing workflows if they exist

## Acceptance Criteria
- [ ] `.github/workflows/pub-check.yml` is deleted
- [ ] `turbo_mvvm/.github/workflows/publish.yml` is deleted
- [ ] `turbo_notifiers/.github/workflows/publish.yml` is deleted
- [ ] `turbolytics/.github/workflows/publish.yml` is deleted
- [ ] No other publish-related workflows remain
- [ ] Manual publishing via `melos pub-publish` still works

## Implementation Checklist
- [ ] 1.1 Delete `.github/workflows/pub-check.yml`
- [ ] 1.2 Delete `turbo_mvvm/.github/workflows/publish.yml`
- [ ] 1.3 Delete `turbo_notifiers/.github/workflows/publish.yml`
- [ ] 1.4 Delete `turbolytics/.github/workflows/publish.yml`
- [ ] 1.5 Verify no other publish-related workflows exist
- [ ] 1.6 Test that `melos pub-publish --dry-run` still works locally

## Notes
After deletion, all publishing must be done manually using `melos pub-publish`. Developers should run `melos pub-check` locally before publishing to ensure packages meet 160/160 pub points.

### Agent Instructions

Pick up this task and implement it according to the specifications above.
Focus on the Constraints and Acceptance Criteria sections.
When complete, mark the task as done:

```bash
splx complete task --id 001-remove-github-actions-pipelines-delete-workflows
```

---

## Task 2: docs

**Status:** to-do
**Task ID:** 002-remove-github-actions-pipelines-update-docs

### Context

<details>
<summary>Proposal Context (click to expand)</summary>

## Why

Currently, GitHub Actions workflows automatically publish packages to pub.dev when version numbers change. This creates:
- Risk of accidental publication without proper review
- Loss of manual control over when packages are published
- Automated tag and release creation that may not align with release strategy
- CI complexity that may not be necessary for a monorepo with manual release cycles

By removing all GitHub Actions publishing pipelines, all publication will be manual, giving developers full control over when and how packages are published to pub.dev.

## What Changes

- **Remove root-level CI workflow**: Delete `.github/workflows/pub-check.yml` (PR validation workflow)
- **Remove package-level publish workflows**: Delete all `.github/workflows/publish.yml` files from individual packages
- **Update specifications**: Modify package-publication and monorepo-structure specs to reflect manual-only publishing
- **Update documentation**: Remove references to CI automation from workspace/AGENTS.md
</details>

### Task Details

# Task: Update Documentation to Reflect Manual Publishing

## End Goal
Update workspace documentation to remove all references to CI automation and clarify that publishing is manual-only.

## Currently
- `workspace/AGENTS.md` contains references to GitHub Actions workflows for validation
- Documentation mentions CI automation for publishing
- Specs reference CI workflows that no longer exist

## Should
- All documentation clearly states publishing is manual-only
- References to CI automation are removed
- Instructions emphasize running `melos pub-check` locally before publishing
- No mention of automated validation or publishing workflows

## Constraints
- [ ] Must update workspace/AGENTS.md to remove CI references
- [ ] Must preserve all manual publishing instructions
- [ ] Must clarify that developers must validate locally before publishing
- [ ] Must not remove useful publishing guidance

## Acceptance Criteria
- [ ] workspace/AGENTS.md no longer references GitHub Actions workflows
- [ ] Publishing section clearly states all publishing is manual
- [ ] Instructions emphasize local validation with `melos pub-check`
- [ ] No confusion about automated vs manual publishing

## Implementation Checklist
- [ ] 2.1 Review workspace/AGENTS.md for CI/publishing references
- [ ] 2.2 Remove section about GitHub Actions workflow validation
- [ ] 2.3 Update publishing instructions to emphasize manual process
- [ ] 2.4 Add note that developers must run `melos pub-check` locally
- [ ] 2.5 Verify all references to automated publishing are removed

## Notes
Focus on making it clear that publishing is a manual, intentional action. Developers should understand they have full control over when packages are published.

### Agent Instructions

Pick up this task and implement it according to the specifications above.
Focus on the Constraints and Acceptance Criteria sections.
When complete, mark the task as done:

```bash
splx complete task --id 002-remove-github-actions-pipelines-update-docs
```

---

## Task 3: changes

**Status:** to-do
**Task ID:** 003-remove-github-actions-pipelines-verify-changes

### Context

<details>
<summary>Proposal Context (click to expand)</summary>

## Why

Currently, GitHub Actions workflows automatically publish packages to pub.dev when version numbers change. This creates:
- Risk of accidental publication without proper review
- Loss of manual control over when packages are published
- Automated tag and release creation that may not align with release strategy
- CI complexity that may not be necessary for a monorepo with manual release cycles

By removing all GitHub Actions publishing pipelines, all publication will be manual, giving developers full control over when and how packages are published to pub.dev.

## What Changes

- **Remove root-level CI workflow**: Delete `.github/workflows/pub-check.yml` (PR validation workflow)
- **Remove package-level publish workflows**: Delete all `.github/workflows/publish.yml` files from individual packages
- **Update specifications**: Modify package-publication and monorepo-structure specs to reflect manual-only publishing
- **Update documentation**: Remove references to CI automation from workspace/AGENTS.md
</details>

### Task Details

# Task: Verify All Changes Are Complete

## End Goal
Ensure all GitHub Actions workflows are removed and documentation is updated correctly.

## Currently
After deleting workflows and updating docs, need to verify everything is complete and consistent.

## Should
- All workflow files are deleted
- Documentation is updated
- Specs reflect manual-only publishing
- No broken references remain

## Constraints
- [ ] Must verify no workflow files remain
- [ ] Must verify documentation is consistent
- [ ] Must verify specs match implementation
- [ ] Must ensure manual publishing commands still work

## Acceptance Criteria
- [ ] No GitHub Actions workflow files exist for publishing
- [ ] Documentation accurately reflects manual-only publishing
- [ ] Specs are updated to remove CI automation requirements
- [ ] Manual publishing workflow (`melos pub-publish`) is functional
- [ ] No broken references or dead links in documentation

## Implementation Checklist
- [ ] 3.1 Verify all workflow files are deleted (search for .github/workflows/*.yml)
- [ ] 3.2 Review workspace/AGENTS.md for accuracy
- [ ] 3.3 Verify specs match the new manual-only approach
- [ ] 3.4 Test `melos pub-check` locally to ensure it still works
- [ ] 3.5 Test `melos pub-publish --dry-run` to ensure it still works
- [ ] 3.6 Check for any remaining references to CI automation

## Notes
This is a verification task to ensure the change is complete and consistent across all files.

### Agent Instructions

Pick up this task and implement it according to the specifications above.
Focus on the Constraints and Acceptance Criteria sections.
When complete, mark the task as done:

```bash
splx complete task --id 003-remove-github-actions-pipelines-verify-changes
```

---

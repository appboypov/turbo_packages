# Change: Remove GitHub Actions Publishing Pipelines

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

## Impact

- **Affected capabilities**:
  - monorepo-structure (remove CI workflow requirements)
  - package-publication (remove automated publishing requirements)

- **Affected code**:
  - `.github/workflows/pub-check.yml` (to be deleted)
  - `turbo_mvvm/.github/workflows/publish.yml` (to be deleted)
  - `turbo_notifiers/.github/workflows/publish.yml` (to be deleted)
  - `turbolytics/.github/workflows/publish.yml` (to be deleted)
  - `workspace/AGENTS.md` (update publishing documentation)
  - `workspace/specs/package-publication/spec.md` (remove CI automation requirements)
  - `workspace/specs/monorepo-structure/spec.md` (remove CI workflow requirements)

- **Breaking changes**: None—this removes automation but doesn't change package functionality
- **Migration**: Developers must use `melos pub-publish` manually for all publishing

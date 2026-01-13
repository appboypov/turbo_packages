---
status: to-do
skill-level: junior
parent-type: change
parent-id: remove-github-actions-pipelines
---

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

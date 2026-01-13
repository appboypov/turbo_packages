---
status: done
skill-level: junior
parent-type: change
parent-id: remove-github-actions-pipelines
---

# Task: Delete GitHub Actions Workflow Files

## End Goal
Remove all GitHub Actions workflow files that automate publishing or validation, ensuring all publishing is manual.

## Currently
- Package-level `.github/workflows/publish.yml` files in turbo_mvvm, turbo_notifiers, and turbolytics automatically publish when version changes
- These workflows create tags, releases, and publish to pub.dev automatically

## Should
- All GitHub Actions workflow files related to publishing and validation are deleted
- No automated publishing or CI validation occurs
- Developers must manually run `melos pub-publish` to publish packages
- Developers must manually run `melos pub-check` locally before publishing

## Constraints
- [ ] Must delete root-level pub-check.yml workflow
- [ ] Must delete all package-level publish.yml workflows
- [ ] Must not break any existing manual publishing commands (melos pub-publish)
- [ ] Must not break any existing manual validation commands (melos pub-check)

## Acceptance Criteria
- [ ] `.github/workflows/pub-check.yml` is deleted
- [ ] `turbo_mvvm/.github/workflows/publish.yml` is deleted
- [ ] `turbo_notifiers/.github/workflows/publish.yml` is deleted
- [ ] `turbolytics/.github/workflows/publish.yml` is deleted
- [ ] No other publish-related workflows remain
- [ ] Manual publishing via `melos pub-publish` still works
- [ ] Manual validation via `melos pub-check` still works

## Implementation Checklist
- [x] 1.1 Delete `.github/workflows/pub-check.yml`
- [x] 1.2 Delete `turbo_mvvm/.github/workflows/publish.yml`
- [x] 1.3 Delete `turbo_notifiers/.github/workflows/publish.yml`
- [x] 1.4 Delete `turbolytics/.github/workflows/publish.yml`
- [x] 1.5 Verify no other publish-related workflows exist
- [x] 1.6 Test that `melos pub-publish-dry-run` still works locally

## Notes
After deletion, all publishing must be done manually using `melos pub-publish`. Developers should run `melos pub-check` locally before publishing to ensure packages meet 160/160 pub points.

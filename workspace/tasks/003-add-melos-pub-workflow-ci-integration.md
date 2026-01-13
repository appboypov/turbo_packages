---
status: done
status: completed
skill-level: junior
parent-type: change
parent-id: add-melos-pub-workflow
---

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

- [x] 3.1 Create .github/workflows/pub-check.yml
- [x] 3.2 Configure trigger: pull_request to main branch
- [x] 3.3 Add job to set up Dart environment
- [x] 3.4 Cache pub dependencies (.pub-cache)
- [x] 3.5 Run `melos bootstrap` to fetch dependencies
- [x] 3.6 Run `melos pub-check`
- [x] 3.7 Configure workflow to fail on pub-check failure
- [x] 3.8 Add step to report results (optional: post comment on PR)
- [x] 3.9 Test workflow on a test PR
- [x] 3.10 Verify workflow passes on main branch

## Notes

- Use setup-dart@v1 action for Dart environment
- Cache key should include pubspec.lock for dependency stability
- Consider using actions/cache@v3 or setup-dart's built-in caching
- The workflow should run sequentially (already handled by melos pub-check)
- Error reporting: use job output or workflow annotation format
- Optional: Post a summary comment on the PR showing which packages passed/failed

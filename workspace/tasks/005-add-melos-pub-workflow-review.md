---
status: to-do
skill-level: junior
parent-type: change
parent-id: add-melos-pub-workflow
---

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

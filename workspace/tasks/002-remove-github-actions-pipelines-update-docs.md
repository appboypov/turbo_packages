---
status: to-do
skill-level: junior
parent-type: change
parent-id: remove-github-actions-pipelines
---

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

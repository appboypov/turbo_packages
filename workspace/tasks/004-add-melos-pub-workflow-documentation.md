---
status: to-do
skill-level: junior
parent-type: change
parent-id: add-melos-pub-workflow
---

# Task: Document Publishing Guidelines and Workflow

## End Goal

Add comprehensive publishing guidelines to workspace documentation so developers understand the pub.dev publication process, 160/160 pub points criteria, and how to use the new Melos workflow.

## Currently

No documentation on publishing to pub.dev. Developers are unaware of pub points, CHANGELOG format, or how to prepare packages for publication.

## Should

1. Add "Publishing Packages to pub.dev" section to workspace/AGENTS.md
2. Explain the 160/160 pub points breakdown and categories
3. Document pre-publish checklist
4. Provide examples of compliant CHANGELOG.md format
5. Link to pub.dev documentation and best practices
6. Explain how to use `melos pub-check` and `melos pub-publish`
7. List common issues and how to fix them
8. Document semantic versioning conventions

## Constraints

- [ ] Must be discoverable and linked from README.md
- [ ] Must explain pub points in simple, actionable terms
- [ ] Must include real examples from turbo_packages packages (after they pass)
- [ ] Must reference workspace/ARCHITECTURE.md conventions

## Acceptance Criteria

- [ ] Section added to workspace/AGENTS.md
- [ ] 160/160 pub points breakdown documented
- [ ] Pre-publish checklist provided
- [ ] CHANGELOG.md format documented with examples
- [ ] Semantic versioning guidelines included
- [ ] Melos workflow commands documented
- [ ] Common issues and solutions listed
- [ ] README.md updated with link to publishing guide

## Implementation Checklist

- [ ] 4.1 Review existing workspace/AGENTS.md structure
- [ ] 4.2 Add "Publishing Packages to pub.dev" section
- [ ] 4.3 Document the 160/160 pub points categories with explanations
- [ ] 4.4 Create pre-publish checklist
- [ ] 4.5 Document CHANGELOG.md format with Keep a Changelog example
- [ ] 4.6 Explain semantic versioning (MAJOR.MINOR.PATCH)
- [ ] 4.7 Document `melos pub-check` command and output
- [ ] 4.8 Document `melos pub-publish --dry-run` command
- [ ] 4.9 Document `melos pub-publish` command and safety confirmations
- [ ] 4.10 List 10 common issues and how to fix them
- [ ] 4.11 Add links to pub.dev documentation
- [ ] 4.12 Update README.md with link to publishing guide

## Notes

- Keep examples concise and specific to turbo_packages
- Reference existing packages' CHANGELOGs as examples after they pass validation
- Explain why each pub point category matters (e.g., documentation helps users)
- Consider adding a section on version constraints and workspace resolution
- Include a "When to publish" decision tree (major vs minor vs patch)
- Mention that publishing is permanent (versions can't be deleted, only retracted)

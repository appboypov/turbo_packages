---
status: done
skill-level: junior
parent-type: change
parent-id: add-melos-monorepo-management
---

# Task: Document Melos usage in project docs

## End Goal
Add documentation explaining how to use Melos in the monorepo, including setup instructions, common commands, and workflow guidance.

## Currently
There is no documentation about Melos usage. New developers or contributors won't know how to set up or use Melos for monorepo management.

## Should
Documentation exists that explains:
- What Melos is and why it's used
- How to install Melos
- How to bootstrap the workspace
- Common Melos commands and scripts
- Development workflow using Melos
- Troubleshooting common issues

## Constraints
- Documentation should be clear and accessible
- Should include examples where helpful
- Should cover both setup and daily usage
- Should be placed in an appropriate location (README.md, docs/, or ARCHITECTURE.md)

## Acceptance Criteria
- [ ] Documentation explains what Melos is and its purpose
- [ ] Installation instructions are provided
- [ ] Bootstrap process is documented
- [ ] Common commands are listed with descriptions
- [ ] Development workflow is explained
- [ ] Troubleshooting section included (if needed)
- [ ] Documentation is easy to find and read

## Implementation Checklist
- [x] 6.1 Decide on documentation location (README.md, ARCHITECTURE.md, or new docs file)
- [x] 6.2 Add section explaining Melos and its purpose
- [x] 6.3 Add installation instructions (`dart pub global activate melos`)
- [x] 6.4 Document bootstrap process (`melos bootstrap`)
- [x] 6.5 List common Melos commands:
  - `melos bootstrap`
  - `melos run test`
  - `melos run analyze`
  - `melos run format`
  - `melos run clean`
- [x] 6.6 Explain development workflow (making changes, testing locally)
- [x] 6.7 Add troubleshooting section for common issues
- [x] 6.8 Review documentation for clarity and completeness

## Notes
- Consider adding a "Getting Started" section
- Include information about workspace resolution
- Explain how local linking works
- Document any Melos-specific conventions or patterns used

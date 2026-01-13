## REMOVED Requirements

### Requirement: Automated Publishing via GitHub Actions
**Reason**: All publishing is now manual. Automated publishing workflows are removed to give developers full control over publication timing and prevent accidental publications.
**Migration**: Developers must run `melos pub-publish` manually when ready to publish. Validation workflows (pub-check.yml, ci.yml, pr.yml) remain for quality checks but do not publish.

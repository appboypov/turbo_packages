---
status: done
parent-type: change
parent-id: add-github-secrets-to-all-repositories-using-playw
---

# Task: Add PUB_CREDENTIALS secret to turbo_mvvm repository

## End Goal
Add the PUB_CREDENTIALS secret to the turbo_mvvm GitHub repository using Playwright MCP browser tools.

## Currently
The turbo_mvvm repository does not have the PUB_CREDENTIALS secret configured, preventing auto-publishing to pub.dev.

## Should
The PUB_CREDENTIALS secret is added to https://github.com/appboypov/turbo_mvvm repository settings, enabling the publish workflow to function.

## Constraints
- Use Playwright MCP browser tools (already authenticated)
- Repository: appboypov/turbo_mvvm
- Secret name: PUB_CREDENTIALS
- Secret value obtained from task 001 or user input

## Acceptance Criteria
- [ ] PUB_CREDENTIALS secret added to turbo_mvvm repository
- [ ] Secret is visible in repository Settings → Secrets and variables → Actions
- [ ] Publish workflow can access the secret (verified by workflow run)

## Implementation Checklist
- [x] 4.1 Navigate to https://github.com/appboypov/turbo_mvvm/settings/secrets/actions
- [x] 4.2 Take snapshot to inspect page
- [x] 4.3 Click "New repository secret" button
- [x] 4.4 Type "PUB_CREDENTIALS" in name field
- [x] 4.5 Type secret value in value field
- [x] 4.6 Click "Add secret" to submit
- [x] 4.7 Verify secret appears in the secrets list
- [x] 4.8 Verify workflow can access secret (check workflow logs or trigger test)

## Notes
- Repository URL: https://github.com/appboypov/turbo_mvvm
- This is one of 9 repositories that need the secret added

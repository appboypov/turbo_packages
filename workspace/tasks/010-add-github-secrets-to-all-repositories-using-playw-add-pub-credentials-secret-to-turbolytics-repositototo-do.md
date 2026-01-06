---
status: done
parent-type: change
parent-id: add-github-secrets-to-all-repositories-using-playw
---

# Task: Add PUB_CREDENTIALS secret to turbolytics repository

## End Goal
Add the PUB_CREDENTIALS secret to the turbolytics GitHub repository using Playwright MCP browser tools.

## Currently
The turbolytics repository does not have the PUB_CREDENTIALS secret configured, preventing auto-publishing to pub.dev.

## Should
The PUB_CREDENTIALS secret is added to https://github.com/appboypov/turbolytics repository settings, enabling the publish workflow to function.

## Constraints
- Use Playwright MCP browser tools (already authenticated)
- Repository: appboypov/turbolytics
- Secret name: PUB_CREDENTIALS
- Secret value obtained from task 001 or user input

## Acceptance Criteria
- [ ] PUB_CREDENTIALS secret added to turbolytics repository
- [ ] Secret is visible in repository Settings → Secrets and variables → Actions
- [ ] Publish workflow can access the secret (verified by workflow run)

## Implementation Checklist
- [x] 10.1 Navigate to https://github.com/appboypov/turbolytics/settings/secrets/actions
- [x] 10.2 Take snapshot to inspect page
- [x] 10.3 Click "New repository secret" button
- [x] 10.4 Type "PUB_CREDENTIALS" in name field
- [x] 10.5 Type secret value in value field
- [x] 10.6 Click "Add secret" to submit
- [x] 10.7 Verify secret appears in the secrets list
- [x] 10.8 Verify workflow can access secret (check workflow logs or trigger test)

## Notes
- Repository URL: https://github.com/appboypov/turbolytics
- This is one of 9 repositories that need the secret added


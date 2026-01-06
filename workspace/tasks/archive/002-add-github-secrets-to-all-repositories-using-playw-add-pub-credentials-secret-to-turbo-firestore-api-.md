---
status: done
parent-type: change
parent-id: add-github-secrets-to-all-repositories-using-playw
---

# Task: Add PUB_CREDENTIALS secret to turbo_firestore_api repository

## End Goal
Add the PUB_CREDENTIALS secret to the turbo_firestore_api GitHub repository using the Playwright script.

## Currently
The turbo_firestore_api repository does not have the PUB_CREDENTIALS secret configured, preventing auto-publishing to pub.dev.

## Should
The PUB_CREDENTIALS secret is added to https://github.com/appboypov/turbo_firestore_api repository settings, enabling the publish workflow to function.

## Constraints
- Use Playwright MCP browser tools (already authenticated)
- Repository: appboypov/turbo_firestore_api
- Secret name: PUB_CREDENTIALS
- Secret value obtained from task 001 or user input

## Acceptance Criteria
- [ ] PUB_CREDENTIALS secret added to turbo_firestore_api repository
- [ ] Secret is visible in repository Settings → Secrets and variables → Actions
- [ ] Publish workflow can access the secret (verified by workflow run)

## Implementation Checklist
- [x] 2.1 Navigate to https://github.com/appboypov/turbo_firestore_api/settings/secrets/actions
- [x] 2.2 Take snapshot to inspect page
- [x] 2.3 Click "New repository secret" button
- [x] 2.4 Type "PUB_CREDENTIALS" in name field
- [x] 2.5 Type secret value in value field
- [x] 2.6 Click "Add secret" to submit
- [x] 2.7 Verify secret appears in the secrets list
- [x] 2.8 Verify workflow can access secret (check workflow logs or trigger test)

## Notes
- Repository URL: https://github.com/appboypov/turbo_firestore_api
- This is one of 9 repositories that need the secret added

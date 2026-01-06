---
status: done
parent-type: change
parent-id: add-github-secrets-to-all-repositories-using-playw
---

# Task: Use Playwright MCP to add PUB_CREDENTIALS secret to GitHub repositories

## End Goal
Use Playwright MCP browser tools to automate adding the PUB_CREDENTIALS secret to all GitHub repositories for the Flutter packages. The MCP browser is already authenticated and has access to all accounts.

## Currently
GitHub secrets must be added manually through the GitHub web UI for each repository, which is time-consuming and error-prone. The Playwright MCP browser tools are available and already logged into GitHub.

## Should
PUB_CREDENTIALS secret is added to all 9 repositories using Playwright MCP browser automation tools.

## Constraints
- Use Playwright MCP browser tools (browser_navigate, browser_snapshot, browser_click, browser_type, etc.)
- Browser is already authenticated - no login needed
- Must navigate to Settings → Secrets and variables → Actions → New repository secret
- Must handle cases where secret already exists (skip or update)
- Must obtain PUB_CREDENTIALS value from user or secure source
- Must work with GitHub's UI structure

## Acceptance Criteria
- [ ] Navigate to each repository's secrets page using browser_navigate
- [ ] Use browser_snapshot to inspect page structure
- [ ] Click "New repository secret" button using browser_click
- [ ] Fill in secret name (PUB_CREDENTIALS) using browser_type
- [ ] Fill in secret value using browser_type
- [ ] Submit the form to add the secret
- [ ] Handle errors gracefully (secret exists, navigation issues, etc.)
- [ ] Verify secret was added successfully for each repository
- [ ] Complete for all 9 packages: turbo_firestore_api, turbo_forms, turbo_mvvm, turbo_notifiers, turbo_response, turbo_responsiveness, turbo_routing, turbo_widgets, turbolytics

## Implementation Checklist
- [x] 1.1 Get PUB_CREDENTIALS value (from user input or secure storage)
- [x] 1.2 Navigate to first repository secrets page: https://github.com/appboypov/{repo}/settings/secrets/actions
- [x] 1.3 Take snapshot to inspect page structure
- [x] 1.4 Click "New repository secret" button
- [x] 1.5 Type secret name: PUB_CREDENTIALS
- [x] 1.6 Type secret value
- [x] 1.7 Submit form (click "Add secret" button)
- [x] 1.8 Verify success (check for confirmation message or secret in list)
- [x] 1.9 Repeat for remaining 8 repositories
- [x] 1.10 Document the process and any issues encountered

## Notes
- Repository URLs: `https://github.com/appboypov/{package-name}/settings/secrets/actions`
- Secret name: `PUB_CREDENTIALS`
- Browser is already authenticated via MCP - no login needed
- Use browser_snapshot frequently to understand page structure
- May need to handle GitHub's dynamic UI elements

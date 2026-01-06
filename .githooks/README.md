# Git Hooks

This directory contains git hooks for the monorepo repository.

## Setup

Git hooks are automatically configured when you initialize the repository. The hooks are located in `.githooks/` and git is configured to use them via:

```bash
git config core.hooksPath .githooks
```

## Available Hooks

### commit-msg
Validates that commit messages follow the [Conventional Commits](https://www.conventionalcommits.org/) format.

**Format**: `<type>(<scope>): <subject>`

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`, `revert`

**Examples**:
- `feat(turbo_firestore_api): add batch update support`
- `fix(turbo_forms): resolve validation error`
- `docs: update README with examples`

### pre-commit
Runs before each commit to ensure code quality:
- Checks code formatting (`melos run format:check`)
- Runs code analysis (`melos run analyze`)

If checks fail, the commit is blocked.

### pre-push
Runs before pushing to remote:
- Runs all tests (`melos run test`)

If tests fail, the push is blocked.

## Manual Setup

If hooks aren't working, manually configure them:

```bash
git config core.hooksPath .githooks
```

## Bypassing Hooks

To bypass hooks (not recommended):

```bash
# Skip pre-commit hook
git commit --no-verify

# Skip pre-push hook
git push --no-verify
```

## Troubleshooting

**Hooks not running:**
- Ensure `.githooks/` directory exists
- Check git config: `git config core.hooksPath`
- Verify hooks are executable: `ls -la .githooks/`

**Melos not found:**
- Install melos: `dart pub global activate melos`
- Ensure melos is in your PATH


# Change: Add Monorepo Run Configurations

## Why
The turbo_template package has IntelliJ and Cursor run configurations that enable developers to run common operations directly from the IDE. The root monorepo currently lacks these configurations, making it necessary to run commands manually from the terminal. Adding run configurations at the monorepo root will improve developer experience by allowing quick access to common Melos operations (analyze, format, test, build, etc.) and running the turbo_template app from the root.

## What Changes
- Add IntelliJ run configurations (`.run/*.run.xml`) for common Melos operations at monorepo root
- Add Cursor/VS Code launch configurations (`.vscode/launch.json`) for common Melos operations at monorepo root
- Add IntelliJ run configurations for running turbo_template app from root
- Add Cursor/VS Code launch configurations for running turbo_template app from root
- Ensure configurations follow the same patterns as turbo_template for consistency

## Impact
- Affected specs: `monorepo-structure`
- Affected code: Root `.run/` directory, root `.vscode/launch.json`
- Developer experience: Improved IDE integration for monorepo operations

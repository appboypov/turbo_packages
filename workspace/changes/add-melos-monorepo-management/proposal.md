# Change: Add Melos monorepo management

## Why
Currently, the Flutter turbo packages monorepo lacks a unified tool for managing multiple interdependent packages. Each package is managed independently, making it difficult to:
- Link local packages during development without publishing to pub.dev
- Run commands (test, analyze, format) across all packages efficiently
- Manage dependencies and versions across the monorepo
- Ensure consistent development workflows

Melos provides a standardized solution for Dart/Flutter monorepos that will streamline development, testing, and publishing workflows.

## What Changes
- Add root `pubspec.yaml` with workspace configuration and Melos as dev dependency
- Add `resolution: workspace` to each package's `pubspec.yaml` and the template to enable local linking
- Add all turbo packages as dependencies to `turbo_templates/turbo_flutter_template/pubspec.yaml`
- Create `melos.yaml` configuration file with scripts for common operations
- Update `.gitignore` to exclude Melos-generated files
- Document Melos usage in project documentation

## Impact
- Affected specs: New capability - "Monorepo Management"
- Affected code: 
  - Root `pubspec.yaml` (new file)
  - All package `pubspec.yaml` files (add `resolution: workspace`)
  - `turbo_templates/turbo_flutter_template/pubspec.yaml` (add `resolution: workspace` and all turbo package dependencies)
  - `.gitignore` (add Melos exclusions)
  - `melos.yaml` (new file)
  - Documentation files

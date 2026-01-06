# Release Preparation

## Purpose
This file configures release preparation and pre-release consistency verification.
Run `/plx:refine-release` to populate project-specific checklists.
Run `/plx:prepare-release` to execute release preparation.

## Documentation Config
```yaml
changelog_format: keep-a-changelog
readme_style: standard
audience: technical
emoji_level: none
```

## Consistency Checklist

### Primary Sources
<!-- Files that must change first when modifying core behavior -->

### Derived Artifacts
<!-- Files generated from primary sources; include regeneration command -->
Regeneration command: ``

### Shared Values
<!-- Values duplicated across files: versions, names, identifiers, URLs -->

### Behavioral Contracts
<!-- Schemas, types, interfaces, API contracts that define expected behavior -->

### Assertion Updates
<!-- Tests that assert on specific outputs, messages, or formats -->

### Documentation References
<!-- Docs containing code examples or implementation references -->

### External Integrations
<!-- IDE configs, CI/CD, linter rules, third-party service configs -->

### Platform Variations
<!-- Target-specific files that must stay synchronized -->

### Cleanup
<!-- Files to delete when renaming/removing features -->

### Verification
<!-- Commands to confirm zero drift -->
```bash
# Search for old patterns
grep -rn "OLD_PATTERN" .

# Run tests
# <test-command>

# Validate project
# <validate-command>
```

## 160 Pub Points Requirement

All packages must achieve the maximum pub.dev score of 160/160 points before release. This is enforced in both CI and publish workflows.

### Validation

The validation script (`.github/scripts/check_pub_points.sh`) checks the following criteria:

#### Follow Dart file conventions (30 points)
- **Valid pubspec.yaml (10 points)**: Validated via `flutter pub publish --dry-run`
- **Valid README.md (5 points)**: File must exist and have content
- **Valid CHANGELOG.md (5 points)**: File must exist and have content
- **OSI-approved license (10 points)**: LICENSE file must exist and contain an OSI-approved license (MIT, Apache, BSD, MPL, GPL, ISC)

#### Provide documentation (20 points)
- **20%+ dartdoc comments (10 points)**: At least 20% of public API elements must have dartdoc comments
- **Package has example (10 points)**: `example/` directory must exist with valid `pubspec.yaml` and Dart files in `example/lib/`

#### Platform support (20 points)
- **Supports 5 of 6 platforms (20 points)**: Package must support at least 5 of: iOS, Android, Web, Windows, macOS, Linux (verified via platform directories or example platform support)

#### Pass static analysis (50 points)
- **No errors, warnings, lints, or formatting issues (50 points)**: Validated via `flutter pub publish --dry-run` (must have 0 warnings)

### Local Validation

Before pushing changes, validate locally:

```bash
# From package directory
bash .github/scripts/check_pub_points.sh

# Or from monorepo root for a specific package
cd turbo_firestore_api
bash ../.github/scripts/check_pub_points.sh
```

### Common Issues and Fixes

1. **Missing README.md or CHANGELOG.md**: Create these files with appropriate content
2. **Missing LICENSE**: Add an OSI-approved license file (MIT recommended)
3. **Missing example**: Create `example/` directory with `pubspec.yaml` and `lib/` with Dart files
4. **Low dartdoc coverage**: Add dartdoc comments (`///`) to public APIs (classes, methods, properties)
5. **Platform support**: Ensure platform directories exist or example supports multiple platforms
6. **Warnings in dry-run**: Fix all analyzer warnings, lints, and formatting issues

### CI/CD Integration

- **Individual Package CI**: Validates 160 points on every push to main
- **Individual Package Publish**: Blocks release if validation fails
- **Monorepo CI**: Validates all changed packages on push/PR
- **Monorepo Release**: Validates all packages before release (can be skipped with `skip_validation` input, not recommended)

## Publishing Packages

### Publishing Strategy

This monorepo supports **both individual and coordinated publishing**:

1. **Individual Publishing**: Each package can be published independently from its own repository
2. **Coordinated Publishing**: Use `melos publish` from the monorepo for batch releases

### Using Melos Publish

Melos provides publishing capabilities for coordinated releases:

#### Dry-Run (Default)

By default, `melos publish` runs in dry-run mode (`autoPublish: false`):

```bash
melos publish
```

This will:
- Show what packages would be published
- Display current versions from pubspec.yaml
- **Not actually publish** to pub.dev
- **Not create git tags**

#### Actual Publishing

To actually publish packages:

```bash
melos publish --no-dry-run
```

This will:
- Publish packages to pub.dev using versions from pubspec.yaml
- Create git tags for each package version
- Push changes to git

**Note**: Melos will not automatically update versions or changelogs. These must be manually updated before publishing.

### Version Management

**Manual Versioning**: Versions must be manually updated in each package's `pubspec.yaml` file.

1. Edit the `version:` field in `pubspec.yaml`:
   ```yaml
   version: 1.2.0
   ```

2. Follow semantic versioning:
   - **Major** (2.0.0): Breaking changes
   - **Minor** (1.1.0): New features, backwards compatible
   - **Patch** (1.0.1): Bug fixes, backwards compatible

**Conventional Commits**: While conventional commit format (`feat:`, `fix:`, etc.) is recommended for consistency and clarity, it does **not** trigger automatic versioning. You maintain full control over version bumps.

### Publishing Workflow

1. **Make changes** and commit using conventional commit format (for consistency)
2. **Manually update version** in `pubspec.yaml`:
   ```yaml
   version: 1.2.0
   ```
3. **Manually update CHANGELOG.md** with new version entry
4. **Update README.md and ARCHITECTURE.md** if needed
5. **Run validation**:
   ```bash
   melos run format:check
   melos run analyze
   melos run test
   ```
6. **Check 160 pub points**:
   ```bash
   cd <package_directory>
   bash ../.github/scripts/check_pub_points.sh
   ```
7. **Preview release** (dry-run):
   ```bash
   melos publish
   ```
8. **Review** the output, verify versions and changelogs are correct
9. **Publish** when ready:
   ```bash
   melos publish --no-dry-run
   ```

### Git Tags

Melos creates git tags in the format: `package-name@version`

Example: `turbo_firestore_api@1.0.0`

Tags are created in the monorepo repository and can be used for:
- GitHub Releases
- CI/CD workflows
- Version tracking

### Changelog Generation

**Manual Changelog Updates**: `CHANGELOG.md` files must be manually updated before each release.

1. Follow the `keep-a-changelog` format (configured in Documentation Config section)
2. Add entries under appropriate sections:
   - `## [Unreleased]` for upcoming changes
   - `## [Version]` for released versions
3. Include relevant changes:
   - Added: New features
   - Changed: Changes in existing functionality
   - Deprecated: Soon-to-be removed features
   - Removed: Removed features
   - Fixed: Bug fixes
   - Security: Security vulnerabilities

**Example**:
```markdown
## [Unreleased]

### Added
- New feature description

### Fixed
- Bug fix description

## [1.2.0] - 2024-01-15

### Added
- Feature added in this version
```

### README and Architecture Updates

**Manual Documentation Updates**: README.md and ARCHITECTURE.md files should be manually updated as needed:

- **README.md**: Update when adding features, changing usage, or updating examples
- **ARCHITECTURE.md**: Update when making architectural changes, adding new patterns, or modifying existing designs

These updates should be done as part of the development process, not automatically generated.

## Release Checklist
- [ ] Consistency checklist reviewed and complete
- [ ] Changelog manually updated with new version entry
- [ ] Version manually bumped in `pubspec.yaml`
- [ ] README.md updated if needed (new features, usage changes)
- [ ] ARCHITECTURE.md updated if needed (architectural changes)
- [ ] 160 pub points validation passed locally
- [ ] All changes reviewed and confirmed
- [ ] Conventional commit messages used (for consistency, not automatic versioning)
- [ ] Dry-run publish successful (`melos publish`)
- [ ] Ready to publish (`melos publish --no-dry-run`)

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

Melos provides automated versioning and publishing capabilities:

#### Dry-Run (Default)

By default, `melos publish` runs in dry-run mode (`autoPublish: false`):

```bash
melos publish
```

This will:
- Show what packages would be published
- Display version changes
- Show changelog updates
- **Not actually publish** to pub.dev
- **Not create git tags**

#### Actual Publishing

To actually publish packages:

```bash
melos publish --no-dry-run
```

This will:
- Publish packages to pub.dev
- Create git tags for each package version
- Push changes to git
- Update CHANGELOG.md files

### Version Management

Melos uses **conventional commits** for automatic versioning:

- `feat:` → Minor version bump (1.0.0 → 1.1.0)
- `fix:` → Patch version bump (1.0.0 → 1.0.1)
- `BREAKING CHANGE:` → Major version bump (1.0.0 → 2.0.0)

### Publishing Workflow

1. **Make changes** and commit using conventional commit format
2. **Run validation**:
   ```bash
   melos run format:check
   melos run analyze
   melos run test
   ```
3. **Check 160 pub points**:
   ```bash
   cd <package_directory>
   bash ../.github/scripts/check_pub_points.sh
   ```
4. **Preview release** (dry-run):
   ```bash
   melos publish
   ```
5. **Review** the output, check versions and changelogs
6. **Publish** when ready:
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

Melos automatically generates `CHANGELOG.md` files for each package based on conventional commits. The format matches the `keep-a-changelog` standard configured in this file.

## Release Checklist
- [ ] Consistency checklist reviewed and complete
- [ ] Changelog updated with new version (or auto-generated via melos)
- [ ] Version bumped in project config (or auto-bumped via melos)
- [ ] 160 pub points validation passed locally
- [ ] All changes reviewed and confirmed
- [ ] Conventional commit messages used
- [ ] Dry-run publish successful (`melos publish`)
- [ ] Ready to publish (`melos publish --no-dry-run`)

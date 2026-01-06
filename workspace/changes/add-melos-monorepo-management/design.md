# Design: Melos Monorepo Management

## Architecture Decision

### Choice: Melos vs Alternatives

**Selected: Melos**
- Native Dart/Flutter support
- Workspace resolution for local package linking
- Script execution across packages
- Version management and publishing support
- Active maintenance and Flutter community adoption

**Alternatives Considered:**
- **Lerna**: JavaScript-focused, not ideal for Dart/Flutter
- **Nx**: Overkill for current needs, adds complexity
- **Manual scripts**: Not scalable, harder to maintain

### Workspace Structure

```
flutter-turbo-packages/
├── pubspec.yaml          # Root workspace config (NEW)
├── melos.yaml            # Melos scripts config (NEW)
├── .gitignore            # Updated with Melos exclusions
├── turbo_firestore_api/  # Package (add resolution: workspace)
├── turbo_forms/          # Package (add resolution: workspace)
├── turbo_mvvm/           # Package (add resolution: workspace)
├── turbo_notifiers/       # Package (add resolution: workspace)
├── turbo_response/        # Package (add resolution: workspace)
├── turbo_responsiveness/ # Package (add resolution: workspace)
├── turbo_routing/         # Package (add resolution: workspace)
├── turbo_widgets/         # Package (add resolution: workspace)
├── turbolytics/           # Package (add resolution: workspace)
└── turbo_templates/
    └── turbo_flutter_template/  # Template (add resolution: workspace + all turbo packages)
```

### Git Strategy

**Decision: Keep separate repositories**
- Each package maintains its own `.git` repository
- Root folder can optionally have git for workspace config only
- This preserves independent versioning and CI/CD per package
- Melos works with this structure via workspace resolution

### Dependency Resolution

**Local Development:**
- `melos bootstrap` creates symlinks for local packages
- Packages resolve dependencies from local workspace first
- No need to publish packages to pub.dev during development

**Publishing:**
- Packages still publish independently to pub.dev
- Version constraints in `pubspec.yaml` remain unchanged
- CI/CD workflows remain per-package

### Scripts Strategy

**Common Operations:**
- `melos run test` - Run tests across all packages
- `melos run analyze` - Analyze all packages
- `melos run format` - Format all packages
- `melos run clean` - Clean build artifacts
- `melos bootstrap` - Link local packages

**Publishing:**
- `melos publish` - Publish packages in dependency order
- Respects existing CI/CD workflows
- Can be used for batch operations

### Trade-offs

**Pros:**
- Faster local development (no publishing needed)
- Consistent workflows across packages
- Easier dependency management
- Better developer experience

**Cons:**
- Additional tool to learn
- Requires `melos bootstrap` after cloning
- Slight overhead in setup

**Mitigation:**
- Document setup process clearly
- Add bootstrap to onboarding docs
- Keep scripts simple and well-documented


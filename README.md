# Flutter Turbo Packages Monorepo

A monorepo containing Flutter packages for building scalable Flutter applications.

## Packages

- **turbo_firestore_api** - A clean and efficient approach to dealing with data from Firestore
- **turbo_forms** - Form configuration and validation system
- **turbo_mvvm** - Lightweight MVVM state management solution
- **turbo_notifiers** - Improved behavior of Flutter's ValueNotifier
- **turbo_response** - Type-safe response wrapper for handling success and failure states
- **turbo_responsiveness** - Responsive design utilities and widgets
- **turbo_routing** - Routing abstraction layer over go_router
- **turbo_widgets** - Common reusable UI widgets, extensions, and animation utilities
- **turbolytics** - Efficient logging, analytics and crash reporting

## Template

- **turbo_flutter_template** - Flutter project template using all turbo packages

## Monorepo Management with Melos

This monorepo uses [Melos](https://melos.invertase.dev/) for managing multiple interdependent packages. Melos enables local package linking during development without requiring publication to pub.dev.

### Installation

Install Melos globally:

```bash
dart pub global activate melos
```

### Bootstrap

After cloning the repository, bootstrap the workspace to link local packages:

```bash
melos bootstrap
```

This command:
- Links all packages in the workspace
- Resolves dependencies from local packages first
- Sets up the development environment

**Note:** Run `melos bootstrap` whenever you pull changes or when dependencies change.

### Common Commands

Run commands across all packages using Melos scripts:

#### Test
Run tests in all packages:
```bash
melos run test
```

#### Analyze
Analyze all packages:
```bash
melos run analyze
```

#### Format
Format all packages:
```bash
melos run format
```

#### Format Check
Check formatting without modifying files:
```bash
melos run format:check
```

#### Clean
Clean build artifacts:
```bash
melos run clean
```

#### Get Dependencies
Get dependencies for all packages:
```bash
melos run get
```

### Development Workflow

1. **Initial Setup:**
   ```bash
   dart pub global activate melos
   melos bootstrap
   ```

2. **Making Changes:**
   - Make changes to any package
   - Changes are immediately available to dependent packages (no publishing needed)
   - Test locally using `melos run test`

3. **Before Committing:**
   - Run `melos run format:check` to ensure formatting is correct
   - Run `melos run analyze` to check for issues
   - Run `melos run test` to ensure all tests pass

4. **Publishing:**
   - Packages are published independently to pub.dev
   - Each package maintains its own version and CI/CD workflow
   - Use `melos publish` for batch publishing (optional)

### Workspace Resolution

Packages use `resolution: workspace` in their `pubspec.yaml` files, which tells Dart to resolve dependencies from the workspace first. This enables:

- Local development without publishing
- Immediate availability of changes across packages
- Faster iteration cycles

When packages are published to pub.dev, the `resolution: workspace` field is ignored, and version constraints are used instead.

### Troubleshooting

#### Bootstrap Fails
- Ensure Melos is installed: `melos --version`
- Check that all packages have `resolution: workspace` in their `pubspec.yaml`
- Verify the root `pubspec.yaml` includes all packages in the `workspace` section

#### Dependencies Not Resolving Locally
- Run `melos bootstrap` again
- Check that the package is listed in the root `pubspec.yaml` workspace section
- Verify `resolution: workspace` is present in the package's `pubspec.yaml`

#### Scripts Not Working
- Ensure you're running commands from the root directory
- Check that `melos.yaml` exists and contains the script definitions
- Verify Melos is installed: `melos --version`

## Git Repository Structure

This monorepo uses a **hybrid git strategy**:

- **Monorepo Repository**: The root directory (`appboypov/turbo_packages`) contains workspace configuration, CI/CD workflows, and scripts
- **Individual Package Repositories**: Each package maintains its own git repository for independent versioning and publishing

### Repository Setup

#### Initial Setup

1. **Clone the monorepo:**
   ```bash
   git clone https://github.com/appboypov/turbo_packages.git
   cd turbo_packages
   ```

2. **Bootstrap the workspace:**
   ```bash
   dart pub global activate melos
   melos bootstrap
   ```

3. **Configure git hooks** (if cloning existing repo):
   ```bash
   git config core.hooksPath .githooks
   ```
   
   Git hooks are automatically configured for new repositories and provide:
   - **Conventional commit validation**: Ensures commit messages follow the standard format
   - **Pre-commit checks**: Runs formatting and analysis before committing
   - **Pre-push tests**: Runs all tests before pushing

#### Git Workflow

**For Monorepo Changes:**
- Changes to workspace config, CI/CD workflows, or scripts are committed to the monorepo repository
- Use conventional commit messages (see below)

**For Package Changes:**
- Changes to individual packages are committed to their respective package repositories
- Each package maintains its own version and release cycle

### Conventional Commits

This repository uses [Conventional Commits](https://www.conventionalcommits.org/) for commit messages. This enables:
- Automatic version bumping via Melos
- Automatic changelog generation
- Clear commit history

**Commit Message Format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Test additions/changes
- `chore`: Maintenance tasks

**Examples:**
```
feat(turbo_firestore_api): add batch update support
fix(turbo_forms): resolve validation error on empty fields
docs: update README with new examples
```

Git hooks are configured to validate commit messages automatically.

### GitHub Repository Setup

**Repository**: `appboypov/turbo_packages`

#### Recommended Settings

1. **Branch Protection**:
   - Protect `main` branch
   - Require pull request reviews
   - Require status checks to pass (CI workflows)

2. **GitHub Actions Secrets**:
   - `PUB_DEV_CREDENTIALS`: For publishing packages to pub.dev (if using automated publishing)

3. **Repository Settings**:
   - Enable GitHub Actions
   - Set default branch to `main`
   - Configure branch protection rules

#### CI/CD Workflows

The monorepo includes:
- **Monorepo CI** (`.github/workflows/monorepo-ci.yml`): Validates all changed packages on push/PR
- **Monorepo Release** (`.github/workflows/monorepo-release.yml`): Coordinates releases across packages
- **Individual Package CI/CD**: Each package has its own workflows in its repository

## Contributing

Each package maintains its own Git repository and CI/CD workflows. See individual package README files for contribution guidelines.

### Development Workflow

1. **Make changes** in the appropriate package directory
2. **Commit** using conventional commit format
3. **Run checks** before pushing:
   ```bash
   melos run format:check
   melos run analyze
   melos run test
   ```
4. **Push** to your branch and create a pull request

## License

Each package has its own license. See individual package directories for license information.


import 'dart:io';

import 'replacers/app_name_replacer.dart';
import 'replacers/bundle_id_replacer.dart';
import 'replacers/description_replacer.dart';
import 'replacers/display_name_replacer.dart';
import 'replacers/organization_replacer.dart';
import 'replacers/package_name_replacer.dart';
import 'utils/case_converter.dart';
import 'utils/file_utils.dart';

export 'utils/file_utils.dart' show FileChangeInfo, LineChange;

/// Configuration for template initialization.
class TemplateConfig {
  /// The new package name in snake_case (e.g., `my_awesome_app`).
  final String packageName;

  /// The organization domain in reverse notation (e.g., `com.mycompany`).
  final String organization;

  /// The app description.
  final String description;

  TemplateConfig({
    required this.packageName,
    required this.organization,
    required this.description,
  });

  /// The bundle ID suffix derived from package name (camelCase).
  String get bundleIdSuffix => CaseConverter.snakeToCamel(packageName);

  /// The display name derived from package name (Title Case).
  String get displayName => CaseConverter.snakeToTitle(packageName);

  /// The app name (defaults to display name, used in ARB and app config).
  String get appName => displayName;

  /// Validates the configuration.
  ///
  /// Returns null if valid, or an error message if invalid.
  String? validate() {
    if (!CaseConverter.isValidSnakeCase(packageName)) {
      return 'Package name must be valid snake_case (e.g., my_awesome_app)';
    }
    if (!CaseConverter.isValidReverseDomain(organization)) {
      return 'Organization must be valid reverse domain (e.g., com.mycompany)';
    }
    if (description.isEmpty) {
      return 'Description cannot be empty';
    }
    return null;
  }
}

/// Orchestrates the template initialization process.
class TemplateInitializer {
  final Directory projectRoot;

  TemplateInitializer(this.projectRoot);

  /// Initializes the template with the given configuration.
  ///
  /// Returns a summary of the changes made.
  Future<InitResult> initialize(TemplateConfig config) async {
    final validationError = config.validate();
    if (validationError != null) {
      return InitResult.failure(validationError);
    }

    final results = <ReplacerResult>[];

    // Run all replacers
    results.add(await _runReplacer(
      'Package Name',
      () => PackageNameReplacer.replace(projectRoot, config.packageName),
    ));

    results.add(await _runReplacer(
      'Bundle ID',
      () => BundleIdReplacer.replace(projectRoot, config.bundleIdSuffix),
    ));

    results.add(await _runReplacer(
      'Organization',
      () => OrganizationReplacer.replace(projectRoot, config.organization),
    ));

    results.add(await _runReplacer(
      'Display Name',
      () => DisplayNameReplacer.replace(projectRoot, config.displayName),
    ));

    results.add(await _runReplacer(
      'Description',
      () => DescriptionReplacer.replace(projectRoot, config.description),
    ));

    results.add(await _runReplacer(
      'App Name',
      () => AppNameReplacer.replace(projectRoot, config.appName),
    ));

    return InitResult.success(results);
  }

  /// Performs a dry run, showing what would be changed.
  Future<DryRunResult> dryRun(TemplateConfig config) async {
    final validationError = config.validate();
    if (validationError != null) {
      return DryRunResult(
        isValid: false,
        error: validationError,
        files: {},
      );
    }

    final files = <String, List<FileChangeInfo>>{};

    files['Package Name'] = await PackageNameReplacer.dryRun(
      projectRoot,
      config.packageName,
    );
    files['Bundle ID'] = await BundleIdReplacer.dryRun(
      projectRoot,
      config.bundleIdSuffix,
    );
    files['Organization'] = await OrganizationReplacer.dryRun(
      projectRoot,
      config.organization,
    );
    files['Display Name'] = await DisplayNameReplacer.dryRun(
      projectRoot,
      config.displayName,
    );
    files['Description'] = await DescriptionReplacer.dryRun(
      projectRoot,
      config.description,
    );
    files['App Name'] = await AppNameReplacer.dryRun(
      projectRoot,
      config.appName,
    );

    return DryRunResult(isValid: true, files: files);
  }

  Future<ReplacerResult> _runReplacer(
    String name,
    Future<int> Function() replacer,
  ) async {
    try {
      final count = await replacer();
      return ReplacerResult(name: name, filesModified: count);
    } catch (e) {
      return ReplacerResult(name: name, filesModified: 0, error: e.toString());
    }
  }
}

/// Result of a single replacer operation.
class ReplacerResult {
  final String name;
  final int filesModified;
  final String? error;

  ReplacerResult({
    required this.name,
    required this.filesModified,
    this.error,
  });

  bool get hasError => error != null;
}

/// Result of the full initialization process.
class InitResult {
  final bool success;
  final String? error;
  final List<ReplacerResult> results;

  InitResult._({
    required this.success,
    this.error,
    this.results = const [],
  });

  factory InitResult.success(List<ReplacerResult> results) {
    return InitResult._(success: true, results: results);
  }

  factory InitResult.failure(String error) {
    return InitResult._(success: false, error: error);
  }

  int get totalFilesModified =>
      results.fold(0, (sum, r) => sum + r.filesModified);
}

/// Result of a dry run.
class DryRunResult {
  final bool isValid;
  final String? error;
  final Map<String, List<FileChangeInfo>> files;

  DryRunResult({
    required this.isValid,
    this.error,
    required this.files,
  });

  int get totalFiles =>
      files.values.fold(0, (sum, list) => sum + list.length);

  int get totalLines => files.values.fold(
      0, (sum, list) => sum + list.fold(0, (s, f) => s + f.lineCount));
}

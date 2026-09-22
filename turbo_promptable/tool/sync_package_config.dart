// Mirrors the pub workspace resolution into this package's own
// `.dart_tool/package_config.json`.
//
// This package uses `resolution: workspace`, so `dart pub get` writes a single
// resolution file at the workspace root. Tools rooted at this package (IntelliJ
// IDEA / Android Studio opening `turbo_promptable` directly) read the package's
// own `.dart_tool/package_config.json` and report every `package:` import as
// unresolved when it is missing. This script writes that file with absolute
// package URIs so the package resolves on its own.
import 'dart:convert';
import 'dart:io';

void main() {
  final packageRoot = Directory.current.uri;
  final workspaceConfig = _findWorkspaceConfig(packageRoot);
  if (workspaceConfig == null) {
    stderr.writeln(
      'No workspace package_config.json found above $packageRoot. '
      'Run `dart pub get` in the workspace root first.',
    );
    exitCode = 1;
    return;
  }

  final config =
      jsonDecode(workspaceConfig.readAsStringSync()) as Map<String, dynamic>;
  final configDir = workspaceConfig.parent.uri;
  final packages = [
    for (final package in config['packages'] as List)
      {
        ...package as Map<String, dynamic>,
        'rootUri': configDir.resolve(package['rootUri'] as String).toString(),
      },
  ];

  final target = File.fromUri(
    packageRoot.resolve('.dart_tool/package_config.json'),
  );
  target.parent.createSync(recursive: true);
  target.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert({
      ...config,
      'packages': packages,
      'generated': DateTime.now().toUtc().toIso8601String(),
    })}\n',
  );
  stdout.writeln('Wrote ${packages.length} packages to ${target.path}');
}

File? _findWorkspaceConfig(Uri packageRoot) {
  var directory = Directory.fromUri(packageRoot).parent;
  while (true) {
    final candidate = File.fromUri(
      directory.uri.resolve('.dart_tool/package_config.json'),
    );
    if (candidate.existsSync()) return candidate;
    final parent = directory.parent;
    if (parent.path == directory.path) return null;
    directory = parent;
  }
}

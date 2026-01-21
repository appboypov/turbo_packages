// ignore_for_file: unused_element

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:turbo_firestore_api/extensions/completer_extension.dart';
import 'package:turbo_flutter_template/core/auth/services/auth_service.dart';
import 'package:turbo_flutter_template/core/auth/globals/g_now.dart';
import 'package:turbo_flutter_template/core/infrastructure/enums/navigation_tab.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_values.dart';
import 'package:turbo_flutter_template/core/shared/extensions/list_extension.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/enums/box_key.dart';
import 'package:turbo_flutter_template/core/ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ui/services/badge_service.dart';
import 'package:turbo_flutter_template/core/ux/enums/t_supported_language.dart';
import 'package:turbolytics/turbolytics.dart';

class LocalStorageService extends ChangeNotifier with Turbolytics {
  LocalStorageService() {
    _initialise();
  }

  static LocalStorageService get locate => GetIt.I.get();
  static void registerLazySingleton() =>
      GetIt.I.registerLazySingleton(LocalStorageService.new, dispose: (param) => param.dispose());

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  AuthService get _authService => AuthService.locate;
  BadgeService get _badgeService => BadgeService.locate;
  FlutterSecureStorage get _flutterSecureStorage => const FlutterSecureStorage();

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  Future<void> _initialise() async {
    try {
      log.info('Initializing LocalStorageService...');
      Hive.init(kIsWeb ? null : (await getApplicationDocumentsDirectory()).path);
      _box = await Hive.openBox(
        '_deviceBoxKey',
        encryptionCipher: HiveAesCipher(await _encryptionKey),
      );
      _isReady.completeIfNotComplete();
    } catch (error, stackTrace) {
      log.error(
        'Exception caught while initialising hive service',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void dispose() {
    log.info('Clearing _userBox data during dispose...');
    log.info('User box cleared during dispose.');
    _isReady = Completer();
    super.dispose();
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  Completer _isReady = Completer();
  late Box _box;

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  String? get lastChangelogVersionRead =>
      _boxGet<String>(boxKey: BoxKey.lastChangelogVersionRead, id: null, userId: _userId);

  bool didHappen({required Object id, required String userId}) =>
      _boxGet<bool>(boxKey: BoxKey.didHappen, id: id, userId: userId) ?? false;

  bool didSee({required Object id, required String userId}) =>
      _boxGet<bool>(boxKey: BoxKey.didSee, id: id, userId: userId) ?? false;

  Future get isReady => _isReady.future;

  TThemeMode get themeMode =>
      _boxGet<bool>(boxKey: BoxKey.isLightMode, id: null, userId: null) ?? false
      ? TThemeMode.light
      : TThemeMode.dark;

  TSupportedLanguage get language {
    final storedLanguage = _boxGet<String>(
      boxKey: BoxKey.language,
      id: null,
      userId: null,
    );

    // If a language is stored, return it
    if (storedLanguage != null) {
      return TSupportedLanguage.values.asNameMap()[storedLanguage] ?? TSupportedLanguage.en;
    }

    // Otherwise, detect and use the device's system language
    return TSupportedLanguage.fromDeviceLocale();
  }

  Future<List<int>> get _encryptionKey async {
    final flutterSecureStorage = _flutterSecureStorage;
    final encryptionKeyEncoded = await flutterSecureStorage.read(key: TKeys.hiveEncryptionKey);
    if (encryptionKeyEncoded == null) {
      final encryptionKey = Hive.generateSecureKey();
      await flutterSecureStorage.write(
        key: TKeys.hiveEncryptionKey,
        value: base64UrlEncode(encryptionKey),
      );
      return encryptionKey;
    } else {
      return base64Url.decode(encryptionKeyEncoded);
    }
  }

  DateTime? get skippedVerifyEmailDate =>
      _boxGet<DateTime>(boxKey: BoxKey.skippedVerifyEmailDate, id: null, userId: _userId);

  NavigationTab get navigationTab =>
      NavigationTab.values.indexOrNull(
        _boxGet<int>(
              id: null,
              userId: _userId,
              boxKey: BoxKey.bottomNavigationIndex,
              defaultValue: 0,
            ) ??
            0,
      ) ??
      NavigationTab.defaultValue;

  /// Checks if a language preference has been stored
  ///
  /// Returns true if the user has previously saved a language preference,
  /// false if this is the first launch and no preference exists
  bool get hasStoredLanguage => _boxContains(
    userId: null,
    boxKey: BoxKey.language,
    id: null,
  );

  String? get lastEnvironment => _boxGet<String>(
    boxKey: BoxKey.lastEnvironment,
    id: null,
    userId: null,
  );

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\

  String get _userId => _authService.userId ?? TValues.noAuthId;

  bool _boxContains({required String? userId, required BoxKey boxKey, required Object? id}) {
    try {
      final containsKey = _box.containsKey(boxKey.genId(id: id, userId: userId));
      log.info('Checking if [BoxKey] contains [$boxKey]: $containsKey');
      return containsKey;
    } catch (error, stackTrace) {
      log.error(
        '${error.runtimeType} caught while checking if device box contains $boxKey',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  T? _boxGet<T>({
    required String? userId,
    T? defaultValue,
    required BoxKey boxKey,
    required Object? id,
  }) {
    try {
      final value = _box.get(
        boxKey.genId(id: id, userId: userId),
        defaultValue: defaultValue,
      );
      log.info('Getting [BoxKey] value [$boxKey]: $value');
      return value;
    } catch (error, stackTrace) {
      log.error(
        '${error.runtimeType} caught while getting $boxKey from device box',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _boxInsert<T>({
    required String? userId,
    required BoxKey boxKey,
    required Object? id,
    required T value,
  }) async {
    try {
      log.info('Updating [BoxKey] [$boxKey]: $value');
      await _box.put(boxKey.genId(id: id, userId: userId), value);
      notifyListeners();
    } catch (error, stackTrace) {
      log.error(
        '${error.runtimeType} caught while putting $boxKey in device box',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _boxDelete({
    required String? userId,
    required BoxKey hiveDeviceBox,
    required Object? id,
  }) async {
    try {
      log.info('Deleting [BoxKey] [$hiveDeviceBox]');
      await _box.delete(hiveDeviceBox.genId(id: id, userId: userId));
      notifyListeners();
    } catch (error, stackTrace) {
      log.error(
        '${error.runtimeType} caught while deleting $hiveDeviceBox from device box',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // 🏗 HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<void> updateDidHappen({
    required String userId,
    required Object id,
    bool didHappen = true,
  }) async => _boxInsert(userId: userId, boxKey: BoxKey.didHappen, id: id, value: didHappen);

  Future<void> updateDidSee({
    required String userId,
    required Object id,
    bool didSee = true,
  }) async => _boxInsert(userId: userId, boxKey: BoxKey.didSee, id: id, value: didSee);

  Future<void> updateTThemeMode({required TThemeMode themeMode}) async => _boxInsert(
    userId: null,
    boxKey: BoxKey.isLightMode,
    id: null,
    value: themeMode == TThemeMode.light,
  );

  Future<void> updateLanguage({required TSupportedLanguage language}) async =>
      _boxInsert(userId: null, boxKey: BoxKey.language, id: null, value: language.name);

  Future<void> updateSkippedVerifyEmailDate() async =>
      _boxInsert(userId: _userId, id: null, boxKey: BoxKey.skippedVerifyEmailDate, value: gNow);

  void updateBottomNavigationIndex({required NavigationTab navigationTab}) => _boxInsert(
    userId: _userId,
    boxKey: BoxKey.bottomNavigationIndex,
    value: navigationTab.index,
    id: null,
  );

  Future<void> updateLastChangelogVersionRead({required String? version}) async {
    await _boxInsert(
      boxKey: BoxKey.lastChangelogVersionRead,
      id: null,
      userId: _userId,
      value: version,
    );
    unawaited(_badgeService.manageHasUnreadChangelog());
  }

  Future<void> updateLastEnvironment({required String environment}) async {
    await _boxInsert(
      boxKey: BoxKey.lastEnvironment,
      id: null,
      userId: null,
      value: environment,
    );
  }
}

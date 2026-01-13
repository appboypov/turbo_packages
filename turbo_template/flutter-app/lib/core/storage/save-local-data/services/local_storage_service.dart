import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:loglytics/loglytics.dart';
import 'package:path_provider/path_provider.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/constants/data_keys.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/constants/storage_keys.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/enums/box_key.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/extensions/completer_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ux/manage-language/enums/t_supported_language.dart';

class LocalStorageService extends ChangeNotifier with Loglytics {
  LocalStorageService() {
    _initialise();
  }

  static LocalStorageService get locate => GetIt.I.get();
  static void registerLazySingleton() =>
      GetIt.I.registerLazySingleton(LocalStorageService.new, dispose: (param) => param.dispose());

  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();

  Future<void> _initialise() async {
    try {
      log.info('Initializing LocalStorageService...');
      Hive.init(kIsWeb ? null : (await getApplicationDocumentsDirectory()).path);
      _box = await Hive.openBox(
        StorageKeys.deviceBoxKey,
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
    log.info('Clearing data during dispose...');
    _isReady = Completer();
    super.dispose();
  }

  Completer _isReady = Completer();
  late Box _box;

  Future get isReady => _isReady.future;

  TThemeMode get themeMode =>
      _boxGet<bool>(boxKey: BoxKey.isLightMode, id: null, userId: null) ?? false
      ? TThemeMode.light
      : TThemeMode.dark;

  TSupportedLanguage get language {
    final storedLanguage = _boxGet<String>(boxKey: BoxKey.language, id: null, userId: null);

    if (storedLanguage != null) {
      return TSupportedLanguage.values.asNameMap()[storedLanguage] ?? TSupportedLanguage.en;
    }

    return TSupportedLanguage.fromDeviceLocale();
  }

  bool get hasStoredLanguage => _boxContains(userId: null, boxKey: BoxKey.language, id: null);

  Future<List<int>> get _encryptionKey async {
    final encryptionKeyEncoded = await _flutterSecureStorage.read(key: DataKeys.hiveEncryptionKey);
    if (encryptionKeyEncoded == null) {
      final encryptionKey = Hive.generateSecureKey();
      await _flutterSecureStorage.write(
        key: DataKeys.hiveEncryptionKey,
        value: base64UrlEncode(encryptionKey),
      );
      return encryptionKey;
    } else {
      return base64Url.decode(encryptionKeyEncoded);
    }
  }

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

  Future<void> updateTThemeMode({required TThemeMode themeMode}) async => _boxInsert(
    userId: null,
    boxKey: BoxKey.isLightMode,
    id: null,
    value: themeMode == TThemeMode.light,
  );

  Future<void> updateLanguage({required TSupportedLanguage language}) async =>
      _boxInsert(userId: null, boxKey: BoxKey.language, id: null, value: language.name);
}

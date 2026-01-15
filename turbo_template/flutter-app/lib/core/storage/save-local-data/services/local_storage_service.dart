import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/constants/data_keys.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/constants/storage_keys.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/enums/box_key.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/extensions/completer_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/enums/t_theme_mode.dart';
import 'package:turbo_flutter_template/core/ux/manage-language/enums/t_supported_language.dart';
import 'package:turbolytics/turbolytics.dart';

class LocalStorageService extends ChangeNotifier with Turbolytics {
  LocalStorageService() {
    _initialise();
  }

  static LocalStorageService get locate => GetIt.I.get();
  static void registerLazySingleton() =>
      GetIt.I.registerLazySingleton(LocalStorageService.new, dispose: (param) => param.dispose());

  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();

  Future<void> _initialise() async {
    const maxRetries = 3;
    const retryDelay = Duration(milliseconds: 500);
    
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        log.info('Initializing LocalStorageService... (attempt ${attempt + 1}/$maxRetries)');
        final documentsDir = kIsWeb ? null : (await getApplicationDocumentsDirectory()).path;
        Hive.init(documentsDir);
        
        _box = await Hive.openBox(
          StorageKeys.deviceBoxKey,
          encryptionCipher: HiveAesCipher(await _encryptionKey),
        );
        _isReady.completeIfNotComplete();
        log.info('LocalStorageService initialized successfully');
        return;
      } on FileSystemException catch (error, stackTrace) {
        if (error.osError?.errorCode == 35 && attempt < maxRetries - 1) {
          // Lock file error (errno 35) - retry after delay
          log.warning(
            'Lock file error detected, retrying in ${retryDelay.inMilliseconds}ms...',
            error: error,
          );
          await Future.delayed(retryDelay * (attempt + 1));
          continue;
        }
        log.error(
          'FileSystemException caught while initialising hive service',
          error: error,
          stackTrace: stackTrace,
        );
      } catch (error, stackTrace) {
        log.error(
          'Exception caught while initialising hive service',
          error: error,
          stackTrace: stackTrace,
        );
      }
      
      // If we get here, initialization failed
      if (attempt == maxRetries - 1) {
        log.error('Failed to initialize LocalStorageService after $maxRetries attempts');
        // Complete anyway to prevent app from hanging
        _isReady.completeIfNotComplete();
      }
    }
  }

  @override
  void dispose() {
    log.info('Clearing data during dispose...');
    _box?.close();
    _isReady = Completer();
    super.dispose();
  }

  Completer _isReady = Completer();
  Box? _box;

  Future get isReady => _isReady.future;

  bool get _isBoxReady => _box != null && _box!.isOpen;

  TThemeMode get themeMode =>
      _isBoxReady && (_boxGet<bool>(boxKey: BoxKey.isLightMode, id: null, userId: null) ?? false)
      ? TThemeMode.light
      : TThemeMode.dark;

  TSupportedLanguage get language {
    if (!_isBoxReady) {
      return TSupportedLanguage.fromDeviceLocale();
    }
    
    final storedLanguage = _boxGet<String>(boxKey: BoxKey.language, id: null, userId: null);

    if (storedLanguage != null) {
      return TSupportedLanguage.values.asNameMap()[storedLanguage] ?? TSupportedLanguage.en;
    }

    return TSupportedLanguage.fromDeviceLocale();
  }

  bool get hasStoredLanguage => _isBoxReady && _boxContains(userId: null, boxKey: BoxKey.language, id: null);

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
    if (!_isBoxReady) return false;
    try {
      final containsKey = _box!.containsKey(boxKey.genId(id: id, userId: userId));
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
    if (!_isBoxReady) return defaultValue;
    try {
      final value = _box!.get(
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
      return defaultValue;
    }
  }

  Future<void> _boxInsert<T>({
    required String? userId,
    required BoxKey boxKey,
    required Object? id,
    required T value,
  }) async {
    if (!_isBoxReady) {
      log.warning('Cannot insert $boxKey: box is not ready');
      return;
    }
    try {
      log.info('Updating [BoxKey] [$boxKey]: $value');
      await _box!.put(boxKey.genId(id: id, userId: userId), value);
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

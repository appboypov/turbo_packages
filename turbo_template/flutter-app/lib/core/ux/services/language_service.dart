import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/storage/save-local-data/services/local_storage_service.dart';
import 'package:turbo_flutter_template/core/ux/enums/t_supported_language.dart';
import 'package:turbo_notifiers/turbo_notifiers.dart';
import 'package:turbolytics/turbolytics.dart';

class LanguageService with Turbolytics {
  LanguageService() {
    _initialise();
  }

  static LanguageService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(LanguageService.new);

  LocalStorageService get _localStorageService => LocalStorageService.locate;

  Future<void> _initialise() async {
    try {
      await _localStorageService.isReady;
      log.debug('Initializing language');
      final savedLanguage = _localStorageService.language;
      log.debug('Loading language: $savedLanguage');

      if (!_localStorageService.hasStoredLanguage) {
        log.debug('First launch detected. Saving detected language: $savedLanguage');
        await _localStorageService.updateLanguage(language: savedLanguage);
      }

      _language.update(savedLanguage);
    } catch (error, stackTrace) {
      log.error('$error caught while initializing language', error: error, stackTrace: stackTrace);
    } finally {
      log.debug('Language service is ready');
      _isReady.complete();
    }
  }

  final Completer _isReady = Completer();
  late final _language = TNotifier<TSupportedLanguage>(TSupportedLanguage.defaultValue);

  Future get isReady => _isReady.future;
  String get languageCode => _language.value.languageCode;
  ValueListenable<TSupportedLanguage> get language => _language;

  Future<void> updateLanguage(TSupportedLanguage newLanguage) async {
    log.debug('Updating language to: $newLanguage');
    await _localStorageService.updateLanguage(language: newLanguage);
    _language.update(newLanguage);
    log.debug('Language ValueListenable updated to: ${_language.value}');
  }
}

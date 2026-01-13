import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:loglytics/loglytics.dart';

import 'package:turbo_flutter_template/core/connection/manage-connection/extensions/connectivity_result_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/completer_extension.dart';
import 'package:turbo_flutter_template/core/state/manage-state/utils/debouncer.dart';

class ConnectionService with Loglytics {
  ConnectionService() {
    initialize();
  }

  static ConnectionService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(
    ConnectionService.new,
    dispose: (param) async => await param.dispose(),
  );

  final Connectivity _connectivity = Connectivity();
  Completer<bool> _hasInternetCompleter = Completer();

  Future<void> initialize() async {
    try {
      log.info('Initializing connection service..');
      _streamSubscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        cancelOnError: false,
        onError: (error, _) => log.error(
          'Something went wrong listening for connection updates',
          error: error,
          stackTrace: StackTrace.current,
        ),
      );
      await _updateInternetConnection();
      log.info('Connection service initialised!');
    } catch (error, stackTrace) {
      log.error(
        'Something went wrong initialising the connection service!',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> dispose() async => await _streamSubscription?.cancel();

  final _hasInternetConnection = ValueNotifier<bool>(true);
  StreamSubscription? _streamSubscription;
  bool _didInitialFetch = false;

  final _debouncer = Debouncer();

  ValueListenable<bool> get hasInternetConnection => _hasInternetConnection;
  Future<bool> get hasInternetCompleter => _hasInternetCompleter.future;

  Future<void> _onConnectivityChanged(_) async {
    await _updateInternetConnection();
  }

  Future<void> _updateInternetConnection() async {
    log.info('Fetching internet connection..');
    if (!_didInitialFetch) {
      await _manageHasInternetConnection();
      log.info('Has internet connection: ${_hasInternetConnection.value}');
      _didInitialFetch = true;
    } else {
      _debouncer.run(() async {
        await _manageHasInternetConnection();
        log.info('Has internet connection: ${_hasInternetConnection.value}');
      });
    }
  }

  Future<void> _manageHasInternetConnection() async {
    try {
      final connectivity = await _connectivity.checkConnectivity().timeout(
        const Duration(seconds: 5),
      );
      _hasInternetConnection.value = connectivity.hasPhoneConnection;
      _hasInternetCompleter.completeIfNotComplete(_hasInternetConnection.value);
      if (!_hasInternetConnection.value) {
        _hasInternetCompleter = Completer();
      }
    } catch (error, stackTrace) {
      log.error(
        '$error caught while fetching internet connection status!',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<bool> fetchInternetConnection() async {
    if (kIsWeb) return true;
    await _updateInternetConnection();
    return _hasInternetConnection.value;
  }
}

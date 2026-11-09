import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_firestore_api/services/t_auth_sync_service.dart';
import 'package:turbolytics/turbolytics.dart';

class _FakeAuth extends FirebaseAuthPlatform {
  final _users = StreamController<UserPlatform?>.broadcast(sync: true);
  UserPlatform? _current;

  @override
  FirebaseAuthPlatform delegateFor({required FirebaseApp app}) => this;

  @override
  FirebaseAuthPlatform setInitialValues({
    InternalUserDetails? currentUser,
    String? languageCode,
  }) => this;

  @override
  UserPlatform? get currentUser => _current;

  @override
  Stream<UserPlatform?> userChanges() async* {
    yield _current;
    yield* _users.stream;
  }

  void emit(UserPlatform? user) {
    _current = user;
    _users.add(user);
  }
}

class _FakeMultiFactor extends MultiFactorPlatform {
  _FakeMultiFactor(super.auth);
}

class _FakeUser extends UserPlatform {
  _FakeUser(FirebaseAuthPlatform auth)
    : super(
        auth,
        _FakeMultiFactor(auth),
        InternalUserDetails(
          userInfo: InternalUserInfo(
            uid: 'fan',
            isAnonymous: false,
            isEmailVerified: true,
          ),
          providerData: [],
        ),
      );
}

class _Sync extends TAuthSyncService<int> {
  final starts = <String>[];
  StreamController<int>? data;

  @override
  FutureOr<Stream<int?>> Function(User user) get stream => (user) {
    starts.add(user.uid);
    data = StreamController<int>();
    return data!.stream;
  };

  @override
  Future<void> Function(int? value, User? user) get onData =>
      (value, user) async {};
}

void main() {
  late _FakeAuth auth;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
    TLog.level = TLogLevel.fatal;
    auth = _FakeAuth();
    FirebaseAuthPlatform.instance = auth;
  });

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 50));

  group('TAuthSyncService', () {
    test(
      'starts the stream again when the user signs in after a stream error and a sign-out',
      () async {
        final sync = _Sync();
        await settle();
        auth.emit(_FakeUser(auth));
        await settle();
        expect(sync.starts, ['fan']);
        sync.data!.addError(
          FirebaseException(
            plugin: 'cloud_firestore',
            code: 'permission-denied',
          ),
        );
        await settle();
        auth.emit(null);
        await Future<void>.delayed(const Duration(seconds: 11));
        auth.emit(_FakeUser(auth));
        await settle();
        expect(sync.starts, ['fan', 'fan']);
        await sync.dispose();
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_firestore_api/turbo_firestore_api.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/dtos/user_dto.dart';
import 'package:turbo_response/turbo_response.dart';

class UserService extends TDocumentService<UserDto, UsersApi> with Loglytics {
  UserService() : super(api: UsersApi.locate);

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static UserService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(
        UserService.new,
        dispose: (param) async => await param.dispose(),
      );

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  @override
  Stream<UserDto?> Function(User user) get stream =>
      (user) => api.streamDocByIdWithConverter(id: user.uid);

  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  DateTime? get acceptedPrivacyAndTermsAt => doc.value?.acceptedPrivacyAndTermsAt;
  String? get email => doc.value?.email;
  String? get initialHouseholdId => doc.value?.initialHouseholdId;
  ValueListenable<UserDto?> get userDto => doc;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<TurboResponse> createUser({required CreateDocDef<UserDto> doc}) async =>
      createDoc(doc: doc);

  Future<TurboResponse> updateAcceptedPrivacyAndTermsAt({
    required DateTime acceptedPrivacyAndTermsAt,
  }) async {
    return updateDoc(
      id: id!,
      doc: (current, vars) =>
          current.copyWith(acceptedPrivacyAndTermsAt: acceptedPrivacyAndTermsAt),
      remoteUpdateRequestBuilder: (doc) =>
          UpdateUserDtoRequest(acceptedPrivacyAndTermsAt: acceptedPrivacyAndTermsAt),
    );
  }

  Future<TurboResponse> updateLastChangelogVersionRead({required String? version}) async {
    if (id == null) {
      return TurboResponse.failAsBool(message: gStrings.userIdIsNull);
    }

    return updateDoc(
      id: id!,
      doc: (current, vars) => current.copyWith(lastChangelogVersionRead: version),
      remoteUpdateRequestBuilder: (doc) => UpdateUserDtoRequest(lastChangelogVersionRead: version),
    );
  }

  Future<TurboResponse> updateInitialHouseholdId({required String householdId}) async {
    if (id == null) {
      return TurboResponse.failAsBool(message: gStrings.userIdIsNull);
    }

    // Only update if initialHouseholdId is not already set
    if (initialHouseholdId != null) {
      return throw const UnexpectedStateException(
        reason: 'should never override initial householdId',
      );
    }

    return updateDoc(
      id: id!,
      doc: (current, vars) => current.copyWith(initialHouseholdId: householdId),
      remoteUpdateRequestBuilder: (doc) => UpdateUserDtoRequest(initialHouseholdId: householdId),
    );
  }
}

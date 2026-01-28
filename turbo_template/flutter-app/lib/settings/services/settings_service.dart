import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_firestore_api/apis/t_firestore_api.dart';
import 'package:turbo_firestore_api/services/t_document_service.dart';
import 'package:turbo_firestore_api/typedefs/create_doc_def.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_flutter_template/core/state/manage-state/typedefs/lazy_locator_def.dart';
import 'package:turbo_flutter_template/settings/apis/settings_api.dart';
import 'package:turbo_flutter_template/settings/dtos/settings_dto.dart';
import 'package:turbo_response/turbo_response.dart';

class SettingsService extends TDocumentService<SettingsDto, SettingsApi> {
  SettingsService() : super(api: SettingsApi.locate);

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static SettingsService get locate => GetIt.I.get();
  static void registerLazySingleton() => GetIt.I.registerLazySingleton(SettingsService.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\

  @override
  LazyLocatorDef<SettingsDto>? get initialValueLocator =>
      () => SettingsDto.create(vars: turboVars());

  @override
  Stream<SettingsDto?> Function(User user) get stream =>
      (user) => api
          .streamByQueryWithConverter(
            whereDescription: '${TKeys.userId} equals ${user.uid}',
            collectionReferenceQuery: (collectionReference) =>
                collectionReference.where(TKeys.userId, isEqualTo: user.uid),
          )
          .map((event) => event.firstOrNull);

  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  SettingsDto get settingsDto => doc.value!;
  bool get hasSettings => doc.value != null;
  DateTime? get skippedVerifyEmailDate => doc.value?.skippedVerifyEmailDate;
  int get verifyEmailSnoozeCount => doc.value?.verifyEmailSnoozeCount ?? 0;

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<TurboResponse> updateSkippedVerifyEmailDate({
    required DateTime skippedVerifyEmailDate,
    bool incrementSnoozeCount = false,
  }) => updateDoc(
    id: id!,
    doc: (current, vars) => current.copyWith(
      skippedVerifyEmailDate: skippedVerifyEmailDate,
      verifyEmailSnoozeCount: incrementSnoozeCount
          ? (current.verifyEmailSnoozeCount + 1)
          : current.verifyEmailSnoozeCount,
    ),
    remoteUpdateRequestBuilder: (doc) => doc.asUpdateSkippedVerifyEmailDateRequest,
  );

  Future<TurboResponse> resetVerifyEmailSnoozeCount() => updateDoc(
    id: id!,
    doc: (current, vars) => current.copyWith(verifyEmailSnoozeCount: 0),
    remoteUpdateRequestBuilder: (doc) => doc.asUpdateSkippedVerifyEmailDateRequest,
  );

  Future<TurboResponse> createSettings({required CreateDocDef<SettingsDto> doc}) async =>
      createDoc(doc: doc);
}

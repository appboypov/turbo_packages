import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/auth/globals/g_user_id.dart';
import 'package:turbo_flutter_template/settings/dtos/settings_dto.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/abstracts/turbo_api.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/constants/firestore_collection.dart';

class SettingsApi extends TurboApi<SettingsDto> {
  SettingsApi()
    : super(
        firestoreCollection: FirestoreCollection.settings,
        path: (firestoreCollection) => firestoreCollection.path(userId: gUserId),
      );

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static SettingsApi get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(SettingsApi.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  Future<bool> hasSettings({required String userId}) async => await docExists(id: userId);

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}

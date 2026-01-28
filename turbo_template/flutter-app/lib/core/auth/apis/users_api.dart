import 'package:get_it/get_it.dart';
import 'package:turbo_flutter_template/core/auth/dtos/user_dto.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/abstracts/turbo_api.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/constants/firestore_collection.dart';

class UsersApi extends TurboApi<UserDto> {
  UsersApi() : super(firestoreCollection: FirestoreCollection.users);

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static UsersApi get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(UsersApi.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  Future<bool> userExists({required String userId}) => docExists(id: userId);

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}

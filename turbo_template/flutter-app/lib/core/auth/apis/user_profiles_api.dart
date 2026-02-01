import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_firestore_api/apis/t_firestore_api.dart';
import 'package:turbo_firestore_api/enums/t_search_term_type.dart';
import 'package:turbo_flutter_template/core/auth/dtos/create_profile_request.dart';
import 'package:turbo_flutter_template/core/auth/dtos/user_profile_dto.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/abstracts/turbo_api.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/constants/firestore_collection.dart';
import 'package:turbo_response/turbo_response.dart';
import 'package:turbolytics/turbolytics.dart';

class UserProfilesApi extends TurboApi<UserProfileDto> with Turbolytics {
  UserProfilesApi()
    : super(firestoreCollection: FirestoreCollection.userProfiles);

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static UserProfilesApi get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(UserProfilesApi.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  Future<bool> hasProfile({required String userId}) async =>
      (await getByIdWithConverter(id: userId)).isSuccess;

  Future<TurboResponse<UserProfileDto>> findByUserId({
    required String userId,
  }) => getByIdWithConverter(id: userId);

  Future<TurboResponse<List<UserProfileDto>>> findByUserIds({
    required List<String> userIds,
  }) async {
    final profiles = <UserProfileDto>[];
    for (final userId in userIds) {
      final profileResponse = await findByUserId(userId: userId);
      if (profileResponse.isSuccess) {
        profiles.add(profileResponse.result);
      }
    }
    return TurboResponse.success(result: profiles);
  }

  Future<TurboResponse<List<UserProfileDto>>> search({
    required String searchTerm,
  }) async => await listBySearchTermWithConverter(
    searchTerm: searchTerm,
    searchField: TKeys.searchTerms,
    searchTermType: TSearchTermType.arrayContains,
  );

  Future<bool> profileExists({required String userId}) => docExists(id: userId);

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<TurboResponse<DocumentReference>> createProfile({
    required String userId,
    required String username,
  }) async => createDoc(
    writeable: CreateProfileRequest(
      profileDto: UserProfileDto.defaultValue(
        userId: userId,
        username: username,
      ),
    ),
    id: userId,
  );
}

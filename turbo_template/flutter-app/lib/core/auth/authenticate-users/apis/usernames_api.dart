import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:turbo_firestore_api/apis/t_firestore_api.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/dtos/create_username_request.dart';
import 'package:turbo_flutter_template/core/auth/authenticate-users/dtos/username_dto.dart';
import 'package:turbo_flutter_template/core/shared/constants/t_keys.dart';
import 'package:turbo_flutter_template/core/shared/exceptions/unexpected_result_exception.dart';
import 'package:turbo_flutter_template/core/shared/extensions/string_extension.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/abstracts/turbo_api.dart';
import 'package:turbo_flutter_template/core/storage/manage-data/constants/firestore_collection.dart';
import 'package:turbo_response/turbo_response.dart';
import 'package:turbolytics/turbolytics.dart';

class UsernamesApi extends TurboApi<UsernameDto> with Turbolytics {
  UsernamesApi() : super(firestoreCollection: FirestoreCollection.usernames);

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static UsernamesApi get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(UsernamesApi.new);

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  Future<String?> fetchUsername({required String userId}) async {
    try {
      final response = await listByQueryWithConverter(
        collectionReferenceQuery: (collectionReference) =>
            collectionReference.where(TKeys.userId, isEqualTo: userId),
        whereDescription: '${TKeys.userId} isEqual to $userId',
      );

      return await response.whenSuccess<String?>((response) async {
        final result = response.result;
        if ((result.length) > 1) {
          log.error(
            'Users can only have 1 username',
            error: UnexpectedResultException(
              result: result,
              reason: 'User can only have 1 username, ids: ${result.map((e) => e.id).toList()}',
            ),
            stackTrace: StackTrace.current,
          );
          await deleteOldUsernames(userId: userId);
          return null;
        }
        return result.firstOrNull?.id;
      });
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while checking if user has username',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<bool> usernameIsAvailable({required String username, required String userId}) async {
    try {
      // Normalize the username to ensure consistency with how it's stored
      final normalizedUsername = username.naked;

      // Check if the username document exists
      final usernameIsAvailable = !(await docExists(id: normalizedUsername));

      if (!usernameIsAvailable) {
        // If the username exists, check if it belongs to the current user
        return await isMe(username: normalizedUsername, userId: userId);
      }
      return usernameIsAvailable;
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while checking if username is available',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> isMe({required String username, required String userId}) async {
    // Normalize the username to ensure consistency
    final normalizedUsername = username.naked;
    log.debug('Checking if username "$normalizedUsername" belongs to userId: $userId');

    return (await getByIdWithConverter(
      id: normalizedUsername,
    )).when(success: (response) => response.result.userId == userId, fail: (response) => false);
  }

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<TurboResponse> deleteOldUsernames({
    required String userId,
    Transaction? transaction,
  }) async {
    try {
      final response = await listByQueryWithConverter(
        collectionReferenceQuery: (collectionReference) =>
            collectionReference.where(TKeys.userId, isEqualTo: userId),
        whereDescription: '${TKeys.userId} isEqual to $userId',
      );

      await response.whenSuccess((response) async {
        for (final oldUsername in response.result) {
          if (transaction == null) {
            await deleteDoc(id: oldUsername.id);
          } else {
            final response = await deleteDoc(id: oldUsername.id, transaction: transaction);
            response.throwWhenFail();
          }
        }
      });
      return response;
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while deleting old usernames',
        error: error,
        stackTrace: stackTrace,
      );
      return TurboResponse.fail(error: error);
    }
  }

  Future<TurboResponse> createUsername({
    required String username,
    required String userId,
    required Transaction transaction,
  }) async {
    // Normalize username to ensure consistency
    final normalizedUsername = username.naked;

    log.debug('Creating username document for "$normalizedUsername" with userId: $userId');

    return createDoc(
      id: normalizedUsername,
      transaction: transaction,
      writeable: CreateUsernameRequest(userId: userId),
    );
  }
}

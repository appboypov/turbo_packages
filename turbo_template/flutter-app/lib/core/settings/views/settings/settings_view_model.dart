import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:informers/informer.dart';
import 'package:loglytics/loglytics.dart';
import 'package:roomy_mobile/auth/dtos/user_profile_dto.dart';
import 'package:roomy_mobile/auth/forms/user_profile_form.dart';
import 'package:roomy_mobile/auth/services/auth_service.dart';
import 'package:roomy_mobile/auth/services/user_profiles_service.dart';
import 'package:roomy_mobile/auth/services/user_service.dart';
import 'package:roomy_mobile/auth/views/verify_email/verify_email_origin.dart';
import 'package:roomy_mobile/camera/services/image_picker_service.dart';
import 'package:roomy_mobile/core/dtos/icon_label_dto.dart';
import 'package:roomy_mobile/core/enums/icon_collection.dart';
import 'package:roomy_mobile/data/constants/k_values.dart';
import 'package:roomy_mobile/feedback/globals/g_feedback.dart';
import 'package:roomy_mobile/feedback/services/dialog_service.dart';
import 'package:roomy_mobile/feedback/services/sheet_service.dart';
import 'package:roomy_mobile/feedback/services/toast_service.dart';
import 'package:roomy_mobile/forms/config/t_form_field_config.dart';
import 'package:roomy_mobile/households/models/household_member.dart';
import 'package:roomy_mobile/households/services/household_service.dart';
import 'package:roomy_mobile/http/services/url_launcher_service.dart';
import 'package:roomy_mobile/l10n/enums/t_supported_language.dart';
import 'package:roomy_mobile/l10n/services/language_service.dart';
import 'package:roomy_mobile/routing/routers/core_router.dart';
import 'package:roomy_mobile/settings/widgets/t_radio_sheet.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/state/extensions/informer_extension.dart';
import 'package:roomy_mobile/state/globals/g_busy.dart';
import 'package:roomy_mobile/storage/services/firebase_storage_service.dart';
import 'package:roomy_mobile/storage/services/local_storage_service.dart';
import 'package:roomy_mobile/ui/services/clipboard_service.dart';
import 'package:roomy_mobile/ui/services/theme_service.dart';
import 'package:turbo_response/turbo_response.dart';
import 'package:veto/data/models/base_view_model.dart';

/// View model for the settings screen that handles user profile management,
/// theme settings, language preferences, and account actions.
class SettingsViewModel extends BaseViewModel with Loglytics {
  /// Creates a new instance of [SettingsViewModel].
  SettingsViewModel();

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  /// Gets the registered instance of [SettingsViewModel] from the service locator.
  static SettingsViewModel get locate => GetIt.I.get();

  /// Registers [SettingsViewModel] as a factory with the service locator.
  static void registerFactory() => GetIt.I.registerFactory(() => SettingsViewModel());

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final _authService = AuthService.locate;
  final _languageService = LanguageService.locate;
  SheetService get _sheetService => SheetService.locate;
  LocalStorageService get _localStorageService => LocalStorageService.locate;
  final _dialogService = DialogService.locate;
  final _firebaseStorageService = FirebaseStorageService.locate;
  final _householdService = HouseholdService.locate;
  final _imagePickerService = ImagePickerService.locate;
  final _themeService = ThemeService.locate;
  final _toastService = ToastService.locate;
  final _urlLauncherService = UrlLauncherService.locate;
  final _userProfileForm = UserProfileForm.locate;
  final _userProfileService = UserProfilesService.locate;
  final _userService = UserService.locate;

  /// Provides access to clipboard functionality.
  ClipboardService get _clipboardService => ClipboardService.locate;

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @override
  Future<void> initialise() async {
    await _checkEmailVerificationStatus();
    _authSubscription = _authService.currentUserStream.listen((_) {
      unawaited(_checkEmailVerificationStatus());
    });
    super.initialise();
  }

  @override
  Future<void> dispose() async {
    await _authSubscription?.cancel();
    _isEmailVerified.dispose();
    super.dispose();
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  final _showProfileImageButtons = Informer<bool>(false);
  final _isEmailVerified = Informer<bool>(true);
  StreamSubscription? _authSubscription;

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  /// Whether to show profile image editing buttons.
  ValueListenable<bool> get showProfileImageButtons => _showProfileImageButtons;

  /// Whether the user's email is verified.
  ValueListenable<bool> get isEmailVerified => _isEmailVerified;

  /// The name of the current household, or null if not available.
  String? get householdName => _householdService.householdDto?.name;

  /// The current user's household member information.
  ValueListenable<UserProfileDto?> get userProfileDto => _userProfileService.self;

  // 🏗 HELPERS ------------------------------------------------------------------------------- \\

  /// Hides the profile image editing buttons.
  void _hideProfileImageButtons() => _showProfileImageButtons.update(false);

  /// Checks and updates the email verification status.
  Future<void> _checkEmailVerificationStatus() async {
    final isVerified = await _authService.hasVerifiedEmail;
    _isEmailVerified.value = isVerified;
  }

  /// Shows a dialog for editing a text field.
  ///
  /// Displays a dialog with a text input field for editing user profile information.
  ///
  /// Parameters:
  /// - [formFieldConfig]: Configuration for the form field
  /// - [fieldValue]: Current value of the field
  /// - [title]: Dialog title
  /// - [message]: Dialog message
  /// - [iconLabelDto]: Field label
  /// - [hint]: Field hint text
  /// - [icon]: Icon to display with the field
  /// - [onSaveField]: Callback function when the field is saved
  Future<void> _showFieldEditDialog({
    required BuildContext context,
    required TFormFieldConfig<String> formFieldConfig,
    required String fieldValue,
    required String title,
    required String message,
    required IconLabelDto iconLabelDto,
    required String hint,
    required IconData icon,
    required Future<void> Function(String) onSaveField,
  }) async {
    formFieldConfig.updateValue(fieldValue);
    await _dialogService.showTextInputDialog(
      formFieldConfig: formFieldConfig,
      context: context,
      title: title,
      message: message,
      okButtonText: context.strings.save,
      iconLabelDto: iconLabelDto,
      formFieldHint: hint,
      leadingIcon: icon,
      onOkButtonPressed: (context) async {
        if (formFieldConfig.isValid) {
          final String nonNullValue = formFieldConfig.cValue ?? '';
          await onSaveField(nonNullValue);
          Navigator.of(context).pop();
        }
      },
      onClosePressed: (context) {
        formFieldConfig.updateValue('');
      },
    );
  }

  /// Shows a dialog for editing a multi-line text field.
  ///
  /// Displays a dialog with a text area input for editing longer text content
  /// like user biography.
  ///
  /// Parameters:
  /// - [formFieldConfig]: Configuration for the form field
  /// - [fieldValue]: Current value of the field
  /// - [title]: Dialog title
  /// - [message]: Dialog message
  /// - [iconLabelDto]: Field label
  /// - [hint]: Field hint text
  /// - [icon]: Icon to display with the field
  /// - [onSaveField]: Callback function when the field is saved
  Future<void> _showTextAreaFieldEditDialog({
    required BuildContext context,
    required TFormFieldConfig<String> formFieldConfig,
    required String fieldValue,
    required String title,
    required String message,
    required IconLabelDto iconLabelDto,
    required String hint,
    required Future<void> Function(String) onSaveField,
  }) async {
    formFieldConfig.updateValue(fieldValue);
    await _dialogService.showTextAreaInputDialog(
      leadingIcon: Icons.settings_rounded,
      formFieldConfig: formFieldConfig,
      context: context,
      title: title,
      message: message,
      okButtonText: context.strings.save,
      iconLabelDto: iconLabelDto,
      formFieldHint: hint,
      onOkButtonPressed: (context) async {
        if (formFieldConfig.isValid) {
          final String nonNullValue = formFieldConfig.cValue ?? '';
          await onSaveField(nonNullValue);
          context.tryPop();
        }
      },
      onClosePressed: (context) => formFieldConfig.silentReset(),
    );
  }

  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  /// Toggles between light and dark theme.
  void onToggleThemePressed() => _themeService.toggleThemeMode();

  /// Handles the logout process with confirmation.
  ///
  /// Shows a confirmation dialog and logs the user out if confirmed.
  Future<void> onLogoutPressed({required BuildContext context}) async {
    final shouldLogout = await gShowOkCancelDialog(
      title: context.strings.logout,
      message: context.strings.areYouSureYouWantToLogout,
      context: context,
    );

    if (shouldLogout == true) {
      await _authService.logout(context: context);
    }
  }

  /// Navigates to the verify email view from settings.
  void onVerifyEmailPressed() {
    CoreRouter.locate.pushVerifyEmailView(origin: VerifyEmailOrigin.settings);
  }

  /// Shows language selection sheet.
  ///
  /// Displays a bottom sheet with available language options.
  void onLanguagePressed({required BuildContext context}) {
    _sheetService.showBottomSheet(
      context: context,
      shadSheet: TRadioSheet<TSupportedLanguage>(
        selectables: TSupportedLanguage.values
            .map((e) => e.asSelectable(currentLanguage: _localStorageService.language))
            .toList(),
        onItemPressed: (item) => _onLanguageSaved(context: context, changedLanguage: item),
        currentValue: _localStorageService.language,
        title: context.strings.editLanguage,
      ),
    );
  }

  /// Handles language selection and updates app language.
  ///
  /// Updates the app's language setting and shows a confirmation toast.
  Future<void> _onLanguageSaved({
    required TSupportedLanguage changedLanguage,
    required BuildContext context,
  }) async {
    final current = _localStorageService.language;
    final didChange = current != changedLanguage;
    if (didChange) {
      await _languageService.updateLanguage(changedLanguage);
      _toastService.showToast(
        context: context,
        title: context.strings.languageChanged,
        subtitle: context.strings.languageChangedToSupportedLanguage(
          changedLanguage.label(currentLanguage: changedLanguage),
        ),
      );
    }
  }

  /// Toggles visibility of profile image editing buttons.
  void onProfileImagePressed() => _showProfileImageButtons.toggle();

  /// Handles the profile image update process.
  ///
  /// Takes a new profile image from camera or gallery, uploads it to storage,
  /// and updates the user profile.
  ///
  /// Parameters:
  /// - [context]: Current build context
  /// - [imageSource]: Source of the image (camera or gallery)
  Future<void> _showUpdateImageUI({
    required BuildContext context,
    required ImageSource imageSource,
  }) async {
    // Prevent multiple concurrent uploads
    if (gIsBusy) {
      log.debug('Busy state active, ignoring profile image update request');
      return;
    }

    try {
      // Set busy state at the beginning of the operation
      gSetBusy();
      log.debug('Starting profile image update: Image source=${imageSource.name}');

      // Verify user ID is available
      final userId = _userService.id;
      if (userId == null) {
        log.error('Failed to update profile image: User ID is null');
        _toastService.showToast(
          context: context,
          title: context.strings.somethingWentWrong,
          subtitle: context.strings.userIdNotFound,
        );
        return;
      }

      // Pick image from camera or gallery
      log.debug('Got user ID: $userId, picking image from ${imageSource.name}');
      final response = await _imagePickerService.pickImage(context: context, source: imageSource);

      if (response == null) {
        log.debug('No image selected, aborting profile image update');
        return;
      }

      // Handle image pick failure
      if (response.isFail) {
        log.error('Failed to pick image: ${response.message}');
        // Image picker already shows its own errors, no need for additional toast
        return;
      }

      // Image successfully picked
      final image = response.result;
      log.debug('Image picked successfully: ${image.path}');

      // Upload image directly using the enhanced method
      // No need for separate compression step as this is handled by uploadUserProfileImage
      log.debug('Uploading image to Firebase Storage');
      final uploadResponse = await _firebaseStorageService.uploadUserProfileImage(
        file: File(image.path), // Pass original file, compression handled internally
        userId: userId,
        onProgress: (progress) {
          // Show upload progress in logs
          log.debug('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
        },
      );

      // Handle upload failure
      if (uploadResponse == null) {
        log.error('Failed to upload image: Upload response is null');
        await gShowOkDialog(
          context: context,
          title: context.strings.somethingWentWrong,
          message: context.strings.failedToUploadImagePleaseTryAgainLater,
        );
        return;
      }

      // Upload successful, update profile with new image URL
      log.debug('Image uploaded successfully, updating profile');
      // Track the old image URL in case we need to revert or clean up later
      final oldImageUrl = _userProfileService.self.value?.imageUrl;
      if (oldImageUrl != null) {
        final truncatedLength = oldImageUrl.length > 40 ? 40 : oldImageUrl.length;
        log.debug(
          'Old image URL will be replaced: ${oldImageUrl.substring(0, truncatedLength)}...',
        );
      } else {
        log.debug('No previous image URL found');
      }

      // Update user profile with new image URL
      final updateResponse = await _userProfileService.updateProfileImage(
        userId: userId,
        imageUrl: uploadResponse,
      );

      // Handle profile update result
      updateResponse.when(
        success: (s) {
          log.debug('Profile image updated successfully');
          gShowNotification(title: context.strings.imageUploaded, context: context);
        },
        fail: (f) {
          log.error('Failed to update profile with new image: ${f.message}');
          gShowOkDialog(
            context: context,
            title: context.strings.somethingWentWrong,
            message: context.strings.failedToUploadImagePleaseTryAgainLater,
          );
        },
      );
    } catch (error, stackTrace) {
      gSetIdle();
      log.error(
        'Unexpected error during profile image update: $error',
        error: error,
        stackTrace: stackTrace,
      );
      // Show error dialog to user
    } finally {
      // ALWAYS reset busy state, even if there are errors
      gSetIdle();
      log.debug('Profile image update process completed, busy state cleared');
    }
  }

  /// Shows dialog to edit email address.
  ///
  /// Displays a dialog for the user to update their email address.
  Future<void> onEmailPressed({
    required String userId,
    required String value,
    required BuildContext context,
  }) async => await _showFieldEditDialog(
    context: context,
    formFieldConfig: _userProfileForm.email,
    fieldValue: value == context.strings.addEmail ? '' : value,
    title: context.strings.email,
    message: context.strings.fillInYourEmail,
    iconLabelDto: IconLabelDto(icon: IconCollection.email, label: context.strings.email),
    hint: context.strings.emailHint,
    icon: Icons.email,
    onSaveField: (value) => onSave(context: context, email: value, userId: userId),
  );

  /// Shows dialog to edit phone number.
  ///
  /// Displays a dialog for the user to update their phone number.
  Future<void> onPhonePressed({
    required String userId,
    required String value,
    required BuildContext context,
  }) async {
    await _showFieldEditDialog(
      context: context,
      formFieldConfig: _userProfileForm.phone,
      fieldValue: value == context.strings.addPhoneNumber ? '' : value,
      title: context.strings.phone,
      message: context.strings.fillInYourPhoneNumber,
      iconLabelDto: IconLabelDto(icon: IconCollection.phone, label: context.strings.phone),
      hint: context.strings.phoneHint,
      icon: Icons.phone,
      onSaveField: (value) => onSave(context: context, phoneNumber: value, userId: userId),
    );
  }

  /// Shows dialog to edit display name.
  ///
  /// Displays a dialog for the user to update their display name.
  Future<void> onNamePressed({
    required String userId,
    required String value,
    required BuildContext context,
  }) async => await _showFieldEditDialog(
    context: context,
    formFieldConfig: _userProfileForm.name,
    fieldValue: value,
    title: context.strings.name,
    message: context.strings.thisFieldIsRequired,
    iconLabelDto: IconLabelDto(icon: IconCollection.name, label: context.strings.name),
    hint: context.strings.name,
    icon: Icons.person,
    onSaveField: (value) => onSave(context: context, name: value, userId: userId),
  );

  /// Shows dialog to edit link in bio.
  ///
  /// Displays a dialog for the user to update their profile link.
  Future<void> onLinkInBioPressed({
    required String userId,
    required String value,
    required BuildContext context,
  }) async => await _showFieldEditDialog(
    context: context,
    formFieldConfig: _userProfileForm.link,
    fieldValue: value == context.strings.addLink ? '' : value,
    title: context.strings.link,
    message: context.strings.fillInYourLink,
    iconLabelDto: IconLabelDto(icon: IconCollection.url, label: context.strings.link),
    hint: context.strings.linkHint,
    icon: Icons.link,
    onSaveField: (value) => onSave(context: context, linkInBio: value, userId: userId),
  );

  /// Shows dialog to edit biography.
  ///
  /// Displays a dialog with a text area for the user to update their biography.
  Future<void> onBioPressed({
    required String userId,
    required String value,
    required BuildContext context,
  }) async => await _showTextAreaFieldEditDialog(
    context: context,
    formFieldConfig: _userProfileForm.bio,
    fieldValue: value,
    title: context.strings.biography,
    message: context.strings.fillInYourBiography,
    iconLabelDto: IconLabelDto(icon: IconCollection.bio, label: context.strings.biography),
    hint: context.strings.tellUsAboutYourself,
    onSaveField: (value) => onSave(context: context, bio: value, userId: userId),
  );

  /// Saves profile changes to the backend.
  ///
  /// Updates one or more profile fields and shows appropriate success/error messages.
  ///
  /// Parameters:
  /// - [email]: New email address (optional)
  /// - [phoneNumber]: New phone number (optional)
  /// - [linkInBio]: New profile link (optional)
  /// - [bio]: New biography (optional)
  /// - [name]: New display name (optional)
  Future<void> onSave({
    required String userId,
    required BuildContext context,
    String? email,
    String? phoneNumber,
    String? linkInBio,
    String? bio,
    String? name,
  }) async {
    try {
      final response = await _userProfileService.updateProfile(
        userId: userId,
        email: email == null
            ? null
            : _userProfileForm.email.isValid
            ? email
            : null,
        phoneNumber: phoneNumber == null
            ? null
            : _userProfileForm.phone.isValid
            ? phoneNumber
            : null,
        linkInBio: linkInBio == null
            ? null
            : _userProfileForm.link.isValid
            ? linkInBio
            : null,
        bio: bio == null
            ? null
            : _userProfileForm.bio.isValid
            ? bio
            : null,
        name: name == null
            ? null
            : _userProfileForm.name.isValid
            ? name
            : null,
      );

      if (response.isSuccess) {
        _toastService.showToast(
          context: context,
          title: context.strings.success,
          subtitle: context.strings.profileUpdatedSuccessfully,
        );
      } else {
        _toastService.showToast(
          context: context,
          title: context.strings.somethingWentWrong,
          subtitle: response.message ?? context.strings.anUnknownErrorOccurredPleaseTryAgainLater,
        );
      }
    } catch (error) {
      log.debug('Error updating profile: $error');
      _toastService.showToast(
        context: context,
        title: context.strings.somethingWentWrong,
        subtitle: context.strings.anUnknownErrorOccurredPleaseTryAgainLater,
      );
    }
  }

  /// Takes a new profile photo with the camera.
  ///
  /// Opens the device camera to capture a new profile picture.
  void onProfileCameraPressed(BuildContext context, HouseholdMember householdMember) {
    _showUpdateImageUI(context: context, imageSource: ImageSource.camera);
    _hideProfileImageButtons();
  }

  /// Selects a profile photo from the gallery.
  ///
  /// Opens the device gallery to choose a new profile picture.
  void onProfileGalleryPressed(BuildContext context, HouseholdMember householdMember) {
    _showUpdateImageUI(context: context, imageSource: ImageSource.gallery);
    _hideProfileImageButtons();
  }

  /// Copies the user's username to the clipboard.
  ///
  /// Shows a feedback toast when successful.
  void onCopySubtitlePressed(BuildContext context) {
    final username = userProfileDto.value?.username;
    if (username != null && username.trim().isNotEmpty) {
      _clipboardService.copy(
        value: username,
        feedbackTitle: context.strings.usernameCopied,
        context: context,
      );
    }
  }

  /// Navigates to the notification settings view.
  void onNotificationSettingsPressed() {
    CoreRouter.locate.pushNotificationSettingsView();
  }

  /// Opens the privacy policy in the browser.
  Future<void> onPrivacyPolicyPressed() async {
    try {
      await _urlLauncherService.tryLaunchUrl(url: kValuesPrivacyPolicyUrl);
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to open privacy policy URL',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Opens the terms of service in the browser.
  Future<void> onTermsPressed() async {
    try {
      await _urlLauncherService.tryLaunchUrl(url: kValuesTermsOfServiceUrl);
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to open terms of service URL',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Manages the account deletion process.
  ///
  /// Shows a confirmation dialog and opens the account deletion page if confirmed.
  Future<void> onDeleteAccountPressed({required BuildContext context}) async {
    try {
      final shouldDelete = await _dialogService.showOkCancelDialog(
        context: context,
        title: context.strings.deleteAccount,
        message: context.strings.areYouSureYouWantToProceedThisWillTake,
        okText: context.strings.deleteAccount,
        cancelText: context.strings.cancel,
      );

      if (shouldDelete == true) {
        await _urlLauncherService.tryLaunchUrl(url: kValuesDeleteAccountUrl);
      }
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to delete account',
        error: error,
        stackTrace: stackTrace,
      );
      await _dialogService.showSomethingWentWrongDialog(context: context);
    }
  }

  void onBackPressed({required BuildContext context}) => context.tryPop();

  /// Shows the feedback form.
  ///
  /// Opens the feedback form for users to submit their thoughts and suggestions.
  void onFeedbackPressed({required BuildContext context}) {
    try {
      gShowFeedback(context);
    } catch (error, stackTrace) {
      log.error(
        'Unexpected ${error.runtimeType} caught while trying to show feedback',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

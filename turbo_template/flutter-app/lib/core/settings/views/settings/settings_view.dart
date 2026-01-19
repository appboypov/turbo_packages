import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:roomy_mobile/auth/dtos/user_profile_dto.dart';
import 'package:roomy_mobile/auth/widgets/logout_button.dart';
import 'package:roomy_mobile/data/extensions/string_extension.dart';
import 'package:roomy_mobile/environment/globals/g_env.dart';
import 'package:roomy_mobile/households/models/household_member.dart';
import 'package:roomy_mobile/settings/views/settings_view_model.dart';
import 'package:roomy_mobile/settings/widgets/staging_environment_badge.dart';
import 'package:roomy_mobile/settings/widgets/t_settings_section.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/storage/providers/local_storage_provider.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/constants/t_widget.dart';
import 'package:roomy_mobile/ui/enums/emoji.dart';
import 'package:roomy_mobile/ui/extensions/color_extension.dart';
import 'package:roomy_mobile/ui/widgets/buttons/t_button.dart';
import 'package:roomy_mobile/ui/widgets/t_compact_user_card.dart';
import 'package:roomy_mobile/ui/widgets/t_flex.dart';
import 'package:roomy_mobile/ui/widgets/t_icon.dart';
import 'package:roomy_mobile/ui/widgets/t_margin.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';
import 'package:roomy_mobile/ui/widgets/t_row.dart';
import 'package:roomy_mobile/ui/widgets/t_scaffold.dart';
import 'package:roomy_mobile/ui/widgets/t_sliver_app_bar.dart';
import 'package:roomy_mobile/ui/widgets/t_sliver_body.dart';
import 'package:roomy_mobile/ui/widgets/t_trailing_arrow.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/settings/views/settings/settings_view_model.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_compact_user_card.dart';
import 'package:veto/data/models/base_view_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const String path = 'settings';

  @override
  Widget build(BuildContext context) => ViewModelBuilder<SettingsViewModel>(
    builder: (context, model, isInitialised, child) {
      if (!isInitialised) return TWidgets.nothing;

      return Semantics(
        identifier: 'settings_screen',
        child: LocalStorageProviderBuilder(
          builder: (context, localStorageService, child) {
            return TScaffold(
              child: ShadSonner(
                padding: EdgeInsets.symmetric(
                  horizontal: TSizes.appPadding * 1.5,
                  vertical: context.sizes.bottomSafeArea + TSizes.appPadding,
                ),
                child: TSliverBody(
                  appBar: TSliverAppBar(
                    emoji: Emoji.cog,
                    onBackPressed: model.onBackPressed,
                    title: context.strings.settings,
                    actions: [
                      // TButton(
                      //   onPressed: model.onToggleThemePressed,
                      //   child: const Icon(Icons.sunny),
                      // ),
                      LogoutButton(onPressed: model.onLogoutPressed),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (gIsStaging) const StagingEnvironmentBadge(),
                      ValueListenableBuilder<UserProfileDto?>(
                        valueListenable: model.userProfileDto,
                        builder: (context, userProfileDto, child) {
                          if (userProfileDto == null) return TWidgets.nothing;
                          final householdMember = HouseholdMember.fromUserProfileDto(
                            userProfileDto: userProfileDto,
                          );
                          return TMargin.horizontal(
                            child: ValueListenableBuilder(
                              valueListenable: model.showProfileImageButtons,
                              builder: (context, showProfileImageButtons, child) =>
                                  TCompactUserCard.fromHouseholdMember(
                                    onNamePressed: () => model.onNamePressed(
                                      context: context,
                                      userId: householdMember.id,
                                      value: householdMember.name ?? '',
                                    ),
                                    subtitle: householdMember.username?.withAtSign,
                                    householdMember: householdMember,
                                    onImagePressed: householdMember.isSelf
                                        ? () => model.onProfileImagePressed()
                                        : null,
                                    onProfileCameraPressed: householdMember.isSelf
                                        ? (context) =>
                                              model.onProfileCameraPressed(context, householdMember)
                                        : null,
                                    onProfileGalleryPressed: householdMember.isSelf
                                        ? (context) => model.onProfileGalleryPressed(
                                            context,
                                            householdMember,
                                          )
                                        : null,
                                    showProfileImageButtons: showProfileImageButtons,
                                    trailing: ShadIconButton.ghost(
                                      icon: const Icon(Icons.copy_rounded),
                                      onPressed: () => model.onCopySubtitlePressed(context),
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: model.isEmailVerified,
                        builder: (context, isEmailVerified, _) {
                          return TMargin.app(
                            bottom: 0,
                            child: TSettingsSection(
                              emoji: Emoji.gear,
                              title: context.strings.general,
                              description: context.strings.generalSettingsInTheApp,
                              iconData: Icons.house,
                              children: [
                                if (!isEmailVerified)
                                  Semantics(
                                    identifier: 'settings_verify_email',
                                    label: context.strings.verifyYourEmail,
                                    button: true,
                                    child: TButton.opacity(
                                      onPressed: model.onVerifyEmailPressed,
                                      child: TRow(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        spacing: TFlex.spacingDefault,
                                        children: [
                                          TIconContainer(
                                            iconData: Icons.email_outlined,
                                            size: 24,
                                            gradient: context.colors.warning.asGradient(),
                                            boxShadow: context.decorations.shadowButton,
                                          ),
                                          Expanded(
                                            child: Text(
                                              context.strings.verifyYourEmail,
                                              style: context.texts.h6,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: context.colors.warning.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.warning_amber_rounded,
                                                  size: 14,
                                                  color: context.colors.warning,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  context.strings.required,
                                                  style: context.texts.small.copyWith(
                                                    color: context.colors.warning,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const TTrailingArrow(),
                                        ],
                                      ),
                                    ),
                                  ),
                                Semantics(
                                  identifier: 'settings_feedback',
                                  label: context.strings.feedback,
                                  button: true,
                                  child: TButton.opacity(
                                    onPressed: () => model.onFeedbackPressed(context: context),
                                    child: TRow(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: TFlex.spacingDefault,
                                      children: [
                                        TIconContainer(
                                          iconData: Icons.feedback_outlined,
                                          size: 24,
                                          boxShadow: context.decorations.shadowButton,
                                        ),
                                        Expanded(
                                          child: Text(
                                            context.strings.feedback,
                                            style: context.texts.h6,
                                          ),
                                        ),
                                        const TTrailingArrow(),
                                      ],
                                    ),
                                  ),
                                ),
                                Semantics(
                                  identifier: 'settings_notifications',
                                  label: context.strings.notifications,
                                  button: true,
                                  child: TButton.opacity(
                                    onPressed: model.onNotificationSettingsPressed,
                                    child: TRow(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: TFlex.spacingDefault,
                                      children: [
                                        TIconContainer(
                                          iconData: Icons.notifications_outlined,
                                          size: 24,
                                          boxShadow: context.decorations.shadowButton,
                                        ),
                                        Expanded(
                                          child: Text(
                                            context.strings.notifications,
                                            style: context.texts.h6,
                                          ),
                                        ),
                                        const TTrailingArrow(),
                                      ],
                                    ),
                                  ),
                                ),
                                Semantics(
                                  identifier: 'settings_language',
                                  label: context.strings.language,
                                  button: true,
                                  child: TButton.opacity(
                                    onPressed: () => model.onLanguagePressed(context: context),
                                    child: TRow(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: TFlex.spacingDefault,
                                      children: [
                                        TIconContainer(
                                          iconData: Icons.accessibility,
                                          size: 24,
                                          boxShadow: context.decorations.shadowButton,
                                        ),
                                        Expanded(
                                          child: Text(
                                            context.strings.language,
                                            style: context.texts.h6,
                                          ),
                                        ),
                                        const TTrailingArrow(),
                                      ],
                                    ),
                                  ),
                                ),
                                Semantics(
                                  identifier: 'settings_privacy_policy',
                                  label: context.strings.privacyPolicy,
                                  button: true,
                                  child: TButton.opacity(
                                    onPressed: model.onPrivacyPolicyPressed,
                                    child: TRow(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: TFlex.spacingDefault,
                                      children: [
                                        TIconContainer(
                                          iconData: Icons.privacy_tip_outlined,
                                          size: 24,
                                          boxShadow: context.decorations.shadowButton,
                                        ),
                                        Expanded(
                                          child: Text(
                                            context.strings.privacyPolicy,
                                            style: context.texts.h6,
                                          ),
                                        ),
                                        const TTrailingArrow(),
                                      ],
                                    ),
                                  ),
                                ),
                                Semantics(
                                  identifier: 'settings_terms_of_service',
                                  label: context.strings.termsOfService,
                                  button: true,
                                  child: TButton.opacity(
                                    onPressed: model.onTermsPressed,
                                    child: TRow(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: TFlex.spacingDefault,
                                      children: [
                                        TIconContainer(
                                          iconData: Icons.description_outlined,
                                          size: 24,
                                          boxShadow: context.decorations.shadowButton,
                                        ),
                                        Expanded(
                                          child: Text(
                                            context.strings.termsOfService,
                                            style: context.texts.h6,
                                          ),
                                        ),
                                        const TTrailingArrow(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      TMargin.app(
                        child: TSettingsSection(
                          emoji: Emoji.warning,
                          title: context.strings.dangerZone,
                          description: context.strings.proceedWithCaution,
                          iconData: Icons.warning_rounded,
                          children: [
                            Semantics(
                              identifier: 'settings_delete_account',
                              label: context.strings.deleteAccount,
                              button: true,
                              child: TButton.opacity(
                                onPressed: () => model.onDeleteAccountPressed(context: context),
                                child: TRow(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: TFlex.spacingDefault,
                                  children: [
                                    TIconContainer(
                                      iconData: Icons.delete_forever_rounded,
                                      size: 24,
                                      gradient: context.colors.error.asGradient(),
                                      boxShadow: context.decorations.shadowButton,
                                    ),
                                    Expanded(
                                      child: Text(
                                        context.strings.deleteAccount,
                                        style: context.texts.h6,
                                      ),
                                    ),
                                    const TTrailingArrow(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
    viewModelBuilder: () => SettingsViewModel.locate,
  );
}

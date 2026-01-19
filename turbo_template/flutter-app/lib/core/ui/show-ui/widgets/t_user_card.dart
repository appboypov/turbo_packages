import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roomy_mobile/animations/widgets/shrinks.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';
import 'package:roomy_mobile/data/constants/k_values.dart';
import 'package:roomy_mobile/data/extensions/object_extension.dart';
import 'package:roomy_mobile/environment/globals/g_env.dart';
import 'package:roomy_mobile/feedback/services/toast_service.dart';
import 'package:roomy_mobile/households/models/household_member.dart';
import 'package:roomy_mobile/l10n/globals/g_strings.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/state/typedefs/context_def.dart';
import 'package:roomy_mobile/typography/extensions/text_style_extension.dart';
import 'package:roomy_mobile/ui/enums/character_activity.dart';
import 'package:roomy_mobile/ui/extensions/color_extension.dart';
import 'package:roomy_mobile/ui/models/icon_value_model.dart';
import 'package:roomy_mobile/ui/services/clipboard_service.dart';
import 'package:roomy_mobile/ui/widgets/buttons/t_button.dart';
import 'package:roomy_mobile/ui/widgets/buttons/t_icon_button.dart';
import 'package:roomy_mobile/ui/widgets/t_card.dart';
import 'package:roomy_mobile/ui/widgets/t_column.dart';
import 'package:roomy_mobile/ui/widgets/t_divider.dart';
import 'package:roomy_mobile/ui/widgets/t_gap.dart';
import 'package:roomy_mobile/ui/widgets/t_icon.dart';
import 'package:roomy_mobile/ui/widgets/t_icon_value_row.dart';
import 'package:roomy_mobile/ui/widgets/t_margin.dart';
import 'package:roomy_mobile/ui/widgets/t_mid_card.dart';
import 'package:roomy_mobile/ui/widgets/t_padding.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';
import 'package:roomy_mobile/ui/widgets/t_row.dart';
import 'package:roomy_mobile/utils/globals/g_random.dart';
import 'package:roomy_mobile/utils/globals/g_routing.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/shared/extensions/object_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/buttons/t_button.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_gap.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_margin.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_mid_card.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/tu_divider.dart';

class TUserCard extends StatelessWidget {
  const TUserCard({
    Key? key,
    required this.footer,
    required this.iconValues,
    required this.imageUrl,
    required this.subtitle,
    required this.title,
    this.borderRadius,
    this.onCopySubtitlePressed,
    this.onFooterPressed,
    this.onMorePressed,
    this.onProfileCameraPressed,
    this.onProfileGalleryPressed,
    this.onProfileImagePressed,
    this.onSubtitlePressed,
    this.onTitlePressed,
    this.showActionButtons = true,
    this.showProfileImageButtons = false,
    required this.isSelf,
    this.hideCard = false,
  }) : super(key: key);

  final BorderRadius? borderRadius;
  final ContextDef? onCopySubtitlePressed;
  final ContextDef? onFooterPressed;
  final ContextDef? onMorePressed;
  final ContextDef? onProfileCameraPressed;
  final ContextDef? onProfileGalleryPressed;
  final ContextDef? onProfileImagePressed;
  final ContextDef? onSubtitlePressed;
  final ContextDef? onTitlePressed;
  final String? footer;
  final String? imageUrl;
  final String? subtitle;
  final String? title;
  final bool showActionButtons;
  final bool showProfileImageButtons;
  final bool isSelf;
  final bool hideCard;

  final List<IconValueModel> iconValues;

  factory TUserCard.fromHouseholdMember({
    bool hideCard = false,
    BorderRadius? borderRadius,
    ContextDef? onCopySubtitlePressed,
    ContextDef? onTitlePressed,
    Future<void> Function({required String userId, required String value})? onBioPressed,
    Future<void> Function({required String userId, required String value})? onEmailPressed,
    Future<void> Function({required String userId, required String value})? onPhonePressed,
    Future<void> Function({required String userId, required String value})? onWebPressed,
    bool showActionButtons = true,
    bool showProfileImageButtons = false,
    ContextDef? onProfileImagePressed,
    required HouseholdMember householdMember,
    void Function(BuildContext context, HouseholdMember householdMember)? onProfileCameraPressed,
    void Function(BuildContext context, HouseholdMember householdMember)? onProfileGalleryPressed,
  }) {
    final isSelf = householdMember.isSelf;
    final userId = householdMember.id;
    return TUserCard(
      isSelf: isSelf,
      hideCard: hideCard,
      onProfileCameraPressed: onProfileCameraPressed == null
          ? null
          : (context) => onProfileCameraPressed(context, householdMember),
      onProfileGalleryPressed: onProfileGalleryPressed == null
          ? null
          : (context) => onProfileGalleryPressed(context, householdMember),
      onTitlePressed: onTitlePressed,
      onCopySubtitlePressed: onCopySubtitlePressed,
      title: householdMember.name?.trim().isNotEmpty == true
          ? householdMember.name
          : (householdMember.username?.trim().isNotEmpty == true ? householdMember.username : null),
      subtitle: householdMember.username,
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      showActionButtons: showActionButtons,
      iconValues: [
        IconValueModel(
          onPressed: householdMember.hasEmail || isSelf
              ? (value) =>
                    onEmailPressed?.call(userId: userId, value: value) ??
                    gLaunchAsEmail(value: value)
              : null,
          iconData: !isSelf || householdMember.hasEmail ? Icons.email_outlined : Icons.edit,
          value: householdMember.email?.trim().isNotEmpty == true
              ? householdMember.email!
              : gStrings.addEmail.butWhen(
                  !isSelf,
                  (cValue) => householdMember.hasEmail ? gStrings.email : kValuesHyphen,
                ),
        ),
        IconValueModel(
          iconData: !isSelf || householdMember.hasPhoneNumber ? Icons.phone_outlined : Icons.edit,
          value: householdMember.phoneNumber?.trim().isNotEmpty == true
              ? householdMember.phoneNumber!
              : gStrings.addPhoneNumber.butWhen(
                  !isSelf,
                  (cValue) => householdMember.hasPhoneNumber ? gStrings.phoneNumber : kValuesHyphen,
                ),
          onPressed: householdMember.hasPhoneNumber || isSelf
              ? (value) =>
                    onPhonePressed?.call(userId: userId, value: value) ??
                    gLaunchAsPhone(value: value)
              : null,
        ),
        IconValueModel(
          iconData: !isSelf || householdMember.hasLinkInBio ? Icons.public_outlined : Icons.edit,
          onPressed: householdMember.hasLinkInBio || isSelf
              ? (value) =>
                    onWebPressed?.call(userId: userId, value: value) ?? gLaunchAsWeb(value: value)
              : null,
          value: householdMember.linkInBio?.trim().isNotEmpty == true
              ? householdMember.linkInBio!
              : gStrings.addLink.butWhen(
                  !isSelf,
                  (cValue) => householdMember.hasLinkInBio ? gStrings.link : kValuesHyphen,
                ),
        ),
      ],
      footer: householdMember.bio,
      imageUrl: householdMember.imageUrl,
      onFooterPressed: onBioPressed != null
          ? (context) => onBioPressed(userId: userId, value: householdMember.bio)
          : null,
      onProfileImagePressed: onProfileImagePressed,
      showProfileImageButtons: showProfileImageButtons,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImageUrl = imageUrl != null;
    final tColumn = TColumn(
      spacing: 0,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            TMargin.card(
              bottom: 0,
              top: TSizes.cardPadding.butWhen(hideCard, (_) => 0),
              left: TSizes.cardPadding.butWhen(hideCard, (_) => 0),
              right: TSizes.cardPadding.butWhen(hideCard, (_) => 0),
              child: TRow(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TRow(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TButton(
                          onPressed: onProfileImagePressed == null
                              ? null
                              : () => onProfileImagePressed!(context),
                          child: Stack(
                            children: [
                              Container(
                                width: gConfig.sizesConfig.avatarSize,
                                height: gConfig.sizesConfig.avatarSize,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: context.colors.border,
                                    width: TSizes.borderWidth,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: context.decorations.shadowHard,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: switch (hasImageUrl) {
                                    true => CachedNetworkImage(
                                      imageUrl: imageUrl!,
                                      fit: BoxFit.cover,
                                      useOldImageOnUrlChange: false,
                                      maxHeightDiskCache: 250,
                                      memCacheHeight: 250,
                                      fadeOutDuration: TDurations.animation,
                                      fadeInDuration: TDurations.animation,
                                      progressIndicatorBuilder: (context, url, progress) =>
                                          CircularProgressIndicator(value: progress.progress),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                    false => Image.asset(
                                      gRandomProfileImageUrl(
                                        id: title ?? '',
                                        currentTheme: context.themeMode,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  },
                                ),
                              ),
                              if (onProfileCameraPressed != null)
                                Positioned.fill(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.camera_alt, size: 12),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Transform.translate(
                            offset: const Offset(0, 2),
                            child: TColumn(
                              spacing: 0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TButton.opacity(
                                  onPressed: onTitlePressed == null
                                      ? null
                                      : () => onTitlePressed!(context),
                                  child: TRow(
                                    spacing: 8,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          title ?? context.strings.unknown,
                                          style: context.texts.h4,
                                        ),
                                      ),
                                      if (onTitlePressed != null) ...[
                                        const TIconOld.small(Icons.edit_rounded),
                                      ],
                                    ],
                                  ),
                                ),
                                if (subtitle != null)
                                  Builder(
                                    builder: (context) {
                                      final row = Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: TRow(
                                          spacing: 6,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '@${subtitle!}',
                                                style: context.texts.small,
                                              ),
                                            ),
                                            if (onCopySubtitlePressed != null) ...[
                                              TIconOld.xSmall(
                                                Icons.copy_rounded,
                                                color: context.colors.subLabel,
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                      return onCopySubtitlePressed == null
                                          ? row
                                          : TButton.opacity(
                                              onPressed: () => onCopySubtitlePressed!(context),
                                              child: row,
                                            );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onMorePressed != null)
                    Builder(
                      builder: (context) => ShadIconButton.ghost(
                        icon: const Icon(Icons.more_horiz_rounded),
                        onPressed: () => onMorePressed!.call(context),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        SlideShrink(
          hideBuilder: (context, hideChild) => const SizedBox(height: TSizes.appPadding),
          show: showProfileImageButtons,
          lazyChild: () => TMargin(
            child: Row(
              children: [
                TMargin.horizontal(
                  multiplier: 0.5,
                  child: TRow(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TIconButton(
                        onPressed: () => onProfileCameraPressed!(context),
                        margin: EdgeInsets.zero,
                        iconData: Icons.camera_alt_rounded,
                        backgroundColor: context.colors.cardMidground,
                        tIconDecoration: TIconDecoration.background,
                        padding: const TPadding.horizontal(12),
                        boxShadow: const [],
                        iconColor: context.colors.cardMidground.onColor,
                        label: context.strings.camera,
                        size: 32,
                      ),
                      TIconButton(
                        onPressed: () => onProfileGalleryPressed!(context),
                        margin: EdgeInsets.zero,
                        label: context.strings.gallery,
                        padding: const TPadding.horizontal(12),
                        backgroundColor: context.colors.cardMidground,
                        boxShadow: const [],
                        tIconDecoration: TIconDecoration.background,
                        iconColor: context.colors.cardMidground.onColor,
                        size: 32,
                        iconData: Icons.photo_library_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const TDivider(),
        const TGap.card(multiplier: 0.5),
        TColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 0,
          children: [
            for (final iconValue in iconValues)
              Padding(
                padding: const EdgeInsets.only(left: TSizes.appPadding),
                child: TButton(
                  onPressed: () {
                    if (iconValue.value != kValuesHyphen) {
                      final fieldType = _getFieldTypeFromIcon(iconValue.iconData);
                      ToastService.locate.showToast(
                        context: context,
                        title: fieldType,
                        subtitle: iconValue.value,
                      );
                      iconValue.onPressed?.call(iconValue.value);
                    }
                  },
                  child: TRow(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TMargin.horizontal(
                          left: TSizes.cardPadding * (iconValue.value != kValuesHyphen ? 0.5 : 1),
                          child: TIconValueRow(
                            useCase: TIconValueUseCase.listItem,
                            iconValueModel: iconValue,
                          ),
                        ),
                      ),
                      if (iconValue.value != kValuesHyphen)
                        TMargin.right(
                          child: TIconButton(
                            iconData: Icons.copy_rounded,
                            size: 40,
                            tIconDecoration: TIconDecoration.transparant,
                            onPressed: () {
                              if (iconValue.value != kValuesHyphen) {
                                ClipboardService.locate.copy(
                                  value: iconValue.value,
                                  context: context,
                                );
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const TGap.app(multiplier: 0.5),
        const TDivider(),
        TMargin.card(
          bottom: TSizes.cardPadding.butWhen(hideCard, (_) => 0),
          left: TSizes.cardPadding.butWhen(hideCard, (_) => 0),
          top: 16.0.butWhen(hideCard, (_) => 0),
          right: TSizes.cardPadding.butWhen(hideCard, (_) => 0),
          child: TButton.opacity(
            onPressed: onFooterPressed != null ? () => onFooterPressed!(context) : null,
            child: TMidCard(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: TSizes.appPadding * 0.75,
                  bottom: TSizes.appPadding * 0.75,
                  left: TSizes.appPadding,
                  right: TSizes.appPadding,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        footer ?? gRandomBio(id: title ?? ''),
                        maxLines: 100,
                        style: context.texts.mono.withColor(context.colors.card.onColorBlackWhite),
                      ),
                    ),
                    if (onFooterPressed != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: TIconOld(
                          Icons.edit,
                          iconSize: IconSize.small,
                          color: context.colors.card.onColorBlackWhite,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
    return hideCard
        ? tColumn
        : TCard(
            icon: CharacterActivity.userManaging1,
            description: context.strings.userProfileCardDescription,
            padding: EdgeInsets.zero,
            borderRadius: borderRadius,
            child: tColumn,
          );
  }

  String _getFieldTypeFromIcon(IconData icon) {
    switch (icon) {
      case Icons.email_outlined:
        return gStrings.contactTypeEmail;
      case Icons.phone_outlined:
        return gStrings.contactTypePhoneNumber;
      case Icons.public_outlined:
        return gStrings.contactTypeLink;
      default:
        return gStrings.contactTypeUnknown;
    }
  }
}

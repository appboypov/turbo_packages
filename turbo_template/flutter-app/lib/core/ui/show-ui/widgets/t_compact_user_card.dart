import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roomy_mobile/animations/widgets/shrinks.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:roomy_mobile/data/extensions/date_time_extension.dart';
import 'package:roomy_mobile/environment/globals/g_env.dart';
import 'package:roomy_mobile/households/models/household_member.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/state/typedefs/context_def.dart';
import 'package:roomy_mobile/ui/enums/character_activity.dart';
import 'package:roomy_mobile/ui/extensions/color_extension.dart';
import 'package:roomy_mobile/ui/widgets/buttons/t_button.dart';
import 'package:roomy_mobile/ui/widgets/buttons/t_icon_button.dart';
import 'package:roomy_mobile/ui/widgets/t_card.dart';
import 'package:roomy_mobile/ui/widgets/t_icon.dart';
import 'package:roomy_mobile/ui/widgets/t_list_item.dart';
import 'package:roomy_mobile/ui/widgets/t_margin.dart';
import 'package:roomy_mobile/ui/widgets/t_padding.dart';
import 'package:roomy_mobile/ui/widgets/t_row.dart';
import 'package:roomy_mobile/utils/globals/g_random.dart';

class TCompactUserCard extends StatelessWidget {
  const TCompactUserCard({
    Key? key,
    required this.title,
    this.onNamePressed,
    this.memberSince,
    this.imageUrl,
    this.subtitle,
    this.trailing,
    this.onImagePressed,
    this.onProfileCameraPressed,
    this.onProfileGalleryPressed,
    this.showProfileImageButtons = false,
    this.isChecked = false,
    this.showCard = true,
  }) : super(key: key);

  final String? title;
  final String? subtitle;
  final DateTime? memberSince;
  final String? imageUrl;
  final Widget? trailing;
  final VoidCallback? onNamePressed;
  final VoidCallback? onImagePressed;
  final ContextDef? onProfileCameraPressed;
  final ContextDef? onProfileGalleryPressed;
  final bool showProfileImageButtons;
  final bool isChecked;
  final bool showCard;

  factory TCompactUserCard.fromHouseholdMember({
    required HouseholdMember householdMember,
    VoidCallback? onNamePressed,
    Widget? trailing,
    String? subtitle,
    VoidCallback? onImagePressed,
    ContextDef? onProfileCameraPressed,
    ContextDef? onProfileGalleryPressed,
    bool showProfileImageButtons = false,
    bool showCard = true,
  }) => TCompactUserCard(
    onNamePressed: onNamePressed,
    title: householdMember.name,
    showCard: showCard,
    subtitle: subtitle,
    memberSince: householdMember.memberSince,
    imageUrl: householdMember.imageUrl,
    trailing: trailing,
    onImagePressed: onImagePressed,
    onProfileCameraPressed: onProfileCameraPressed,
    onProfileGalleryPressed: onProfileGalleryPressed,
    showProfileImageButtons: showProfileImageButtons,
  );

  @override
  Widget build(BuildContext context) {
    final hasMemberSince = memberSince != null;
    final profileImage = Container(
      width: gConfig.sizesConfig.avatarSize,
      height: gConfig.sizesConfig.avatarSize,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.cardBorder, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: switch (imageUrl != null) {
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
            gRandomProfileImageUrl(id: title ?? '', currentTheme: context.themeMode),
            fit: BoxFit.cover,
          ),
        },
      ),
    );
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TListItem(
          spacing: 14,
          trailing: trailing == null ? [] : [trailing!],
          leading: [
            if (onImagePressed != null)
              TButton(
                onPressed: onImagePressed,
                child: Stack(
                  children: [
                    profileImage,
                    if (onProfileCameraPressed != null)
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 12,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              Stack(
                children: [
                  profileImage,
                  if (isChecked)
                    const Positioned.fill(child: Center(child: Icon(Icons.check_rounded))),
                ],
              ),
          ],
          title: title ?? context.strings.unknown,
          onTitlePressed: onNamePressed,
          trailingTitle: onNamePressed != null
              ? Icon(Icons.edit_rounded, size: 13, color: context.colors.icon)
              : null,
          subtitle:
              subtitle ??
              (hasMemberSince ? memberSince!.asMemberSinceString(context: context) : null),
        ),
        SlideShrink(
          alignment: Alignment.topCenter,
          show: showProfileImageButtons,
          child: Row(
            children: [
              Expanded(
                child: TMargin.top(
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
              ),
            ],
          ),
        ),
      ],
    );
    const padding = EdgeInsets.all(16);
    return showCard
        ? TCard(
            icon: CharacterActivity.userManaging2,
            title: context.strings.profile,
            description: context.strings.userProfileInformation,
            padding: padding,
            child: column,
          )
        : column;
  }
}

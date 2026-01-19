import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:roomy_mobile/data/constants/k_values.dart';
import 'package:roomy_mobile/data/globals/g_user_id.dart';
import 'package:roomy_mobile/environment/globals/g_env.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/ui/widgets/t_provider.dart';
import 'package:roomy_mobile/utils/globals/g_random.dart';

class TUserAvatar extends StatelessWidget {
  const TUserAvatar({
    Key? key,
    this.imageUrl,
    this.size,
  }) : super(key: key);

  final String? imageUrl;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final hasImageUrl = imageUrl != null && imageUrl!.isNotEmpty;
    return Container(
      width: size ?? gConfig.sizesConfig.avatarSize,
      height: size ?? gConfig.sizesConfig.avatarSize,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border, width: TSizes.borderWidth),
        borderRadius: BorderRadius.circular(10),
        boxShadow: context.decorations.shadowHard,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
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
            gRandomProfileImageUrl(id: gUserId ?? kValuesDeviceId, currentTheme: context.themeMode),
            fit: BoxFit.cover,
          ),
        },
      ),
    );
  }
}

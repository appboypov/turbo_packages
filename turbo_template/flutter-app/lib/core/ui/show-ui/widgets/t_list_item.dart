import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide DateFormat;
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_provider.dart';

class TListItem extends StatelessWidget {
  const TListItem({
    super.key,
    required this.title,
    this.leading = const [],
    this.subtitle,
    this.isEmpty = false,
    this.trailing = const [],
    this.spacing = TSizes.itemGap,
    this.onPressed,
    this.onTrailingArrowPressed,
    this.onTitlePressed,
    this.trailingTitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> leading;
  final List<Widget> trailing;
  final double spacing;
  final VoidCallback? onPressed;
  final VoidCallback? onTrailingArrowPressed;
  final VoidCallback? onTitlePressed;
  final Widget? trailingTitle;
  final bool isEmpty;

  factory TListItem.fromShoppingList({
    required ShoppingList shoppingList,
    required OnItemPressedDef<ShoppingList> onShoppingListPressed,
  }) {
    return TListItem(
      title: shoppingList.title,
      leading: const [
        TIconContainer(
          tIconDecoration: TIconDecoration.borderWithBackground,
          iconData: Icons.shopping_cart_rounded,
        ),
      ],
      subtitle: shoppingList.subtitle,
      onPressed: () => onShoppingListPressed(shoppingList),
      onTrailingArrowPressed: () => onShoppingListPressed(shoppingList),
    );
  }

  factory TListItem.fromCleaningTaskShort({
    required RecurrenceService recurrenceService,
    required CleaningTaskDto cleaningTask,
    required OnItemPressedDef<CleaningTaskDto> onTaskPressed,
    required BuildContext context,
  }) {
    // Calculate next due date for minimal subtitle
    final nextDueDate = recurrenceService.calculateNextDueDate(
      frequency: cleaningTask.frequency,
      cleaningTimeSpan: cleaningTask.cleaningTimeSpan,
      lastCompleted: cleaningTask.lastCompletedAt,
      createdAt: cleaningTask.createdAt,
    );
    final isOverDue = nextDueDate.isBefore(gNow);
    final dueDateText = isOverDue
        ? context.strings.overdue
        : context.strings.deadline.withTrailingColon(
            nextDueDate.asRelativeDeadlineString(context: context),
          );

    return TListItem(
      title: cleaningTask.name,
      subtitle: dueDateText,
      spacing: 16,
      leading: const [
        TIconContainer(
          tIconDecoration: TIconDecoration.borderWithBackground,
          iconData: Icons.cleaning_services_rounded,
        ),
      ],
      onPressed: () => onTaskPressed(cleaningTask),
      onTrailingArrowPressed: () => onTaskPressed(cleaningTask),
    );
  }

  factory TListItem.fromCleaningTask({
    required RecurrenceService recurrenceService,
    required CleaningTaskDto cleaningTask,
    required OnItemPressedDef<CleaningTaskDto> onTaskPressed,
    HouseholdMember? assignedMember,
    VoidCallback? onAssignPressed,
    VoidCallback? onClaimPressed,
    bool canAssign = false,
    bool canClaim = false,
  }) {
    // Create subtitle from description, assignment, or empty
    final List<String> subtitleParts = [];

    if (cleaningTask.description != null && cleaningTask.description!.trim().isNotEmpty) {
      final description = cleaningTask.description!.trim();
      const maxLength = 60;
      final truncatedDescription = description.length > maxLength
          ? '${description.substring(0, maxLength)}...'
          : description;
      subtitleParts.add(truncatedDescription);
    }

    if (assignedMember != null) {
      subtitleParts.add('${gStrings.assignedTo}: ${assignedMember.name ?? gStrings.unknown}');
    } else if (cleaningTask.assignedToUserId != null) {
      subtitleParts.add('${gStrings.assignedTo}: ${gStrings.unknown}');
    } else {
      subtitleParts.add(gStrings.unassigned);
    }

    // Add recurrence information
    if (cleaningTask.hasRecurrence) {
      subtitleParts.add('${gStrings.recurring}: ${cleaningTask.recurrenceDisplayText}');
    }

    // Add next due date if available
    final nextDueDate = recurrenceService.calculateNextDueDate(
      frequency: cleaningTask.frequency,
      cleaningTimeSpan: cleaningTask.cleaningTimeSpan,
      lastCompleted: cleaningTask.lastCompletedAt,
      createdAt: cleaningTask.createdAt,
    );
    final isOverDue = nextDueDate.isBefore(gNow);
    final formattedDate = nextDueDate.parseDateFormat(dateFormat: DateFormat.defaultValue);
    final dueDateText = isOverDue ? gStrings.overdue : gStrings.nextDue(formattedDate);
    subtitleParts.add(dueDateText);

    final subtitle = subtitleParts.join(' • ');

    return TListItem(
      title: cleaningTask.name,
      leading: [
        const TIconContainer(
          tIconDecoration: TIconDecoration.borderWithBackground,
          iconData: Icons.cleaning_services_rounded,
        ),
        // Show assigned member avatar if assigned
        if (assignedMember != null)
          Builder(
            builder: (context) => Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: context.colors.border, width: TSizes.borderWidth),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: assignedMember.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: assignedMember.imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            _DefaultAvatarWidget(name: assignedMember.name ?? ''),
                        placeholder: (context, url) =>
                            _DefaultAvatarWidget(name: assignedMember.name ?? ''),
                      )
                    : _DefaultAvatarWidget(name: assignedMember.name ?? ''),
              ),
            ),
          ),
      ],
      subtitle: subtitle,
      trailing: [
        // Recurrence indicator
        if (cleaningTask.hasRecurrence)
          Builder(
            builder: (context) => Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isOverDue
                    ? context.colors.destructive.withValues(alpha: 0.1)
                    : context.colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.refresh,
                size: 16,
                color: isOverDue ? context.colors.destructive : context.colors.primary,
              ),
            ),
          ),
        TSizeBadge(size: cleaningTask.taskSize, compact: true),
        // Assignment action button
        if (canAssign && onAssignPressed != null)
          ShadButton.outline(
            onPressed: withLightHaptic(onAssignPressed),
            size: ShadButtonSize.sm,
            child: Text(gStrings.assign),
          )
        else if (canClaim && onClaimPressed != null)
          ShadButton(
            onPressed: withMediumHaptic(onClaimPressed),
            size: ShadButtonSize.sm,
            child: Text(gStrings.claim),
          ),
      ],
      onPressed: () => onTaskPressed(cleaningTask),
      onTrailingArrowPressed: () => onTaskPressed(cleaningTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    final row = TRow(
      spacing: spacing,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final leadingItem in leading) leadingItem,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(2),
              if (onTitlePressed != null)
                TButton.opacity(
                  onPressed: onTitlePressed,
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: Text(title, style: context.texts.list.copyWith(height: 1))),
                      if (trailingTitle != null) ...[const SizedBox(width: 8), trailingTitle!],
                    ],
                  ),
                )
              else
                Text(title, style: context.texts.list.copyWith(height: 1)),
              const TGap(4),
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: isEmpty
                      ? context.texts.xMuted.copyWith(
                          height: 1,
                        )
                      : context.texts.xMuted.copyWith(height: 1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        ...trailing,
        if (onTrailingArrowPressed != null) ...[
          ShadIconButton.outline(
            onPressed: withSelectionHaptic(onTrailingArrowPressed),
            icon: const Icon(Icons.arrow_forward_rounded, size: TSizes.iconSizeX0p75),
            width: 32,
            height: 32,
          ),
        ],
      ],
    );
    return onPressed == null ? row : TButton.opacity(child: row, onPressed: onPressed);
  }
}

class TListItemAvatar extends TListItem {
  const TListItemAvatar({
    super.key,
    required super.title,
    super.subtitle,
    required this.avatar,
    super.trailing,
  });

  final CircleAvatar avatar;

  @override
  Widget build(BuildContext context) => TListItem(title: title, leading: [avatar]);
}

class _DefaultAvatarWidget extends StatelessWidget {
  const _DefaultAvatarWidget({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) => Image.asset(
    gRandomProfileImageUrl(id: name, currentTheme: context.themeMode),
    fit: BoxFit.cover,
  );
}

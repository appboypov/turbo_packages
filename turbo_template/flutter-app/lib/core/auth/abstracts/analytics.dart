import 'package:turbo_flutter_template/core/auth/abstracts/t_subjects.dart';
import 'package:turbolytics/turbolytics.dart';

abstract class Analytics extends TAnalytics {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\
  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\
  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  /// Holds an instance of TSubjects for easy access to subject strings.
  final subjects = TSubjects();

  /// parameters constructs a map of all analytics parameters for easy access and consistency.
  Map<String, Object> parameters({
    String? id,
    String? userId,
    String? oldSize,
    String? newSize,
    String? sizeChanged,
    String? assignedBy,
    String? assignedToUserId,
    int? taskCount,
    int? itemCount,
    String? itemName,
    String? itemType,
    String? viewName,
    String? buttonName,
    String? feature,
    String? action,
    double? frequency,
    String? isRecurring,
    String? isCompleted,
    bool? nameChanged,
    double? amount,
  }) => {
    if (id != null) 'id': id,
    if (userId != null) 'user_id': userId,
    if (oldSize != null) 'old_size': oldSize,
    if (newSize != null) 'new_size': newSize,
    if (sizeChanged != null) 'size_changed': sizeChanged,
    if (assignedBy != null) 'assigned_by': assignedBy,
    if (assignedToUserId != null) 'assigned_to_user_id': assignedToUserId,
    if (taskCount != null) 'task_count': taskCount,
    if (itemCount != null) 'item_count': itemCount,
    if (itemName != null) 'item_name': itemName,
    if (itemType != null) 'item_type': itemType,
    if (viewName != null) 'view_name': viewName,
    if (buttonName != null) 'button_name': buttonName,
    if (feature != null) 'feature': feature,
    if (action != null) 'action': action,
    if (frequency != null) 'frequency': frequency,
    if (isRecurring != null) 'is_recurring': isRecurring,
    if (isCompleted != null) 'is_completed': isCompleted,
    if (nameChanged != null) 'name_changed': nameChanged,
    if (amount != null) 'amount': amount,
  };

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\
}

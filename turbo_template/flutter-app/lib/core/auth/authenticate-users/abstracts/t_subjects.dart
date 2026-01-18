/// TSubjects defines the string constants used for analytics event subjects.
/// This is a global class used by all analytics implementations.
class TSubjects {
  // Authentication subjects
  final auth = 'auth';

  // Cleaning subjects
  final cleaningView = 'cleaning_view';
  final cleaningButton = 'cleaning_button';
  final cleaningTask = 'cleaning_task';
  final cleaningSubtask = 'cleaning_subtask';
  final cleaningSubtasks = 'cleaning_subtasks';
  final cleaningTaskRecurrence = 'cleaning_task_recurrence';

  // Household subjects
  final household = 'household';

  // Shopping subjects
  final shoppingList = 'shopping_list';
  final shoppingItem = 'shopping_item';

  // General subjects
  final button = 'button';
  final view = 'view';
  final item = 'item';

  // Payment subjects
  final payment = 'payment';
  final receipt = 'receipt';

  // Notification subjects
  final notificationBanner = 'notification_banner';
  final notificationConsentSheet = 'notification_consent_sheet';
  final notificationPermission = 'notification_permission';

  // User Properties
  final userLevel = 'user_level';
}

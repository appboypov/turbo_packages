import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of Strings
/// returned by `Strings.of(context)`.
///
/// Applications need to include `Strings.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Strings.localizationsDelegates,
///   supportedLocales: Strings.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the Strings.supportedLocales
/// property.
abstract class Strings {
  Strings(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings)!;
  }

  static const LocalizationsDelegate<Strings> delegate = _StringsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// No description provided for @aHousehold.
  ///
  /// In en, this message translates to:
  /// **'a household'**
  String get aHousehold;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @acceptingInviteWillRemoveYouFromCurrentHousehold.
  ///
  /// In en, this message translates to:
  /// **'This will remove you from \'{householdName}\'. Continue?'**
  String acceptingInviteWillRemoveYouFromCurrentHousehold(Object householdName);

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get accountCreated;

  /// No description provided for @accountCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Account creation failed'**
  String get accountCreationFailed;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addEmail.
  ///
  /// In en, this message translates to:
  /// **'Add email'**
  String get addEmail;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @addItemToList.
  ///
  /// In en, this message translates to:
  /// **'Add item to list'**
  String get addItemToList;

  /// No description provided for @addLink.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get addLink;

  /// No description provided for @addPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Add phone number'**
  String get addPhoneNumber;

  /// No description provided for @addRoomy.
  ///
  /// In en, this message translates to:
  /// **'Add Roomy'**
  String get addRoomy;

  /// No description provided for @addSubtask.
  ///
  /// In en, this message translates to:
  /// **'Add subtask'**
  String get addSubtask;

  /// No description provided for @addSubtaskHint.
  ///
  /// In en, this message translates to:
  /// **'Add a new subtask...'**
  String get addSubtaskHint;

  /// No description provided for @addSubtasksToBreakDownYourTask.
  ///
  /// In en, this message translates to:
  /// **'Add subtasks to break down your task into smaller steps'**
  String get addSubtasksToBreakDownYourTask;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @addedBy.
  ///
  /// In en, this message translates to:
  /// **'Added by'**
  String get addedBy;

  /// No description provided for @addedByUserOnDate.
  ///
  /// In en, this message translates to:
  /// **'Added by {user} on {date}'**
  String addedByUserOnDate(Object date, Object user);

  /// No description provided for @allItemsUnchecked.
  ///
  /// In en, this message translates to:
  /// **'All items unchecked'**
  String get allItemsUnchecked;

  /// No description provided for @allTasks.
  ///
  /// In en, this message translates to:
  /// **'All Tasks'**
  String get allTasks;

  /// No description provided for @allTasksDescription.
  ///
  /// In en, this message translates to:
  /// **'View all cleaning tasks in your household. You can claim unassigned tasks, see who\'s responsible for each task, and track the overall cleaning schedule'**
  String get allTasksDescription;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @alreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Already in use'**
  String get alreadyInUse;

  /// No description provided for @anErrorOccurredWhileTryingToLogoutPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while trying to logout. Please try again later.'**
  String get anErrorOccurredWhileTryingToLogoutPleaseTryAgain;

  /// No description provided for @anUnknownErrorOccurredPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again later.'**
  String get anUnknownErrorOccurredPleaseTryAgainLater;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @andCountMore.
  ///
  /// In en, this message translates to:
  /// **'+ {count} more'**
  String andCountMore(int count);

  /// No description provided for @anotherDayAnotherList.
  ///
  /// In en, this message translates to:
  /// **'Another day, another list.'**
  String get anotherDayAnotherList;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'apr'**
  String get apr;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'april'**
  String get april;

  /// No description provided for @areYouSureYouWantToDeclineThisInvite.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to decline this invite?'**
  String get areYouSureYouWantToDeclineThisInvite;

  /// No description provided for @areYouSureYouWantToDeleteThisImage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this image?'**
  String get areYouSureYouWantToDeleteThisImage;

  /// No description provided for @areYouSureYouWantToDeleteThisItem.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get areYouSureYouWantToDeleteThisItem;

  /// No description provided for @areYouSureYouWantToDeleteThisShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this shopping list?'**
  String get areYouSureYouWantToDeleteThisShoppingList;

  /// No description provided for @areYouSureYouWantToDeleteThisSubtask.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this subtask?'**
  String get areYouSureYouWantToDeleteThisSubtask;

  /// No description provided for @areYouSureYouWantToDeleteThisTask.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task?'**
  String get areYouSureYouWantToDeleteThisTask;

  /// No description provided for @areYouSureYouWantToLeaveThisHousehold.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this household?'**
  String get areYouSureYouWantToLeaveThisHousehold;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @areYouSureYouWantToProceedThisWillTake.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to proceed? This will take you to the delete account page.'**
  String get areYouSureYouWantToProceedThisWillTake;

  /// No description provided for @areYouSureYouWantToRemoveThisMember.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this member?'**
  String get areYouSureYouWantToRemoveThisMember;

  /// No description provided for @areYouSureYouWantToUnassignThisTask.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unassign this task?'**
  String get areYouSureYouWantToUnassignThisTask;

  /// No description provided for @areYouSureYouWantToUncheckAllItems.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to uncheck all items?'**
  String get areYouSureYouWantToUncheckAllItems;

  /// No description provided for @assign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assign;

  /// No description provided for @assigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assigned;

  /// No description provided for @assignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get assignedTo;

  /// No description provided for @assignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get assignment;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'aug'**
  String get aug;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'august'**
  String get august;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @beforeMovingOnTakeAMomentToReadHowWe.
  ///
  /// In en, this message translates to:
  /// **'Before moving on, take a moment to read how we protect your personal information.'**
  String get beforeMovingOnTakeAMomentToReadHowWe;

  /// No description provided for @bekijkSchema.
  ///
  /// In en, this message translates to:
  /// **'Check Schema'**
  String get bekijkSchema;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @bug.
  ///
  /// In en, this message translates to:
  /// **'{bug} Bug'**
  String bug(Object bug);

  /// No description provided for @bulkActions.
  ///
  /// In en, this message translates to:
  /// **'Bulk Actions'**
  String get bulkActions;

  /// No description provided for @byClickingContinue.
  ///
  /// In en, this message translates to:
  /// **'By clicking continue, you agree to our'**
  String get byClickingContinue;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelInvite.
  ///
  /// In en, this message translates to:
  /// **'Cancel Invite'**
  String get cancelInvite;

  /// No description provided for @areYouSureYouWantToCancelThisInvite.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this invite?'**
  String get areYouSureYouWantToCancelThisInvite;

  /// No description provided for @failedToCancelInvitePleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel invite right now, please try again later.'**
  String get failedToCancelInvitePleaseTryAgainLater;

  /// No description provided for @changeName.
  ///
  /// In en, this message translates to:
  /// **'Change Name'**
  String get changeName;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @checkAllTasksToClaimOrGetAssigned.
  ///
  /// In en, this message translates to:
  /// **'Check \'Schema\' to claim or assign.'**
  String get checkAllTasksToClaimOrGetAssigned;

  /// No description provided for @checkStatus.
  ///
  /// In en, this message translates to:
  /// **'Check Status'**
  String get checkStatus;

  /// No description provided for @checkYourSpamFolder.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find it? Check your spam or junk folder.'**
  String get checkYourSpamFolder;

  /// No description provided for @checkmarkSymbol.
  ///
  /// In en, this message translates to:
  /// **'✅'**
  String get checkmarkSymbol;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claim;

  /// No description provided for @claimTask.
  ///
  /// In en, this message translates to:
  /// **'Claim Task'**
  String get claimTask;

  /// No description provided for @claimTaskConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to claim this task? This will assign it to you.'**
  String get claimTaskConfirmationMessage;

  /// No description provided for @claimTaskConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Claim this task?'**
  String get claimTaskConfirmationTitle;

  /// No description provided for @cleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get cleaning;

  /// No description provided for @cleaningFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get cleaningFrequency;

  /// No description provided for @cleaningSchedule.
  ///
  /// In en, this message translates to:
  /// **'Cleaning Schedule'**
  String get cleaningSchedule;

  /// No description provided for @cleaningTaskDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get cleaningTaskDescription;

  /// No description provided for @cleaningTaskDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Brief overview of what needs to be done'**
  String get cleaningTaskDescriptionHint;

  /// No description provided for @cleaningTaskDescriptionMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Description can be at most 200 characters long.'**
  String get cleaningTaskDescriptionMaxLength;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number.'**
  String get enterValidNumber;

  /// No description provided for @cleaningTaskFrequencyMaxCount.
  ///
  /// In en, this message translates to:
  /// **'Frequency must be at most 100.'**
  String get cleaningTaskFrequencyMaxCount;

  /// No description provided for @cleaningTaskFrequencyMinCount.
  ///
  /// In en, this message translates to:
  /// **'Frequency must be at least 1.'**
  String get cleaningTaskFrequencyMinCount;

  /// No description provided for @cleaningTaskFrequencyRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get cleaningTaskFrequencyRequired;

  /// No description provided for @cleaningTaskInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get cleaningTaskInstructions;

  /// No description provided for @cleaningTaskInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Clean the shower, toilet, and sink'**
  String get cleaningTaskInstructionsHint;

  /// No description provided for @cleaningTaskInstructionsMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Instructions can be at most 200 characters long.'**
  String get cleaningTaskInstructionsMaxLength;

  /// No description provided for @cleaningTaskName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get cleaningTaskName;

  /// No description provided for @cleaningTaskNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Clean the bathroom'**
  String get cleaningTaskNameHint;

  /// No description provided for @cleaningTaskNameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Name can be at most 50 characters long.'**
  String get cleaningTaskNameMaxLength;

  /// No description provided for @cleaningTaskNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 1 character long.'**
  String get cleaningTaskNameMinLength;

  /// No description provided for @cleaningTaskSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get cleaningTaskSize;

  /// No description provided for @cleaningTaskSizeHint.
  ///
  /// In en, this message translates to:
  /// **'Select the effort level for this task'**
  String get cleaningTaskSizeHint;

  /// No description provided for @cleaningTaskSizeL.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get cleaningTaskSizeL;

  /// No description provided for @cleaningTaskSizeM.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get cleaningTaskSizeM;

  /// No description provided for @cleaningTaskSizeS.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get cleaningTaskSizeS;

  /// No description provided for @cleaningTaskSizeXl.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get cleaningTaskSizeXl;

  /// No description provided for @cleaningTaskSizeXs.
  ///
  /// In en, this message translates to:
  /// **'Extra Small'**
  String get cleaningTaskSizeXs;

  /// No description provided for @cleaningTaskTimespanRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get cleaningTaskTimespanRequired;

  /// No description provided for @cleaningTasksEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first cleaning task to get organized.'**
  String get cleaningTasksEmptySubtitle;

  /// No description provided for @cleaningTimespan.
  ///
  /// In en, this message translates to:
  /// **'Timespan'**
  String get cleaningTimespan;

  /// No description provided for @cleaningTimespanDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get cleaningTimespanDay;

  /// No description provided for @cleaningTimespanMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get cleaningTimespanMonth;

  /// No description provided for @cleaningTimespanWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get cleaningTimespanWeek;

  /// No description provided for @cleaningTimespanYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get cleaningTimespanYear;

  /// No description provided for @clickHereToLogin.
  ///
  /// In en, this message translates to:
  /// **'Click here to log in'**
  String get clickHereToLogin;

  /// No description provided for @clickToView.
  ///
  /// In en, this message translates to:
  /// **'Click to view'**
  String get clickToView;

  /// No description provided for @codeInvullen.
  ///
  /// In en, this message translates to:
  /// **'Join household'**
  String get codeInvullen;

  /// No description provided for @codeTonen.
  ///
  /// In en, this message translates to:
  /// **'Show Code'**
  String get codeTonen;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @completedByYou.
  ///
  /// In en, this message translates to:
  /// **'Completed by you'**
  String get completedByYou;

  /// No description provided for @components.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get components;

  /// No description provided for @configure.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get configure;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @core.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get core;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @createAndManageYourCleaningTasks.
  ///
  /// In en, this message translates to:
  /// **'Very important task details.'**
  String get createAndManageYourCleaningTasks;

  /// No description provided for @createShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Create Shopping List'**
  String get createShoppingList;

  /// No description provided for @createYourFirstHousehold.
  ///
  /// In en, this message translates to:
  /// **'Create your first household!'**
  String get createYourFirstHousehold;

  /// No description provided for @createdAtDateString.
  ///
  /// In en, this message translates to:
  /// **'Created at {dateString}'**
  String createdAtDateString(Object dateString);

  /// No description provided for @crossSymbol.
  ///
  /// In en, this message translates to:
  /// **'❌'**
  String get crossSymbol;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @databaseFailure.
  ///
  /// In en, this message translates to:
  /// **'Database Failure'**
  String get databaseFailure;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @dayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day of month'**
  String get dayOfMonth;

  /// No description provided for @dayOfMonthPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15'**
  String get dayOfMonthPlaceholder;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'dec'**
  String get dec;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'december'**
  String get december;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @declineInvite.
  ///
  /// In en, this message translates to:
  /// **'Decline Invite'**
  String get declineInvite;

  /// No description provided for @decrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decrease;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get deleteItem;

  /// No description provided for @deleteShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Delete Shopping List'**
  String get deleteShoppingList;

  /// No description provided for @deletingFailed.
  ///
  /// In en, this message translates to:
  /// **'Deleting failed'**
  String get deletingFailed;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @doYouWantToVisitThePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Do you want to visit the privacy policy?'**
  String get doYouWantToVisitThePrivacyPolicy;

  /// No description provided for @doYouWantToVisitTheTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Do you want to visit the terms of service?'**
  String get doYouWantToVisitTheTermsOfService;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @dragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get dragToReorder;

  /// No description provided for @dutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editItem;

  /// No description provided for @editLanguage.
  ///
  /// In en, this message translates to:
  /// **'Edit Language'**
  String get editLanguage;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editName;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @editShoppingListDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit shopping list details'**
  String get editShoppingListDetails;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @editYourShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Edit your shopping list'**
  String get editYourShoppingList;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get emailHint;

  /// No description provided for @emailNotYetVerified.
  ///
  /// In en, this message translates to:
  /// **'Email not yet verified'**
  String get emailNotYetVerified;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent'**
  String get emailSent;

  /// No description provided for @emailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email verified'**
  String get emailVerified;

  /// No description provided for @emptyPlaceholderAnEmptyList.
  ///
  /// In en, this message translates to:
  /// **'An empty list is a clear sky; what will you build?'**
  String get emptyPlaceholderAnEmptyList;

  /// No description provided for @emptyPlaceholderBlankCanvas.
  ///
  /// In en, this message translates to:
  /// **'A blank canvas awaits your masterpiece.'**
  String get emptyPlaceholderBlankCanvas;

  /// No description provided for @emptyPlaceholderEmptySpaces.
  ///
  /// In en, this message translates to:
  /// **'Empty spaces are just rooms for growth.'**
  String get emptyPlaceholderEmptySpaces;

  /// No description provided for @emptyPlaceholderNoEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries yet, but infinite potential.'**
  String get emptyPlaceholderNoEntries;

  /// No description provided for @emptyPlaceholderNotAVoid.
  ///
  /// In en, this message translates to:
  /// **'This is not a void, it\'s a stage.'**
  String get emptyPlaceholderNotAVoid;

  /// No description provided for @emptyPlaceholderNotSadJustEmpty.
  ///
  /// In en, this message translates to:
  /// **'Not sad, just empty.'**
  String get emptyPlaceholderNotSadJustEmpty;

  /// No description provided for @emptyPlaceholderNothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here but possibilities.'**
  String get emptyPlaceholderNothingHere;

  /// No description provided for @emptyPlaceholderTheEmptiness.
  ///
  /// In en, this message translates to:
  /// **'The emptiness you see is the space for your next achievement.'**
  String get emptyPlaceholderTheEmptiness;

  /// No description provided for @emptyPlaceholderTheEmptinessIsNotALack.
  ///
  /// In en, this message translates to:
  /// **'The emptiness is not a lack, but a space to fill.'**
  String get emptyPlaceholderTheEmptinessIsNotALack;

  /// No description provided for @emptyPlaceholderZeroItems.
  ///
  /// In en, this message translates to:
  /// **'Zero items, endless opportunity.'**
  String get emptyPlaceholderZeroItems;

  /// No description provided for @emptySubtasksMessage.
  ///
  /// In en, this message translates to:
  /// **'No subtasks yet. Add one above!'**
  String get emptySubtasksMessage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @enterADescriptionForYourShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Enter a description for your shopping list'**
  String get enterADescriptionForYourShoppingList;

  /// No description provided for @enterANameForYourShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for your shopping list'**
  String get enterANameForYourShoppingList;

  /// No description provided for @enterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterAValidEmail;

  /// No description provided for @enterDetailsToRegister.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to register'**
  String get enterDetailsToRegister;

  /// No description provided for @enterInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get enterInviteCode;

  /// No description provided for @enterTheNameForTheNewShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Enter the name for the new shopping list. This will be visible to all members.'**
  String get enterTheNameForTheNewShoppingList;

  /// No description provided for @enterTheNewNameForTheHouseholdThisWillBe.
  ///
  /// In en, this message translates to:
  /// **'Enter the new name for the household. This will be visible to all members.'**
  String get enterTheNewNameForTheHouseholdThisWillBe;

  /// No description provided for @enterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get enterValidPhoneNumber;

  /// No description provided for @enterValidURL.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get enterValidURL;

  /// No description provided for @enterValueBetween1And31.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 1 and 31'**
  String get enterValueBetween1And31;

  /// No description provided for @enterWhatWasExpectedAndWhatActuallyHappened.
  ///
  /// In en, this message translates to:
  /// **'Enter what was expected and what actually happened.'**
  String get enterWhatWasExpectedAndWhatActuallyHappened;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourIdeaForAnImprovementOrFeatureRequest.
  ///
  /// In en, this message translates to:
  /// **'Enter your idea for an improvement or feature request.'**
  String get enterYourIdeaForAnImprovementOrFeatureRequest;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorCreatingCleaningTask.
  ///
  /// In en, this message translates to:
  /// **'Error creating cleaning task'**
  String get errorCreatingCleaningTask;

  /// No description provided for @errorUpdatingCleaningTask.
  ///
  /// In en, this message translates to:
  /// **'Error updating cleaning task'**
  String get errorUpdatingCleaningTask;

  /// No description provided for @every.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get every;

  /// No description provided for @failedToAcceptInvitePleaseTryAgainLaterAndContact.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept invite, please try again later and contact us if the problem persists.'**
  String get failedToAcceptInvitePleaseTryAgainLaterAndContact;

  /// No description provided for @failedToAddItem.
  ///
  /// In en, this message translates to:
  /// **'Failed to add item'**
  String get failedToAddItem;

  /// No description provided for @failedToAddSubtask.
  ///
  /// In en, this message translates to:
  /// **'Failed to add subtask'**
  String get failedToAddSubtask;

  /// No description provided for @failedToAssignTaskPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to assign task. Please try again.'**
  String get failedToAssignTaskPleaseTryAgain;

  /// No description provided for @failedToCallCloudFunction.
  ///
  /// In en, this message translates to:
  /// **'Failed to call cloud function'**
  String get failedToCallCloudFunction;

  /// No description provided for @failedToClaimTaskPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to claim task. Please try again.'**
  String get failedToClaimTaskPleaseTryAgain;

  /// No description provided for @failedToCompleteTask.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete task'**
  String get failedToCompleteTask;

  /// No description provided for @failedToCreateCleaningTaskPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to create cleaning task, please try again later'**
  String get failedToCreateCleaningTaskPleaseTryAgainLater;

  /// No description provided for @failedToDeclineInviteRightNowPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to decline invite right now, please try again later and contact us if the problem persist.'**
  String get failedToDeclineInviteRightNowPleaseTryAgainLater;

  /// No description provided for @failedToDeleteImagePleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete image. Please try again later.'**
  String get failedToDeleteImagePleaseTryAgainLater;

  /// No description provided for @failedToDeleteItemPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete item. Please try again later.'**
  String get failedToDeleteItemPleaseTryAgainLater;

  /// No description provided for @failedToDeleteShoppingListPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete shopping list. Please try again later.'**
  String get failedToDeleteShoppingListPleaseTryAgainLater;

  /// No description provided for @failedToDeleteSubtask.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete subtask'**
  String get failedToDeleteSubtask;

  /// No description provided for @failedToDeleteTaskPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete task. Please try again later.'**
  String get failedToDeleteTaskPleaseTryAgainLater;

  /// No description provided for @failedToLoadCleaningTasks.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cleaning tasks. Please try again.'**
  String get failedToLoadCleaningTasks;

  /// No description provided for @failedToLogIn.
  ///
  /// In en, this message translates to:
  /// **'Failed to log in'**
  String get failedToLogIn;

  /// No description provided for @failedToNavigateToAddTask.
  ///
  /// In en, this message translates to:
  /// **'Failed to navigate to add task. Please try again.'**
  String get failedToNavigateToAddTask;

  /// No description provided for @failedToNavigateToTask.
  ///
  /// In en, this message translates to:
  /// **'Failed to navigate to task. Please try again.'**
  String get failedToNavigateToTask;

  /// No description provided for @failedToRemoveMemberRightNowPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove member right now. Please try again later.'**
  String get failedToRemoveMemberRightNowPleaseTryAgainLater;

  /// No description provided for @failedToReorderItemsPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to reorder items, please try again.'**
  String get failedToReorderItemsPleaseTryAgain;

  /// No description provided for @failedToReorderSubtasks.
  ///
  /// In en, this message translates to:
  /// **'Failed to reorder subtasks'**
  String get failedToReorderSubtasks;

  /// No description provided for @failedToSelectImagePleaseTryAgainIfTheProblem.
  ///
  /// In en, this message translates to:
  /// **'Failed to select image. Please try again. If the problem persists, please contact support.'**
  String get failedToSelectImagePleaseTryAgainIfTheProblem;

  /// No description provided for @failedToSendInvite.
  ///
  /// In en, this message translates to:
  /// **'Failed to send invite'**
  String get failedToSendInvite;

  /// No description provided for @failedToShowAssignmentOptions.
  ///
  /// In en, this message translates to:
  /// **'Failed to show assignment options.'**
  String get failedToShowAssignmentOptions;

  /// No description provided for @failedToTakePhotoPleaseTryAgainIfTheProblem.
  ///
  /// In en, this message translates to:
  /// **'Failed to take photo. Please try again. If the problem persists, please contact support.'**
  String get failedToTakePhotoPleaseTryAgainIfTheProblem;

  /// No description provided for @failedToUnassignTaskPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to unassign task. Please try again.'**
  String get failedToUnassignTaskPleaseTryAgain;

  /// No description provided for @failedToUncheckAllItems.
  ///
  /// In en, this message translates to:
  /// **'Failed to uncheck all items'**
  String get failedToUncheckAllItems;

  /// No description provided for @failedToUncompleteTask.
  ///
  /// In en, this message translates to:
  /// **'Failed to uncomplete task'**
  String get failedToUncompleteTask;

  /// No description provided for @failedToUpdateCleaningTaskPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to update cleaning task, please try again later'**
  String get failedToUpdateCleaningTaskPleaseTryAgainLater;

  /// No description provided for @failedToUpdateName.
  ///
  /// In en, this message translates to:
  /// **'Failed to update name'**
  String get failedToUpdateName;

  /// No description provided for @failedToUpdateShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Failed to update shopping list'**
  String get failedToUpdateShoppingList;

  /// No description provided for @failedToUpdateSubtask.
  ///
  /// In en, this message translates to:
  /// **'Failed to update subtask'**
  String get failedToUpdateSubtask;

  /// No description provided for @failedToUpdateTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Failed to update time slots'**
  String get failedToUpdateTimeSlots;

  /// No description provided for @failedToUploadImagePleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image. Please try again later.'**
  String get failedToUploadImagePleaseTryAgainLater;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'feb'**
  String get feb;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'february'**
  String get february;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @feedbackButton_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackButton_tooltip;

  /// No description provided for @feedbackSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted'**
  String get feedbackSubmitted;

  /// No description provided for @fillInYourBiography.
  ///
  /// In en, this message translates to:
  /// **'Fill in your biography'**
  String get fillInYourBiography;

  /// No description provided for @fillInYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Fill in your email'**
  String get fillInYourEmail;

  /// No description provided for @fillInYourEmailAddressAndWeWillSendYou.
  ///
  /// In en, this message translates to:
  /// **'Fill in your email address.'**
  String get fillInYourEmailAddressAndWeWillSendYou;

  /// No description provided for @fillInYourLink.
  ///
  /// In en, this message translates to:
  /// **'Fill in your link'**
  String get fillInYourLink;

  /// No description provided for @fillInYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Fill in your phone number'**
  String get fillInYourPhoneNumber;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @frequencyCountPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2'**
  String get frequencyCountPlaceholder;

  /// No description provided for @frequencyMode.
  ///
  /// In en, this message translates to:
  /// **'Times per period'**
  String get frequencyMode;

  /// No description provided for @frequencyModeExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., \"2 times per week\" or \"4 times per month\"'**
  String get frequencyModeExample;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'fri'**
  String get fri;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'friday'**
  String get friday;

  /// No description provided for @friendsTeachUsTrustRoommatesTeachUsHarmony.
  ///
  /// In en, this message translates to:
  /// **'The chosen few.'**
  String get friendsTeachUsTrustRoommatesTeachUsHarmony;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @generalSettingsInTheApp.
  ///
  /// In en, this message translates to:
  /// **'General settings in the app.'**
  String get generalSettingsInTheApp;

  /// No description provided for @generateInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Generate Invite Code'**
  String get generateInviteCode;

  /// No description provided for @generatingInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Generating invite code...'**
  String get generatingInviteCode;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @helloUsername.
  ///
  /// In en, this message translates to:
  /// **'Hello @{username}'**
  String helloUsername(Object username);

  /// No description provided for @hiddenPass.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get hiddenPass;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @household.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get household;

  /// No description provided for @householdCreated.
  ///
  /// In en, this message translates to:
  /// **'{householdName} created!'**
  String householdCreated(Object householdName);

  /// No description provided for @householdInvite.
  ///
  /// In en, this message translates to:
  /// **'Household Invite'**
  String get householdInvite;

  /// No description provided for @householdInvites.
  ///
  /// In en, this message translates to:
  /// **'Household Invites'**
  String get householdInvites;

  /// No description provided for @householdNameAdjectiveBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get householdNameAdjectiveBusy;

  /// No description provided for @householdNameAdjectiveCharming.
  ///
  /// In en, this message translates to:
  /// **'Charming'**
  String get householdNameAdjectiveCharming;

  /// No description provided for @householdNameAdjectiveCheerful.
  ///
  /// In en, this message translates to:
  /// **'Cheerful'**
  String get householdNameAdjectiveCheerful;

  /// No description provided for @householdNameAdjectiveComfy.
  ///
  /// In en, this message translates to:
  /// **'Comfy'**
  String get householdNameAdjectiveComfy;

  /// No description provided for @householdNameAdjectiveCozy.
  ///
  /// In en, this message translates to:
  /// **'Cozy'**
  String get householdNameAdjectiveCozy;

  /// No description provided for @householdNameAdjectiveCreative.
  ///
  /// In en, this message translates to:
  /// **'Creative'**
  String get householdNameAdjectiveCreative;

  /// No description provided for @householdNameAdjectiveCute.
  ///
  /// In en, this message translates to:
  /// **'Cute'**
  String get householdNameAdjectiveCute;

  /// No description provided for @householdNameAdjectiveFriendly.
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get householdNameAdjectiveFriendly;

  /// No description provided for @householdNameAdjectiveHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get householdNameAdjectiveHappy;

  /// No description provided for @householdNameAdjectiveInviting.
  ///
  /// In en, this message translates to:
  /// **'Inviting'**
  String get householdNameAdjectiveInviting;

  /// No description provided for @householdNameAdjectiveLively.
  ///
  /// In en, this message translates to:
  /// **'Lively'**
  String get householdNameAdjectiveLively;

  /// No description provided for @householdNameAdjectiveModern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get householdNameAdjectiveModern;

  /// No description provided for @householdNameAdjectivePeaceful.
  ///
  /// In en, this message translates to:
  /// **'Peaceful'**
  String get householdNameAdjectivePeaceful;

  /// No description provided for @householdNameAdjectiveQuaint.
  ///
  /// In en, this message translates to:
  /// **'Quaint'**
  String get householdNameAdjectiveQuaint;

  /// No description provided for @householdNameAdjectiveQuiet.
  ///
  /// In en, this message translates to:
  /// **'Quiet'**
  String get householdNameAdjectiveQuiet;

  /// No description provided for @householdNameAdjectiveRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get householdNameAdjectiveRelaxed;

  /// No description provided for @householdNameAdjectiveRustic.
  ///
  /// In en, this message translates to:
  /// **'Rustic'**
  String get householdNameAdjectiveRustic;

  /// No description provided for @householdNameAdjectiveSecluded.
  ///
  /// In en, this message translates to:
  /// **'Secluded'**
  String get householdNameAdjectiveSecluded;

  /// No description provided for @householdNameAdjectiveSerene.
  ///
  /// In en, this message translates to:
  /// **'Serene'**
  String get householdNameAdjectiveSerene;

  /// No description provided for @householdNameAdjectiveShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get householdNameAdjectiveShared;

  /// No description provided for @householdNameAdjectiveSnug.
  ///
  /// In en, this message translates to:
  /// **'Snug'**
  String get householdNameAdjectiveSnug;

  /// No description provided for @householdNameAdjectiveSunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get householdNameAdjectiveSunny;

  /// No description provided for @householdNameAdjectiveTranquil.
  ///
  /// In en, this message translates to:
  /// **'Tranquil'**
  String get householdNameAdjectiveTranquil;

  /// No description provided for @householdNameAdjectiveVibrant.
  ///
  /// In en, this message translates to:
  /// **'Vibrant'**
  String get householdNameAdjectiveVibrant;

  /// No description provided for @householdNameAdjectiveWarm.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get householdNameAdjectiveWarm;

  /// No description provided for @householdNameMustBeAtLeast3CharactersLong.
  ///
  /// In en, this message translates to:
  /// **'Household name must be at least 3 characters long'**
  String get householdNameMustBeAtLeast3CharactersLong;

  /// No description provided for @householdNameMustBeAtMost50CharactersLong.
  ///
  /// In en, this message translates to:
  /// **'Household name must be at most 50 characters long'**
  String get householdNameMustBeAtMost50CharactersLong;

  /// No description provided for @householdNameNounAbode.
  ///
  /// In en, this message translates to:
  /// **'Abode'**
  String get householdNameNounAbode;

  /// No description provided for @householdNameNounBase.
  ///
  /// In en, this message translates to:
  /// **'Base'**
  String get householdNameNounBase;

  /// No description provided for @householdNameNounCabin.
  ///
  /// In en, this message translates to:
  /// **'Cabin'**
  String get householdNameNounCabin;

  /// No description provided for @householdNameNounCastle.
  ///
  /// In en, this message translates to:
  /// **'Castle'**
  String get householdNameNounCastle;

  /// No description provided for @householdNameNounCorner.
  ///
  /// In en, this message translates to:
  /// **'Corner'**
  String get householdNameNounCorner;

  /// No description provided for @householdNameNounCottage.
  ///
  /// In en, this message translates to:
  /// **'Cottage'**
  String get householdNameNounCottage;

  /// No description provided for @householdNameNounCrew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get householdNameNounCrew;

  /// No description provided for @householdNameNounDen.
  ///
  /// In en, this message translates to:
  /// **'Den'**
  String get householdNameNounDen;

  /// No description provided for @householdNameNounDwelling.
  ///
  /// In en, this message translates to:
  /// **'Dwelling'**
  String get householdNameNounDwelling;

  /// No description provided for @householdNameNounFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get householdNameNounFamily;

  /// No description provided for @householdNameNounHangout.
  ///
  /// In en, this message translates to:
  /// **'Hangout'**
  String get householdNameNounHangout;

  /// No description provided for @householdNameNounHaven.
  ///
  /// In en, this message translates to:
  /// **'Haven'**
  String get householdNameNounHaven;

  /// No description provided for @householdNameNounHeadquarters.
  ///
  /// In en, this message translates to:
  /// **'Headquarters'**
  String get householdNameNounHeadquarters;

  /// No description provided for @householdNameNounHideaway.
  ///
  /// In en, this message translates to:
  /// **'Hideaway'**
  String get householdNameNounHideaway;

  /// No description provided for @householdNameNounHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get householdNameNounHome;

  /// No description provided for @householdNameNounHub.
  ///
  /// In en, this message translates to:
  /// **'Hub'**
  String get householdNameNounHub;

  /// No description provided for @householdNameNounLodge.
  ///
  /// In en, this message translates to:
  /// **'Lodge'**
  String get householdNameNounLodge;

  /// No description provided for @householdNameNounNest.
  ///
  /// In en, this message translates to:
  /// **'Nest'**
  String get householdNameNounNest;

  /// No description provided for @householdNameNounOasis.
  ///
  /// In en, this message translates to:
  /// **'Oasis'**
  String get householdNameNounOasis;

  /// No description provided for @householdNameNounPad.
  ///
  /// In en, this message translates to:
  /// **'Pad'**
  String get householdNameNounPad;

  /// No description provided for @householdNameNounPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get householdNameNounPlace;

  /// No description provided for @householdNameNounRetreat.
  ///
  /// In en, this message translates to:
  /// **'Retreat'**
  String get householdNameNounRetreat;

  /// No description provided for @householdNameNounSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Sanctuary'**
  String get householdNameNounSanctuary;

  /// No description provided for @householdNameNounSpot.
  ///
  /// In en, this message translates to:
  /// **'Spot'**
  String get householdNameNounSpot;

  /// No description provided for @householdNameNounSquad.
  ///
  /// In en, this message translates to:
  /// **'Squad'**
  String get householdNameNounSquad;

  /// No description provided for @householdRequests.
  ///
  /// In en, this message translates to:
  /// **'Household Requests'**
  String get householdRequests;

  /// No description provided for @householdsThatYouHaveBeenInvitedTo.
  ///
  /// In en, this message translates to:
  /// **'Households that you have been invited to.'**
  String get householdsThatYouHaveBeenInvitedTo;

  /// No description provided for @householdsYouRequestedToJoin.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval from'**
  String get householdsYouRequestedToJoin;

  /// No description provided for @iAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the'**
  String get iAgreeToThe;

  /// No description provided for @idea.
  ///
  /// In en, this message translates to:
  /// **'{idea} Idea'**
  String idea(Object idea);

  /// No description provided for @ifRegisteredWeSend.
  ///
  /// In en, this message translates to:
  /// **'If {email} is registered with us, a password reset email has been sent.'**
  String ifRegisteredWeSend(Object email);

  /// No description provided for @imageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Image deleted'**
  String get imageDeleted;

  /// No description provided for @imageUploaded.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded'**
  String get imageUploaded;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'in {count} days'**
  String inDays(int count);

  /// No description provided for @inMonths.
  ///
  /// In en, this message translates to:
  /// **'in {count} months'**
  String inMonths(int count);

  /// No description provided for @inOneDay.
  ///
  /// In en, this message translates to:
  /// **'in 1 day'**
  String get inOneDay;

  /// No description provided for @inOneMonth.
  ///
  /// In en, this message translates to:
  /// **'in 1 month'**
  String get inOneMonth;

  /// No description provided for @inOnePlusWeek.
  ///
  /// In en, this message translates to:
  /// **'in 1+ week'**
  String get inOnePlusWeek;

  /// No description provided for @inWeeks.
  ///
  /// In en, this message translates to:
  /// **'In {inWeeks} Weeks'**
  String inWeeks(Object inWeeks);

  /// No description provided for @inWeeksPlus.
  ///
  /// In en, this message translates to:
  /// **'in {count}+ weeks'**
  String inWeeksPlus(int count);

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @increase.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increase;

  /// No description provided for @intervalMode.
  ///
  /// In en, this message translates to:
  /// **'Repeat every...'**
  String get intervalMode;

  /// No description provided for @intervalModeExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., \"Every 3 days\" or \"Every 2 weeks\"'**
  String get intervalModeExample;

  /// No description provided for @intervalValuePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3'**
  String get intervalValuePlaceholder;

  /// No description provided for @invalidDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day of month must be between 1 and 31'**
  String get invalidDayOfMonth;

  /// No description provided for @invalidFrequencyCount.
  ///
  /// In en, this message translates to:
  /// **'Frequency count must be greater than 0'**
  String get invalidFrequencyCount;

  /// No description provided for @invalidIntervalValue.
  ///
  /// In en, this message translates to:
  /// **'Interval value must be greater than 0'**
  String get invalidIntervalValue;

  /// No description provided for @invalidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get invalidQuantity;

  /// No description provided for @invalidTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Invalid Time Slot'**
  String get invalidTimeSlot;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @inviteAccepted.
  ///
  /// In en, this message translates to:
  /// **'Invite accepted!'**
  String get inviteAccepted;

  /// No description provided for @inviteCanceled.
  ///
  /// In en, this message translates to:
  /// **'Invite canceled!'**
  String get inviteCanceled;

  /// No description provided for @inviteCode.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get inviteCode;

  /// No description provided for @inviteCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied to clipboard'**
  String get inviteCodeCopied;

  /// No description provided for @inviteCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Check and try again.'**
  String get inviteCodeInvalid;

  /// No description provided for @inviteCodeMustBeExactly4Characters.
  ///
  /// In en, this message translates to:
  /// **'Code must be 4 characters'**
  String get inviteCodeMustBeExactly4Characters;

  /// No description provided for @inviteCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter code (4 characters)'**
  String get inviteCodeRequired;

  /// No description provided for @inviteDeclined.
  ///
  /// In en, this message translates to:
  /// **'Invite declined!'**
  String get inviteDeclined;

  /// No description provided for @inviteHouseholdMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter username to invite.'**
  String get inviteHouseholdMessage;

  /// No description provided for @inviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invite sent'**
  String get inviteSent;

  /// No description provided for @inviteSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invite sent'**
  String get inviteSentSuccessfully;

  /// No description provided for @invited.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get invited;

  /// No description provided for @invitesSentToOthersToJoinYourHousehold.
  ///
  /// In en, this message translates to:
  /// **'Invites sent to others to join your household.'**
  String get invitesSentToOthersToJoinYourHousehold;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @itemAdded.
  ///
  /// In en, this message translates to:
  /// **'Item added'**
  String get itemAdded;

  /// No description provided for @itemCompleted.
  ///
  /// In en, this message translates to:
  /// **'Item completed'**
  String get itemCompleted;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get itemDeleted;

  /// No description provided for @itemUncompleted.
  ///
  /// In en, this message translates to:
  /// **'Item uncompleted'**
  String get itemUncompleted;

  /// No description provided for @itemUpdated.
  ///
  /// In en, this message translates to:
  /// **'Item updated'**
  String get itemUpdated;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'jan'**
  String get jan;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'january'**
  String get january;

  /// No description provided for @joinHousehold.
  ///
  /// In en, this message translates to:
  /// **'Join Household'**
  String get joinHousehold;

  /// No description provided for @joinOrLeaveAHousehold.
  ///
  /// In en, this message translates to:
  /// **'Join or leave a household.'**
  String get joinOrLeaveAHousehold;

  /// No description provided for @joinRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Join Request Sent'**
  String get joinRequestSent;

  /// No description provided for @joinRequests.
  ///
  /// In en, this message translates to:
  /// **'Join Requests'**
  String get joinRequests;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'jul'**
  String get jul;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'july'**
  String get july;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'jun'**
  String get jun;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'june'**
  String get june;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @languageChangedToSupportedLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {supportedLanguage}'**
  String languageChangedToSupportedLanguage(Object supportedLanguage);

  /// No description provided for @lastUpdateAtString.
  ///
  /// In en, this message translates to:
  /// **'Last update at {lastUpdatedAtString}'**
  String lastUpdateAtString(Object lastUpdatedAtString);

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeek;

  /// No description provided for @lazyLoading.
  ///
  /// In en, this message translates to:
  /// **'Lazy Loading'**
  String get lazyLoading;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @leaveAndJoin.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveAndJoin;

  /// No description provided for @leaveCurrentHousehold.
  ///
  /// In en, this message translates to:
  /// **'Leave Current Household?'**
  String get leaveCurrentHousehold;

  /// No description provided for @leaveHousehold.
  ///
  /// In en, this message translates to:
  /// **'Leave household'**
  String get leaveHousehold;

  /// No description provided for @leaveJoin.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveJoin;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @linkHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. https://twitter.com/username'**
  String get linkHint;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loggedIn;

  /// No description provided for @loggedOut.
  ///
  /// In en, this message translates to:
  /// **'Logged out'**
  String get loggedOut;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginToAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to your {appName} account'**
  String loginToAccount(Object appName);

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed'**
  String get logoutFailed;

  /// No description provided for @mainShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Main Shopping List'**
  String get mainShoppingList;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @manageCleaningTask.
  ///
  /// In en, this message translates to:
  /// **'Manage Cleaning Task'**
  String get manageCleaningTask;

  /// No description provided for @manageHouseholdMembers.
  ///
  /// In en, this message translates to:
  /// **'Manage household members'**
  String get manageHouseholdMembers;

  /// No description provided for @managePendingInvitesToJoinADifferentHousehold.
  ///
  /// In en, this message translates to:
  /// **'Manage pending invites to join a different household'**
  String get managePendingInvitesToJoinADifferentHousehold;

  /// No description provided for @managePendingInvitesToJoinThisHousehold.
  ///
  /// In en, this message translates to:
  /// **'Manage pending invites to join this household.'**
  String get managePendingInvitesToJoinThisHousehold;

  /// No description provided for @manageYourHouseholdMembersAndSettings.
  ///
  /// In en, this message translates to:
  /// **'Home sweet home.'**
  String get manageYourHouseholdMembersAndSettings;

  /// No description provided for @manageYourShoppingListsAndItems.
  ///
  /// In en, this message translates to:
  /// **'Shopping made easy.'**
  String get manageYourShoppingListsAndItems;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'mar'**
  String get mar;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'march'**
  String get march;

  /// No description provided for @maxLengthExceeded.
  ///
  /// In en, this message translates to:
  /// **'Maximum length of {length} characters exceeded'**
  String maxLengthExceeded(int length);

  /// No description provided for @maximumHouseholdMembersReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of household members reached'**
  String get maximumHouseholdMembersReached;

  /// No description provided for @maximumHouseholdMembersReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'This household has reached its maximum member limit. Please contact the household owner if you believe this is an error.'**
  String get maximumHouseholdMembersReachedMessage;

  /// No description provided for @maximumSkipsReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum Skips Reached'**
  String get maximumSkipsReached;

  /// No description provided for @maximumValueExceeded.
  ///
  /// In en, this message translates to:
  /// **'Maximum value of {value} exceeded'**
  String maximumValueExceeded(double value);

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'may'**
  String get may;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @memberRemoved.
  ///
  /// In en, this message translates to:
  /// **'Member removed!'**
  String get memberRemoved;

  /// No description provided for @memberSinceCreatedAtString.
  ///
  /// In en, this message translates to:
  /// **'Member since {createdAtString}'**
  String memberSinceCreatedAtString(Object createdAtString);

  /// No description provided for @memberSinceDate.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String memberSinceDate(Object date);

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @messageMustBeLessThan500Characters.
  ///
  /// In en, this message translates to:
  /// **'Message must be less than 500 characters'**
  String get messageMustBeLessThan500Characters;

  /// No description provided for @minimumValueRequired.
  ///
  /// In en, this message translates to:
  /// **'Minimum value of {value} is required'**
  String minimumValueRequired(double value);

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @missingList.
  ///
  /// In en, this message translates to:
  /// **'Missing List'**
  String get missingList;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'mon'**
  String get mon;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'monday'**
  String get monday;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @myCleaningSchedule.
  ///
  /// In en, this message translates to:
  /// **'My Cleaning Schedule'**
  String get myCleaningSchedule;

  /// No description provided for @myHousehold.
  ///
  /// In en, this message translates to:
  /// **'My Household'**
  String get myHousehold;

  /// No description provided for @myInvites.
  ///
  /// In en, this message translates to:
  /// **'My Invites'**
  String get myInvites;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @myRoomies.
  ///
  /// In en, this message translates to:
  /// **'My Roomies'**
  String get myRoomies;

  /// No description provided for @myShoppingLists.
  ///
  /// In en, this message translates to:
  /// **'My Shopping Lists'**
  String get myShoppingLists;

  /// No description provided for @myTasks.
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get myTasks;

  /// No description provided for @myTasksDescription.
  ///
  /// In en, this message translates to:
  /// **'Here you can find all tasks assigned to you.'**
  String get myTasksDescription;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameCanBeAtMost.
  ///
  /// In en, this message translates to:
  /// **'Name can be at most {kLimitsMaxNameLength} characters long.'**
  String nameCanBeAtMost(Object kLimitsMaxNameLength);

  /// No description provided for @nameChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Name changed successfully'**
  String get nameChangedSuccessfully;

  /// No description provided for @nameMustBeLessThan50Characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be less than 50 characters'**
  String get nameMustBeLessThan50Characters;

  /// No description provided for @nextDeadline.
  ///
  /// In en, this message translates to:
  /// **'Next Deadline'**
  String get nextDeadline;

  /// No description provided for @nextDue.
  ///
  /// In en, this message translates to:
  /// **'Next due: {date}'**
  String nextDue(Object date);

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next Week'**
  String get nextWeek;

  /// No description provided for @noCleaningTasksYet.
  ///
  /// In en, this message translates to:
  /// **'No cleaning tasks yet!'**
  String get noCleaningTasksYet;

  /// No description provided for @noCount.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get noCount;

  /// No description provided for @noDeadline.
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get noDeadline;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @noHouseholdFound.
  ///
  /// In en, this message translates to:
  /// **'No Household Found'**
  String get noHouseholdFound;

  /// No description provided for @noHouseholdMembersAvailableForAssignment.
  ///
  /// In en, this message translates to:
  /// **'No household members available for assignment.'**
  String get noHouseholdMembersAvailableForAssignment;

  /// No description provided for @noInstructionsProvided.
  ///
  /// In en, this message translates to:
  /// **'No instructions provided'**
  String get noInstructionsProvided;

  /// No description provided for @noInviteCodeAvailable.
  ///
  /// In en, this message translates to:
  /// **'No invite code found, try again later!'**
  String get noInviteCodeAvailable;

  /// No description provided for @noRecurrence.
  ///
  /// In en, this message translates to:
  /// **'No recurrence'**
  String get noRecurrence;

  /// No description provided for @noResultsPlaceholderAnEmptyList.
  ///
  /// In en, this message translates to:
  /// **'An empty list is a prompt for new perspectives.'**
  String get noResultsPlaceholderAnEmptyList;

  /// No description provided for @noResultsPlaceholderConsiderADifferent.
  ///
  /// In en, this message translates to:
  /// **'Consider a different approach or term.'**
  String get noResultsPlaceholderConsiderADifferent;

  /// No description provided for @noResultsPlaceholderEmbraceThis.
  ///
  /// In en, this message translates to:
  /// **'Embrace this empty list as a moment of calm.'**
  String get noResultsPlaceholderEmbraceThis;

  /// No description provided for @noResultsPlaceholderInThisMoment.
  ///
  /// In en, this message translates to:
  /// **'In this moment, no results arise.'**
  String get noResultsPlaceholderInThisMoment;

  /// No description provided for @noResultsPlaceholderMaybeWhatYoureLooking.
  ///
  /// In en, this message translates to:
  /// **'Maybe what you\'re looking for is hidden in another perspective.'**
  String get noResultsPlaceholderMaybeWhatYoureLooking;

  /// No description provided for @noResultsPlaceholderNoAnswers.
  ///
  /// In en, this message translates to:
  /// **'No answers here.'**
  String get noResultsPlaceholderNoAnswers;

  /// No description provided for @noResultsPlaceholderNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches here. Reimagine your query.'**
  String get noResultsPlaceholderNoMatches;

  /// No description provided for @noResultsPlaceholderNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResultsPlaceholderNoResults;

  /// No description provided for @noResultsPlaceholderNothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found here.'**
  String get noResultsPlaceholderNothingFound;

  /// No description provided for @noResultsPlaceholderNothingMatched.
  ///
  /// In en, this message translates to:
  /// **'Nothing matched your query.'**
  String get noResultsPlaceholderNothingMatched;

  /// No description provided for @noResultsPlaceholderPerhapsItsTime.
  ///
  /// In en, this message translates to:
  /// **'Perhaps it\'s time to ask a different question.'**
  String get noResultsPlaceholderPerhapsItsTime;

  /// No description provided for @noResultsPlaceholderPerhapsItsTimeToTake.
  ///
  /// In en, this message translates to:
  /// **'Perhaps it\'s time to take a different route.'**
  String get noResultsPlaceholderPerhapsItsTimeToTake;

  /// No description provided for @noResultsPlaceholderPerhapsTheAnswer.
  ///
  /// In en, this message translates to:
  /// **'Perhaps the answer lies elsewhere.'**
  String get noResultsPlaceholderPerhapsTheAnswer;

  /// No description provided for @noResultsPlaceholderSeekInAnother.
  ///
  /// In en, this message translates to:
  /// **'Seek in another direction with sharper focus.'**
  String get noResultsPlaceholderSeekInAnother;

  /// No description provided for @noResultsPlaceholderTheOutcome.
  ///
  /// In en, this message translates to:
  /// **'The outcome is clear: nothing found. How will you adapt?'**
  String get noResultsPlaceholderTheOutcome;

  /// No description provided for @noResultsPlaceholderTheSearchIsOver.
  ///
  /// In en, this message translates to:
  /// **'The search is over, but the journey continues.'**
  String get noResultsPlaceholderTheSearchIsOver;

  /// No description provided for @noResultsPlaceholderTheSearchReveals.
  ///
  /// In en, this message translates to:
  /// **'The search reveals absence.'**
  String get noResultsPlaceholderTheSearchReveals;

  /// No description provided for @noRoomies.
  ///
  /// In en, this message translates to:
  /// **'No Roomies'**
  String get noRoomies;

  /// No description provided for @noTasksAssignedToYou.
  ///
  /// In en, this message translates to:
  /// **'No tasks assigned to you yet'**
  String get noTasksAssignedToYou;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @notAssignedToAnyone.
  ///
  /// In en, this message translates to:
  /// **'Not assigned to anyone.'**
  String get notAssignedToAnyone;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @notSadJustEmpty.
  ///
  /// In en, this message translates to:
  /// **'Not sad, just empty.'**
  String get notSadJustEmpty;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get notVerified;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'nov'**
  String get nov;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'november'**
  String get november;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'oct'**
  String get oct;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'october'**
  String get october;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @onceADay.
  ///
  /// In en, this message translates to:
  /// **'once a day'**
  String get onceADay;

  /// No description provided for @onceAMonth.
  ///
  /// In en, this message translates to:
  /// **'once a month'**
  String get onceAMonth;

  /// No description provided for @onceAWeek.
  ///
  /// In en, this message translates to:
  /// **'once a week'**
  String get onceAWeek;

  /// No description provided for @onceAYear.
  ///
  /// In en, this message translates to:
  /// **'once a year'**
  String get onceAYear;

  /// No description provided for @onetimeTask.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get onetimeTask;

  /// No description provided for @oops.
  ///
  /// In en, this message translates to:
  /// **'Oops'**
  String get oops;

  /// No description provided for @oopsSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong.'**
  String get oopsSomethingWentWrong;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @overdueDays.
  ///
  /// In en, this message translates to:
  /// **'overdue {count} days'**
  String overdueDays(int count);

  /// No description provided for @overdueOneDay.
  ///
  /// In en, this message translates to:
  /// **'overdue 1 day'**
  String get overdueOneDay;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordDoesNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Password does not match'**
  String get passwordDoesNotMatch;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @openEmail.
  ///
  /// In en, this message translates to:
  /// **'Open Email'**
  String get openEmail;

  /// No description provided for @pendingInvitations.
  ///
  /// In en, this message translates to:
  /// **'Pending Invitations'**
  String get pendingInvitations;

  /// No description provided for @peopleWhoWantToJoinYourHousehold.
  ///
  /// In en, this message translates to:
  /// **'People who want to join your household'**
  String get peopleWhoWantToJoinYourHousehold;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonth;

  /// No description provided for @perWeek.
  ///
  /// In en, this message translates to:
  /// **'per week'**
  String get perWeek;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. +1 555 555 5555'**
  String get phoneHint;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @pleaseCheckYourEmailToVerifyYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Please check your email to verify your account.'**
  String get pleaseCheckYourEmailToVerifyYourAccount;

  /// No description provided for @pleaseComeBackSoon.
  ///
  /// In en, this message translates to:
  /// **'Please come back soon!'**
  String get pleaseComeBackSoon;

  /// No description provided for @pleaseEnterAValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterAValidEmailAddress;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email.'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @pleaseLogInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please log in to continue.'**
  String get pleaseLogInToContinue;

  /// No description provided for @pleaseLoginToYourAppnameAccount.
  ///
  /// In en, this message translates to:
  /// **'Please login to your {appName} account'**
  String pleaseLoginToYourAppnameAccount(Object appName);

  /// No description provided for @pleaseReadAndAcceptOurPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Please read and accept our privacy policy'**
  String get pleaseReadAndAcceptOurPrivacyPolicy;

  /// No description provided for @pleaseRegisterToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please register to continue.'**
  String get pleaseRegisterToContinue;

  /// No description provided for @pleaseVerifyYourEmailAddressToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email address to continue.'**
  String get pleaseVerifyYourEmailAddressToContinue;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @postponedEmailVerificationUntilNextTime.
  ///
  /// In en, this message translates to:
  /// **'Postponed email verification until next time.'**
  String get postponedEmailVerificationUntilNextTime;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyAndTermsOfServiceAccepted.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy and terms of service accepted'**
  String get privacyPolicyAndTermsOfServiceAccepted;

  /// No description provided for @proceedWithCaution.
  ///
  /// In en, this message translates to:
  /// **'Proceed with caution.'**
  String get proceedWithCaution;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @quantityCannotBeNegative.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than zero'**
  String get quantityCannotBeNegative;

  /// No description provided for @rateLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'Wait {seconds}s.'**
  String rateLimitMessage(int seconds);

  /// No description provided for @readInstructions.
  ///
  /// In en, this message translates to:
  /// **'Read the instructions'**
  String get readInstructions;

  /// No description provided for @recurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get recurrence;

  /// No description provided for @repeatTaskAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Repeat task automatically'**
  String get repeatTaskAutomatically;

  /// No description provided for @recurrenceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Recurrence configuration is invalid'**
  String get recurrenceInvalid;

  /// No description provided for @recurrenceMode.
  ///
  /// In en, this message translates to:
  /// **'Recurrence Mode'**
  String get recurrenceMode;

  /// No description provided for @recurrenceOptionalDescription.
  ///
  /// In en, this message translates to:
  /// **'Set up recurring schedule for this task'**
  String get recurrenceOptionalDescription;

  /// No description provided for @recurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurring;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get removeMember;

  /// No description provided for @removeSubtask.
  ///
  /// In en, this message translates to:
  /// **'Remove subtask'**
  String get removeSubtask;

  /// No description provided for @reorderSubtasks.
  ///
  /// In en, this message translates to:
  /// **'Reorder subtasks'**
  String get reorderSubtasks;

  /// No description provided for @requestedToJoin.
  ///
  /// In en, this message translates to:
  /// **'requested to join'**
  String get requestedToJoin;

  /// No description provided for @requestsFromPeopleThatWantToJoinYourHousehold.
  ///
  /// In en, this message translates to:
  /// **'Requests from people that want to join your household.'**
  String get requestsFromPeopleThatWantToJoinYourHousehold;

  /// No description provided for @requestsThatYouHaveSentToJoinAHousehold.
  ///
  /// In en, this message translates to:
  /// **'Requests that you have sent to join a household.'**
  String get requestsThatYouHaveSentToJoinAHousehold;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordCooldownMessage.
  ///
  /// In en, this message translates to:
  /// **'You can request another reset email in {minutes} {minuteText} and {seconds} {secondText}'**
  String resetPasswordCooldownMessage(
    Object minuteText,
    Object minutes,
    Object secondText,
    Object seconds,
  );

  /// No description provided for @resetPasswordCooldownMessageSeconds.
  ///
  /// In en, this message translates to:
  /// **'You can request another reset email in {seconds} {secondText}'**
  String resetPasswordCooldownMessageSeconds(Object secondText, Object seconds);

  /// No description provided for @roomies.
  ///
  /// In en, this message translates to:
  /// **'Roomies'**
  String get roomies;

  /// No description provided for @theseAreYourRoommates.
  ///
  /// In en, this message translates to:
  /// **'The chosen few.'**
  String get theseAreYourRoommates;

  /// No description provided for @administration.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get administration;

  /// No description provided for @roomy.
  ///
  /// In en, this message translates to:
  /// **'Roomy'**
  String get roomy;

  /// No description provided for @roomy123.
  ///
  /// In en, this message translates to:
  /// **'Roomy123!'**
  String get roomy123;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'sat'**
  String get sat;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'saturday'**
  String get saturday;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveImage.
  ///
  /// In en, this message translates to:
  /// **'Save Image'**
  String get saveImage;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'second'**
  String get second;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @selectPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select period'**
  String get selectPeriod;

  /// No description provided for @selectWeekDays.
  ///
  /// In en, this message translates to:
  /// **'Select weekdays'**
  String get selectWeekDays;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'sep'**
  String get sep;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'september'**
  String get september;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @shareInviteCodeWithNewMembers.
  ///
  /// In en, this message translates to:
  /// **'Share this code with new members'**
  String get shareInviteCodeWithNewMembers;

  /// No description provided for @shareThisCodeWithNewMembers.
  ///
  /// In en, this message translates to:
  /// **'Share this code with new members'**
  String get shareThisCodeWithNewMembers;

  /// No description provided for @sharedShoppingLists.
  ///
  /// In en, this message translates to:
  /// **'Shared Shopping Lists'**
  String get sharedShoppingLists;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingList;

  /// No description provided for @shoppingListCreated.
  ///
  /// In en, this message translates to:
  /// **'Shopping list created'**
  String get shoppingListCreated;

  /// No description provided for @shoppingListDeleted.
  ///
  /// In en, this message translates to:
  /// **'Shopping list deleted'**
  String get shoppingListDeleted;

  /// No description provided for @shoppingListDescriptionCannotExceed200Characters.
  ///
  /// In en, this message translates to:
  /// **'Shopping list description cannot exceed 200 characters'**
  String get shoppingListDescriptionCannotExceed200Characters;

  /// No description provided for @shoppingListNameMustBeAtLeast3CharactersLong.
  ///
  /// In en, this message translates to:
  /// **'Shopping list name must be at least 3 characters long'**
  String get shoppingListNameMustBeAtLeast3CharactersLong;

  /// No description provided for @shoppingListNameMustBeAtMost50CharactersLong.
  ///
  /// In en, this message translates to:
  /// **'Shopping list name must be at most 50 characters long'**
  String get shoppingListNameMustBeAtMost50CharactersLong;

  /// No description provided for @shoppingListNotFound.
  ///
  /// In en, this message translates to:
  /// **'Shopping list not found'**
  String get shoppingListNotFound;

  /// No description provided for @shoppingListUpdated.
  ///
  /// In en, this message translates to:
  /// **'Shopping list updated'**
  String get shoppingListUpdated;

  /// No description provided for @shoppingLists.
  ///
  /// In en, this message translates to:
  /// **'Shopping Lists'**
  String get shoppingLists;

  /// No description provided for @shoppingOverview.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Shopping!'**
  String get shoppingOverview;

  /// No description provided for @shoppingOverviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Create and manage shared shopping lists with your roomies. Add items, check them off together, and ensure everyone is aware of what needs to be purchased.'**
  String get shoppingOverviewDescription;

  /// No description provided for @showInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Show Invite Code'**
  String get showInviteCode;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @somethingWentWrongPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later.'**
  String get somethingWentWrongPleaseTryAgainLater;

  /// No description provided for @somethingWentWrongWhileDeletingOldUsernamesPleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while deleting old usernames, please try again.'**
  String get somethingWentWrongWhileDeletingOldUsernamesPleaseTryAgain;

  /// No description provided for @somethingWentWrongWhileSavingTheImagePleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while saving the image. Please try again. If the problem persists, please contact support.'**
  String get somethingWentWrongWhileSavingTheImagePleaseTryAgain;

  /// No description provided for @somethingWentWrongWhileSortingTheItemsOurApologies.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while sorting the items, our apologies.'**
  String get somethingWentWrongWhileSortingTheItemsOurApologies;

  /// No description provided for @somethingWentWrongWhileTryingToCreateYourProfilePlease.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while trying to create your profile, please try again.'**
  String get somethingWentWrongWhileTryingToCreateYourProfilePlease;

  /// No description provided for @somethingWentWrongWhileTryingToLoadYourHouseholdPlease.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while trying to load your household, please restart the app and try again.'**
  String get somethingWentWrongWhileTryingToLoadYourHouseholdPlease;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @stranger.
  ///
  /// In en, this message translates to:
  /// **'stranger'**
  String get stranger;

  /// No description provided for @submittingFeedback.
  ///
  /// In en, this message translates to:
  /// **'Submitting feedback...'**
  String get submittingFeedback;

  /// No description provided for @subtaskAdded.
  ///
  /// In en, this message translates to:
  /// **'Subtask added'**
  String get subtaskAdded;

  /// No description provided for @subtaskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Subtask completed'**
  String get subtaskCompleted;

  /// No description provided for @subtaskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Subtask deleted'**
  String get subtaskDeleted;

  /// No description provided for @subtaskNameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Subtask name cannot exceed 100 characters'**
  String get subtaskNameMaxLength;

  /// No description provided for @subtaskNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Subtask name is required'**
  String get subtaskNameRequired;

  /// No description provided for @subtaskReordered.
  ///
  /// In en, this message translates to:
  /// **'Subtask reordered'**
  String get subtaskReordered;

  /// No description provided for @subtaskUncompleted.
  ///
  /// In en, this message translates to:
  /// **'Subtask uncompleted'**
  String get subtaskUncompleted;

  /// No description provided for @subtaskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Subtask updated'**
  String get subtaskUpdated;

  /// No description provided for @subtasks.
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get subtasks;

  /// No description provided for @breakTaskIntoSmallerSteps.
  ///
  /// In en, this message translates to:
  /// **'Break task into smaller steps'**
  String get breakTaskIntoSmallerSteps;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'sun'**
  String get sun;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'sunday'**
  String get sunday;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap to add'**
  String get tapToAdd;

  /// No description provided for @tapToAddItem.
  ///
  /// In en, this message translates to:
  /// **'Tap to add item'**
  String get tapToAddItem;

  /// No description provided for @tapToViewAndManageTheCleaningSchedule.
  ///
  /// In en, this message translates to:
  /// **'Tap to view and manage the cleaning schedule.'**
  String get tapToViewAndManageTheCleaningSchedule;

  /// No description provided for @taskAssignedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task assigned successfully'**
  String get taskAssignedSuccessfully;

  /// No description provided for @taskClaimedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task claimed successfully'**
  String get taskClaimedSuccessfully;

  /// No description provided for @taskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task completed'**
  String get taskCompleted;

  /// No description provided for @taskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get taskDeleted;

  /// No description provided for @taskDetails.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get taskDetails;

  /// No description provided for @taskManagement.
  ///
  /// In en, this message translates to:
  /// **'Task Management'**
  String get taskManagement;

  /// No description provided for @taskUnassignedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task unassigned successfully'**
  String get taskUnassignedSuccessfully;

  /// No description provided for @taskUncompleted.
  ///
  /// In en, this message translates to:
  /// **'Task uncompleted'**
  String get taskUncompleted;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @tasksAssignedToYouAndRecentlyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Tasks assigned to you.'**
  String get tasksAssignedToYouAndRecentlyCompleted;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself..'**
  String get tellUsAboutYourself;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get thankYou;

  /// No description provided for @thankYouAndWelcomeToRoomy.
  ///
  /// In en, this message translates to:
  /// **'Thank you and welcome to Roomy.'**
  String get thankYouAndWelcomeToRoomy;

  /// No description provided for @thankYouForSharingYourInsightsWithUsWeTruly.
  ///
  /// In en, this message translates to:
  /// **'Thank you for sharing your insights with us. We truly value your feedback and will use it to make the app even better. We appreciate your support!'**
  String get thankYouForSharingYourInsightsWithUsWeTruly;

  /// No description provided for @thankYouForYourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get thankYouForYourFeedback;

  /// No description provided for @theShoppingListHasGoneMissingReturningYouHomeLet.
  ///
  /// In en, this message translates to:
  /// **'The shopping list has gone missing! Returning you home.. let us know if this is a mistake.'**
  String get theShoppingListHasGoneMissingReturningYouHomeLet;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldIsRequired;

  /// No description provided for @thisIsCurrentlyUnderDevelopmentAndWillBeAvailableSoon.
  ///
  /// In en, this message translates to:
  /// **'This is currently under development and will be available soon.'**
  String get thisIsCurrentlyUnderDevelopmentAndWillBeAvailableSoon;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'thu'**
  String get thu;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'thursday'**
  String get thursday;

  /// No description provided for @timeSpan.
  ///
  /// In en, this message translates to:
  /// **'Time Span'**
  String get timeSpan;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get times;

  /// No description provided for @timesADay.
  ///
  /// In en, this message translates to:
  /// **'{count} times a day'**
  String timesADay(int count);

  /// No description provided for @timesAMonth.
  ///
  /// In en, this message translates to:
  /// **'{count} times a month'**
  String timesAMonth(int count);

  /// No description provided for @timesAWeek.
  ///
  /// In en, this message translates to:
  /// **'{count} times a week'**
  String timesAWeek(int count);

  /// No description provided for @timesAYear.
  ///
  /// In en, this message translates to:
  /// **'{count} times a year'**
  String timesAYear(int count);

  /// No description provided for @timesPerMonth.
  ///
  /// In en, this message translates to:
  /// **'times per month'**
  String get timesPerMonth;

  /// No description provided for @timesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'times per week'**
  String get timesPerWeek;

  /// No description provided for @titleMustBeAtLeast1CharacterLong.
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 1 character long.'**
  String get titleMustBeAtLeast1CharacterLong;

  /// No description provided for @toDo.
  ///
  /// In en, this message translates to:
  /// **'To Do'**
  String get toDo;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'tue'**
  String get tue;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'tuesday'**
  String get tuesday;

  /// No description provided for @unableToAcceptPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Unable to accept, please try again later.'**
  String get unableToAcceptPleaseTryAgainLater;

  /// No description provided for @unableToLogYouOut.
  ///
  /// In en, this message translates to:
  /// **'Unable to log you out'**
  String get unableToLogYouOut;

  /// No description provided for @unableToLogYouOutPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Unable to log you out, please try again later.'**
  String get unableToLogYouOutPleaseTryAgainLater;

  /// No description provided for @unassign.
  ///
  /// In en, this message translates to:
  /// **'Unassign'**
  String get unassign;

  /// No description provided for @unassignTask.
  ///
  /// In en, this message translates to:
  /// **'Unassign Task'**
  String get unassignTask;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @undoAllItems.
  ///
  /// In en, this message translates to:
  /// **'Undo all items'**
  String get undoAllItems;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get unknownError;

  /// No description provided for @unknownProfileWeWereUnableToFetchTheProfile.
  ///
  /// In en, this message translates to:
  /// **'Unknown profile. We were unable to fetch the profile.'**
  String get unknownProfileWeWereUnableToFetchTheProfile;

  /// No description provided for @unnamedTask.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Task'**
  String get unnamedTask;

  /// No description provided for @updateTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Update Time Slots'**
  String get updateTimeSlots;

  /// No description provided for @useAnInviteCodeToJoinAnExistingHousehold.
  ///
  /// In en, this message translates to:
  /// **'Use an invite code to join an existing household.'**
  String get useAnInviteCodeToJoinAnExistingHousehold;

  /// No description provided for @userIdNotFound.
  ///
  /// In en, this message translates to:
  /// **'User ID not found'**
  String get userIdNotFound;

  /// No description provided for @userIsAlreadyAMember.
  ///
  /// In en, this message translates to:
  /// **'User is already a member'**
  String get userIsAlreadyAMember;

  /// Error message shown when inviting a user who is already a household member.
  ///
  /// In en, this message translates to:
  /// **'{username} is already a member of this household. Would you like to add someone else?'**
  String userIsAlreadyAMemberMessage(String username);

  /// No description provided for @userIsAlreadyInvited.
  ///
  /// In en, this message translates to:
  /// **'User is already invited'**
  String get userIsAlreadyInvited;

  /// Error message shown when inviting a user who has already been invited to the household.
  ///
  /// In en, this message translates to:
  /// **'{username} has already been invited to this household. Would you like to invite someone else?'**
  String userIsAlreadyInvitedMessage(String username);

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// Error message shown when inviting a user to a household and the specified username cannot be found.
  ///
  /// In en, this message translates to:
  /// **'We could not find a user with the username {username}. Please check the username and try again.'**
  String userNotFoundForUsername(String username);

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameCopied.
  ///
  /// In en, this message translates to:
  /// **'Username copied'**
  String get usernameCopied;

  /// No description provided for @usernameFieldHint.
  ///
  /// In en, this message translates to:
  /// **'@roomydoe'**
  String get usernameFieldHint;

  /// No description provided for @usernameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameFieldLabel;

  /// No description provided for @usernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid username'**
  String get usernameInvalid;

  /// No description provided for @usernameInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Username can only contain alphanumeric characters, underscores, and periods.'**
  String get usernameInvalidFormat;

  /// No description provided for @usernameIsAlreadyInUsePleaseChooseADifferentOne.
  ///
  /// In en, this message translates to:
  /// **'Username is already in use, please choose a different one.'**
  String get usernameIsAlreadyInUsePleaseChooseADifferentOne;

  /// No description provided for @usernameIsAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'Username is already taken.'**
  String get usernameIsAlreadyTaken;

  /// No description provided for @usernameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be no more than 30 characters long.'**
  String get usernameMaxLength;

  /// No description provided for @usernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters long.'**
  String get usernameMinLength;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get usernameRequired;

  /// No description provided for @usernamesHousehold.
  ///
  /// In en, this message translates to:
  /// **'{username}\'s Household'**
  String usernamesHousehold(Object username);

  /// No description provided for @verificationEmailHasBeenResent.
  ///
  /// In en, this message translates to:
  /// **'Verification email has been resent.'**
  String get verificationEmailHasBeenResent;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent'**
  String get verificationEmailSent;

  /// No description provided for @verificationEmailSentCheckingAgainInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent,\nchecking again in {seconds} seconds'**
  String verificationEmailSentCheckingAgainInSeconds(Object seconds);

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyYourEmail;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @viewAllTasks.
  ///
  /// In en, this message translates to:
  /// **'View All Tasks'**
  String get viewAllTasks;

  /// No description provided for @viewCaps.
  ///
  /// In en, this message translates to:
  /// **'VIEW'**
  String get viewCaps;

  /// No description provided for @waitingForApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get waitingForApproval;

  /// No description provided for @waitingForInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Waiting for invite code...'**
  String get waitingForInviteCode;

  /// No description provided for @weEncounteredAnUnexpectedErrorPleaseTryAgainOrContact.
  ///
  /// In en, this message translates to:
  /// **'We encountered an unexpected error. Please try again or contact support if the issue persists.'**
  String get weEncounteredAnUnexpectedErrorPleaseTryAgainOrContact;

  /// No description provided for @weHaveResentTheVerificationEmailPleaseCheckYourInbox.
  ///
  /// In en, this message translates to:
  /// **'We have resent the verification email. Please check your inbox and try again.'**
  String get weHaveResentTheVerificationEmailPleaseCheckYourInbox;

  /// No description provided for @weNoticedYouHaveNotVerifiedYourEmailAddressYet.
  ///
  /// In en, this message translates to:
  /// **'We noticed you have not verified your email address yet, please check your inbox and follow the instructions to verify your email address.'**
  String get weNoticedYouHaveNotVerifiedYourEmailAddressYet;

  /// No description provided for @weTakeYourPrivacynverySerious.
  ///
  /// In en, this message translates to:
  /// **'We take your privacy\nvery serious'**
  String get weTakeYourPrivacynverySerious;

  /// No description provided for @weWereUnableToCheckTheTimeSlotPleaseReload.
  ///
  /// In en, this message translates to:
  /// **'We were unable to check the time slot. Please reload the app and try again.'**
  String get weWereUnableToCheckTheTimeSlotPleaseReload;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'wed'**
  String get wed;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'wednesday'**
  String get wednesday;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// No description provided for @weekDaysRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one weekday must be selected for weekly frequency'**
  String get weekDaysRequired;

  /// No description provided for @weeks.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get weeks;

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{inWeeks} Weeks Ago'**
  String weeksAgo(Object inWeeks);

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Roomy 🎉'**
  String get welcome;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re excited to help you organize your household! Through the button below you can read how to easily send feedback.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeToShoppingLists.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Shopping Lists 🛒'**
  String get welcomeToShoppingLists;

  /// No description provided for @welcomeToShoppingListsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create shared shopping lists with your household members. Add items, mark them as completed, and keep everyone organized!'**
  String get welcomeToShoppingListsSubtitle;

  /// No description provided for @whatNameSuitsYouBest.
  ///
  /// In en, this message translates to:
  /// **'What name suits you best?'**
  String get whatNameSuitsYouBest;

  /// No description provided for @whatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s New?'**
  String get whatsNew;

  /// No description provided for @wouldYouLikeToResendTheVerificationEmail.
  ///
  /// In en, this message translates to:
  /// **'Would you like to resend the verification email?'**
  String get wouldYouLikeToResendTheVerificationEmail;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @youCanOnlySkipEmailVerificationOnce.
  ///
  /// In en, this message translates to:
  /// **'You can only skip email verification once. Please verify your email to continue.'**
  String get youCanOnlySkipEmailVerificationOnce;

  /// No description provided for @youCannotDeleteTheMainShoppingList.
  ///
  /// In en, this message translates to:
  /// **'You cannot delete the main shopping list'**
  String get youCannotDeleteTheMainShoppingList;

  /// No description provided for @youHaveBeenInvited.
  ///
  /// In en, this message translates to:
  /// **'You have been invited!'**
  String get youHaveBeenInvited;

  /// No description provided for @youHaveBeenInvitedToJoinName.
  ///
  /// In en, this message translates to:
  /// **'You have been invited to join {name}!'**
  String youHaveBeenInvitedToJoinName(Object name);

  /// No description provided for @youHaveLeftTheHousehold.
  ///
  /// In en, this message translates to:
  /// **'You have left the household'**
  String get youHaveLeftTheHousehold;

  /// No description provided for @youWillNoLongerHaveAccessToThisHouseholdYou.
  ///
  /// In en, this message translates to:
  /// **'You have automatically joined your old household if you had one.'**
  String get youWillNoLongerHaveAccessToThisHouseholdYou;

  /// No description provided for @yourCurrentHousehold.
  ///
  /// In en, this message translates to:
  /// **'your current household'**
  String get yourCurrentHousehold;

  /// No description provided for @yourPasswordMustBeAtLeast8CharactersLong.
  ///
  /// In en, this message translates to:
  /// **'Your password must be at least 8 characters long.'**
  String get yourPasswordMustBeAtLeast8CharactersLong;

  /// No description provided for @yourRequestToJoinTheHouseholdHasBeenSent.
  ///
  /// In en, this message translates to:
  /// **'Your request to join the household has been sent. An admin will review it shortly.'**
  String get yourRequestToJoinTheHouseholdHasBeenSent;

  /// No description provided for @welcomeToRoomy.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Roomy!'**
  String get welcomeToRoomy;

  /// No description provided for @welcomeHome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Home'**
  String get welcomeHome;

  /// No description provided for @chooseAnOptionToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Choose an option to get started'**
  String get chooseAnOptionToGetStarted;

  /// No description provided for @createHousehold.
  ///
  /// In en, this message translates to:
  /// **'Create Household'**
  String get createHousehold;

  /// No description provided for @startAFreshHouseholdForYouAndYourRoomies.
  ///
  /// In en, this message translates to:
  /// **'Start a fresh household for you and your roomies'**
  String get startAFreshHouseholdForYouAndYourRoomies;

  /// No description provided for @useInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Use Invite Code'**
  String get useInviteCode;

  /// No description provided for @useYourInviteCodeToJoinAnExistingHousehold.
  ///
  /// In en, this message translates to:
  /// **'Use your invite code to join an existing household'**
  String get useYourInviteCodeToJoinAnExistingHousehold;

  /// No description provided for @joinHouseholdScan.
  ///
  /// In en, this message translates to:
  /// **'Scan to Join'**
  String get joinHouseholdScan;

  /// No description provided for @scanAQrCodeToJoinAnExistingHousehold.
  ///
  /// In en, this message translates to:
  /// **'Scan a QR code to join an existing household'**
  String get scanAQrCodeToJoinAnExistingHousehold;

  /// No description provided for @selectCaps.
  ///
  /// In en, this message translates to:
  /// **'SELECT'**
  String get selectCaps;

  /// No description provided for @scanToJoin.
  ///
  /// In en, this message translates to:
  /// **'Scan To Join'**
  String get scanToJoin;

  /// No description provided for @noPaymentsYet.
  ///
  /// In en, this message translates to:
  /// **'No payments yet!'**
  String get noPaymentsYet;

  /// No description provided for @createYourFirstPaymentToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Create your first payment to get started.'**
  String get createYourFirstPaymentToGetStarted;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'0,-'**
  String get amountPlaceholder;

  /// No description provided for @paymentSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment saved successfully'**
  String get paymentSavedSuccessfully;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @subjectHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Groceries, Utilities, etc.'**
  String get subjectHint;

  /// No description provided for @deletePayment.
  ///
  /// In en, this message translates to:
  /// **'Delete Payment'**
  String get deletePayment;

  /// No description provided for @deletePaymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this payment? This action cannot be undone.'**
  String get deletePaymentConfirmation;

  /// No description provided for @paymentDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment deleted successfully'**
  String get paymentDeletedSuccessfully;

  /// No description provided for @allPayments.
  ///
  /// In en, this message translates to:
  /// **'All Payments'**
  String get allPayments;

  /// No description provided for @paymentGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get paymentGeneral;

  /// No description provided for @paymentGeneralDescription.
  ///
  /// In en, this message translates to:
  /// **'Payment subject and general details.'**
  String get paymentGeneralDescription;

  /// No description provided for @paymentSection.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentSection;

  /// No description provided for @paymentSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Payment amount and financial details.'**
  String get paymentSectionDescription;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @receiptDescription.
  ///
  /// In en, this message translates to:
  /// **'Attach a receipt image for documentation.'**
  String get receiptDescription;

  /// No description provided for @deleteReceipt.
  ///
  /// In en, this message translates to:
  /// **'Delete Receipt'**
  String get deleteReceipt;

  /// No description provided for @deleteReceiptConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this receipt?'**
  String get deleteReceiptConfirmation;

  /// No description provided for @addReceipt.
  ///
  /// In en, this message translates to:
  /// **'Add Receipt'**
  String get addReceipt;

  /// No description provided for @receiptDeleted.
  ///
  /// In en, this message translates to:
  /// **'Receipt deleted'**
  String get receiptDeleted;

  /// No description provided for @receiptUploaded.
  ///
  /// In en, this message translates to:
  /// **'Receipt uploaded'**
  String get receiptUploaded;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to Gallery'**
  String get saveToGallery;

  /// No description provided for @imageSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery'**
  String get imageSavedToGallery;

  /// No description provided for @failedToDownloadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to download image'**
  String get failedToDownloadImage;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @paymentsOverview.
  ///
  /// In en, this message translates to:
  /// **'Payments Overview'**
  String get paymentsOverview;

  /// No description provided for @paymentsOverviewDescription.
  ///
  /// In en, this message translates to:
  /// **'You pay some, you owe some.'**
  String get paymentsOverviewDescription;

  /// No description provided for @paymentPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get paymentPeriodDay;

  /// No description provided for @paymentPeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get paymentPeriodWeek;

  /// No description provided for @paymentPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get paymentPeriodMonth;

  /// No description provided for @paymentPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get paymentPeriodYear;

  /// No description provided for @paymentPeriodAllTime.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get paymentPeriodAllTime;

  /// No description provided for @yourExpenses.
  ///
  /// In en, this message translates to:
  /// **'My Expenses'**
  String get yourExpenses;

  /// No description provided for @paymentCount.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentCount;

  /// No description provided for @paymentTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get paymentTotal;

  /// No description provided for @noPaymentsInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No payments in this period'**
  String get noPaymentsInPeriod;

  /// No description provided for @unableToEdit.
  ///
  /// In en, this message translates to:
  /// **'Unable to Edit'**
  String get unableToEdit;

  /// No description provided for @cannotEditPaymentsCreatedByOtherUsers.
  ///
  /// In en, this message translates to:
  /// **'You cannot edit payments created by other users'**
  String get cannotEditPaymentsCreatedByOtherUsers;

  /// No description provided for @viewOnlyMode.
  ///
  /// In en, this message translates to:
  /// **'View only - This payment was created by another user'**
  String get viewOnlyMode;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'receives'**
  String get paid;

  /// No description provided for @owes.
  ///
  /// In en, this message translates to:
  /// **'owes'**
  String get owes;

  /// No description provided for @youPaid.
  ///
  /// In en, this message translates to:
  /// **'You Paid'**
  String get youPaid;

  /// No description provided for @youOwe.
  ///
  /// In en, this message translates to:
  /// **'You Owe'**
  String get youOwe;

  /// No description provided for @viewPayments.
  ///
  /// In en, this message translates to:
  /// **'View Payments'**
  String get viewPayments;

  /// No description provided for @chartDescriptionSparklineNet.
  ///
  /// In en, this message translates to:
  /// **'Your net balance over time. Positive values mean others owe you, negative means you owe others.'**
  String get chartDescriptionSparklineNet;

  /// No description provided for @chartDescriptionPayerSharePie.
  ///
  /// In en, this message translates to:
  /// **'Who paid for expenses in this period. Shows the percentage breakdown by payer.'**
  String get chartDescriptionPayerSharePie;

  /// No description provided for @chartDescriptionRoommateNetBars.
  ///
  /// In en, this message translates to:
  /// **'Balance for each roommate. Green bars show what they are owed, red bars show what they owe.'**
  String get chartDescriptionRoommateNetBars;

  /// No description provided for @chartDescriptionHouseholdOverTime.
  ///
  /// In en, this message translates to:
  /// **'Total household spending per time bucket. Shows expense trends over the selected period.'**
  String get chartDescriptionHouseholdOverTime;

  /// No description provided for @participantValidationAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'At least one participant must be selected.'**
  String get participantValidationAtLeastOne;

  /// No description provided for @participantValidationSplitMustMatch.
  ///
  /// In en, this message translates to:
  /// **'Split total must match payment amount.'**
  String get participantValidationSplitMustMatch;

  /// No description provided for @participantValidationSplitCannotExceed.
  ///
  /// In en, this message translates to:
  /// **'Split total cannot exceed payment amount.'**
  String get participantValidationSplitCannotExceed;

  /// No description provided for @participantValidationShareGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Each participant must have a share greater than 0.'**
  String get participantValidationShareGreaterThanZero;

  /// No description provided for @participantValidationPercentagesMustTotal.
  ///
  /// In en, this message translates to:
  /// **'Split percentages must total 100%.'**
  String get participantValidationPercentagesMustTotal;

  /// No description provided for @participantValidationPercentagesCannotExceed.
  ///
  /// In en, this message translates to:
  /// **'Percentage total cannot exceed 100%.'**
  String get participantValidationPercentagesCannotExceed;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @noDataAvailableForTimeframe.
  ///
  /// In en, this message translates to:
  /// **'No data available for this timeframe, yet.'**
  String get noDataAvailableForTimeframe;

  /// No description provided for @participantValidationNoSplitWithoutParticipants.
  ///
  /// In en, this message translates to:
  /// **'Cannot have split method without participants'**
  String get participantValidationNoSplitWithoutParticipants;

  /// No description provided for @participantValidationCreatorMustParticipate.
  ///
  /// In en, this message translates to:
  /// **'Payment creator must be a participant'**
  String get participantValidationCreatorMustParticipate;

  /// No description provided for @participantValidationManualMustSumToTotal.
  ///
  /// In en, this message translates to:
  /// **'Manual amounts must sum to total'**
  String get participantValidationManualMustSumToTotal;

  /// No description provided for @participantValidationPercentagesMustSumTo100.
  ///
  /// In en, this message translates to:
  /// **'Percentages must sum to 100%'**
  String get participantValidationPercentagesMustSumTo100;

  /// No description provided for @chooseHouseholdMemberToAssignTask.
  ///
  /// In en, this message translates to:
  /// **'Choose a household member to assign this task to.'**
  String get chooseHouseholdMemberToAssignTask;

  /// No description provided for @paymentParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get paymentParticipants;

  /// No description provided for @paymentSplitMethod.
  ///
  /// In en, this message translates to:
  /// **'Split Method'**
  String get paymentSplitMethod;

  /// No description provided for @paymentSplit.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get paymentSplit;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @whoSharesThisExpense.
  ///
  /// In en, this message translates to:
  /// **'Who shares this expense?'**
  String get whoSharesThisExpense;

  /// No description provided for @howToSplitPayment.
  ///
  /// In en, this message translates to:
  /// **'How to split the payment'**
  String get howToSplitPayment;

  /// No description provided for @setAmountForSplitMethod.
  ///
  /// In en, this message translates to:
  /// **'Set amount for the split method.'**
  String get setAmountForSplitMethod;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get validationError;

  /// No description provided for @setTotalAmountDescription.
  ///
  /// In en, this message translates to:
  /// **'Set the total amount'**
  String get setTotalAmountDescription;

  /// No description provided for @youCreator.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youCreator;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'you'**
  String get you;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @userProfileInformation.
  ///
  /// In en, this message translates to:
  /// **'User profile information'**
  String get userProfileInformation;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get noItems;

  /// No description provided for @shoppedAndLoaded.
  ///
  /// In en, this message translates to:
  /// **'Shopped and loaded.'**
  String get shoppedAndLoaded;

  /// No description provided for @allTasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'All tasks completed'**
  String get allTasksCompleted;

  /// No description provided for @showThisToYourRoomy.
  ///
  /// In en, this message translates to:
  /// **'Send this to your roomy.'**
  String get showThisToYourRoomy;

  /// No description provided for @invalidCredentialsMessage.
  ///
  /// In en, this message translates to:
  /// **'The credentials provided are invalid, please try again.'**
  String get invalidCredentialsMessage;

  /// No description provided for @invalidCredentialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentialsTitle;

  /// No description provided for @networkErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Network Error'**
  String get networkErrorTitle;

  /// No description provided for @accountAlreadyInUseMessage.
  ///
  /// In en, this message translates to:
  /// **'The account is already in use, please try again.'**
  String get accountAlreadyInUseMessage;

  /// No description provided for @accountAlreadyInUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Account already in use'**
  String get accountAlreadyInUseTitle;

  /// No description provided for @invalidCredentialMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong verifying the credential, please try again.'**
  String get invalidCredentialMessage;

  /// No description provided for @invalidCredentialTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid credential'**
  String get invalidCredentialTitle;

  /// No description provided for @operationNotAllowedTitle.
  ///
  /// In en, this message translates to:
  /// **'Operation not allowed'**
  String get operationNotAllowedTitle;

  /// No description provided for @accountDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'The account corresponding to the credential is disabled, please try again.'**
  String get accountDisabledMessage;

  /// No description provided for @accountDisabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Account disabled'**
  String get accountDisabledTitle;

  /// No description provided for @accountNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The account corresponding to the credential was not found, please try again.'**
  String get accountNotFoundMessage;

  /// No description provided for @accountNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get accountNotFoundTitle;

  /// No description provided for @wrongPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'The password is invalid, please try again.'**
  String get wrongPasswordMessage;

  /// No description provided for @wrongPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPasswordTitle;

  /// No description provided for @invalidVerificationCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'The verification code of the credential is invalid, please try again.'**
  String get invalidVerificationCodeMessage;

  /// No description provided for @invalidVerificationCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get invalidVerificationCodeTitle;

  /// No description provided for @invalidVerificationIdMessage.
  ///
  /// In en, this message translates to:
  /// **'The verification id of the credential is invalid, please try again.'**
  String get invalidVerificationIdMessage;

  /// No description provided for @invalidVerificationIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification id'**
  String get invalidVerificationIdTitle;

  /// No description provided for @invalidEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'The email address provided is invalid, please try again.'**
  String get invalidEmailMessage;

  /// No description provided for @invalidEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmailTitle;

  /// No description provided for @emailAlreadyInUseMessage.
  ///
  /// In en, this message translates to:
  /// **'The email used already exists, please use a different email or try to log in.'**
  String get emailAlreadyInUseMessage;

  /// No description provided for @emailAlreadyInUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Email already in use'**
  String get emailAlreadyInUseTitle;

  /// No description provided for @weakPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak, please try again.'**
  String get weakPasswordMessage;

  /// No description provided for @weakPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Weak password'**
  String get weakPasswordTitle;

  /// No description provided for @invalidPhoneNumberMessage.
  ///
  /// In en, this message translates to:
  /// **'The phone number has an invalid format. Please input a valid phone number.'**
  String get invalidPhoneNumberMessage;

  /// No description provided for @invalidPhoneNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid Phone Number'**
  String get invalidPhoneNumberTitle;

  /// No description provided for @captchaCheckFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Captcha Check Failed'**
  String get captchaCheckFailedTitle;

  /// No description provided for @quotaExceededTitle.
  ///
  /// In en, this message translates to:
  /// **'Quota Exceeded'**
  String get quotaExceededTitle;

  /// No description provided for @providerAlreadyLinkedTitle.
  ///
  /// In en, this message translates to:
  /// **'Provider Already Linked'**
  String get providerAlreadyLinkedTitle;

  /// No description provided for @credentialAlreadyInUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Credential Already In Use'**
  String get credentialAlreadyInUseTitle;

  /// No description provided for @unknownErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An unknown error has occurred, please try again.'**
  String get unknownErrorMessage;

  /// No description provided for @unknownErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownErrorTitle;

  /// No description provided for @accountDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been successfully deleted.'**
  String get accountDeletedMessage;

  /// No description provided for @accountDeletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get accountDeletedTitle;

  /// No description provided for @failedToDeleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred while trying to delete your account.'**
  String get failedToDeleteAccountMessage;

  /// No description provided for @failedToDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get failedToDeleteAccountTitle;

  /// No description provided for @accountLinkedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been successfully linked.'**
  String get accountLinkedMessage;

  /// No description provided for @accountLinkedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account linked'**
  String get accountLinkedTitle;

  /// No description provided for @logoutSuccessfulMessage.
  ///
  /// In en, this message translates to:
  /// **'You are no longer logged in.'**
  String get logoutSuccessfulMessage;

  /// No description provided for @logoutSuccessfulTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout successful'**
  String get logoutSuccessfulTitle;

  /// No description provided for @loginFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailedTitle;

  /// No description provided for @accountCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get accountCreatedTitle;

  /// No description provided for @registerFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Register failed'**
  String get registerFailedTitle;

  /// No description provided for @logoutFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout failed'**
  String get logoutFailedTitle;

  /// No description provided for @verifyEmailSentMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your email to verify your account.'**
  String get verifyEmailSentMessage;

  /// No description provided for @verifyEmailSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify email sent'**
  String get verifyEmailSentTitle;

  /// No description provided for @emailNotVerifiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Could not verify your email at this time. Please try again later.'**
  String get emailNotVerifiedMessage;

  /// No description provided for @emailNotVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Not Verified'**
  String get emailNotVerifiedTitle;

  /// No description provided for @emailVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Email verified'**
  String get emailVerifiedTitle;

  /// No description provided for @welcomeBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBackTitle;

  /// No description provided for @failedToLogInTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to log in'**
  String get failedToLogInTitle;

  /// No description provided for @accountCreationFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account creation failed'**
  String get accountCreationFailedTitle;

  /// No description provided for @userIdIsNull.
  ///
  /// In en, this message translates to:
  /// **'User ID is null'**
  String get userIdIsNull;

  /// No description provided for @taskNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to find the task to update subtask'**
  String get taskNotFoundMessage;

  /// No description provided for @taskNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get taskNotFoundTitle;

  /// No description provided for @failedToUpdateSubtaskMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to update subtask. Please try again.'**
  String get failedToUpdateSubtaskMessage;

  /// No description provided for @conversionFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to convert screenshot'**
  String get conversionFailedMessage;

  /// No description provided for @conversionFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversion failed'**
  String get conversionFailedTitle;

  /// No description provided for @unexpectedErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedErrorMessage;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @failedToDeleteItemMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while deleting the item. Please try again.'**
  String get failedToDeleteItemMessage;

  /// No description provided for @failedToDeleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete item'**
  String get failedToDeleteItemTitle;

  /// No description provided for @subtaskNameRequiredValidation.
  ///
  /// In en, this message translates to:
  /// **'Subtask name is required'**
  String get subtaskNameRequiredValidation;

  /// No description provided for @subtaskNameInvalidCharactersValidation.
  ///
  /// In en, this message translates to:
  /// **'Subtask name contains invalid characters'**
  String get subtaskNameInvalidCharactersValidation;

  /// No description provided for @subtaskNameMaxLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Subtask name cannot exceed 100 characters'**
  String get subtaskNameMaxLengthValidation;

  /// No description provided for @descriptionMaxLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Description cannot exceed 500 characters'**
  String get descriptionMaxLengthValidation;

  /// No description provided for @descriptionInvalidCharactersValidation.
  ///
  /// In en, this message translates to:
  /// **'Description contains invalid characters'**
  String get descriptionInvalidCharactersValidation;

  /// No description provided for @apiNameUsers.
  ///
  /// In en, this message translates to:
  /// **'UsersApi'**
  String get apiNameUsers;

  /// No description provided for @apiNameProfiles.
  ///
  /// In en, this message translates to:
  /// **'ProfilesApi'**
  String get apiNameProfiles;

  /// No description provided for @apiNameUsernames.
  ///
  /// In en, this message translates to:
  /// **'UsernamesApi'**
  String get apiNameUsernames;

  /// No description provided for @apiNameHouseholds.
  ///
  /// In en, this message translates to:
  /// **'HouseholdsApi'**
  String get apiNameHouseholds;

  /// No description provided for @apiNameSettings.
  ///
  /// In en, this message translates to:
  /// **'SettingsApi'**
  String get apiNameSettings;

  /// No description provided for @apiNameHouseholdInvites.
  ///
  /// In en, this message translates to:
  /// **'HouseholdInvitesApi'**
  String get apiNameHouseholdInvites;

  /// No description provided for @apiNameInviteCodes.
  ///
  /// In en, this message translates to:
  /// **'InviteCodesApi'**
  String get apiNameInviteCodes;

  /// No description provided for @apiNameShoppingLists.
  ///
  /// In en, this message translates to:
  /// **'ShoppingListsApi'**
  String get apiNameShoppingLists;

  /// No description provided for @apiNameShoppingListItems.
  ///
  /// In en, this message translates to:
  /// **'ShoppingListItemsApi'**
  String get apiNameShoppingListItems;

  /// No description provided for @apiNameCleaningTasks.
  ///
  /// In en, this message translates to:
  /// **'CleaningTasksApi'**
  String get apiNameCleaningTasks;

  /// No description provided for @apiNameCleaningTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'CleaningTimeSlotsApi'**
  String get apiNameCleaningTimeSlots;

  /// No description provided for @apiNameCompletedCleaningTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'CompletedCleaningTimeSlotsApi'**
  String get apiNameCompletedCleaningTimeSlots;

  /// No description provided for @apiNameFeedbacks.
  ///
  /// In en, this message translates to:
  /// **'FeedbacksApi'**
  String get apiNameFeedbacks;

  /// No description provided for @apiNamePayments.
  ///
  /// In en, this message translates to:
  /// **'PaymentsApi'**
  String get apiNamePayments;

  /// No description provided for @languageNameEngelsNL.
  ///
  /// In en, this message translates to:
  /// **'Engels'**
  String get languageNameEngelsNL;

  /// No description provided for @languageNameEnglishEN.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageNameEnglishEN;

  /// No description provided for @languageNameNederlandsNL.
  ///
  /// In en, this message translates to:
  /// **'Nederlands'**
  String get languageNameNederlandsNL;

  /// No description provided for @languageNameDutchEN.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get languageNameDutchEN;

  /// No description provided for @contactTypeEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactTypeEmail;

  /// No description provided for @contactTypePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get contactTypePhoneNumber;

  /// No description provided for @contactTypeLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get contactTypeLink;

  /// No description provided for @contactTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get contactTypeUnknown;

  /// No description provided for @welcomeToRoomyDescription.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Roomy'**
  String get welcomeToRoomyDescription;

  /// No description provided for @emailInputFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Email input field'**
  String get emailInputFieldLabel;

  /// No description provided for @passwordInputFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Password input field'**
  String get passwordInputFieldLabel;

  /// No description provided for @loginButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Login button'**
  String get loginButtonLabel;

  /// No description provided for @registerButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Register button'**
  String get registerButtonLabel;

  /// No description provided for @switchToLoginLabel.
  ///
  /// In en, this message translates to:
  /// **'Switch to login'**
  String get switchToLoginLabel;

  /// No description provided for @loggedInTitle.
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loggedInTitle;

  /// No description provided for @logoutButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Logout button'**
  String get logoutButtonLabel;

  /// No description provided for @acceptInviteLabel.
  ///
  /// In en, this message translates to:
  /// **'Accept Invite'**
  String get acceptInviteLabel;

  /// No description provided for @declineInviteLabel.
  ///
  /// In en, this message translates to:
  /// **'Decline Invite'**
  String get declineInviteLabel;

  /// No description provided for @cancelInviteLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Invite'**
  String get cancelInviteLabel;

  /// No description provided for @homeScreenLabel.
  ///
  /// In en, this message translates to:
  /// **'Home screen'**
  String get homeScreenLabel;

  /// No description provided for @settingsButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings button'**
  String get settingsButtonLabel;

  /// No description provided for @invitesEmoji.
  ///
  /// In en, this message translates to:
  /// **'📨  '**
  String get invitesEmoji;

  /// No description provided for @requestsEmoji.
  ///
  /// In en, this message translates to:
  /// **'🤝  '**
  String get requestsEmoji;

  /// No description provided for @cancelInviteLabelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel Invite'**
  String get cancelInviteLabelAction;

  /// No description provided for @acceptRequestLabel.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get acceptRequestLabel;

  /// No description provided for @sentInvitesEmoji.
  ///
  /// In en, this message translates to:
  /// **'📤  '**
  String get sentInvitesEmoji;

  /// No description provided for @myInvitesEmoji.
  ///
  /// In en, this message translates to:
  /// **'📨  '**
  String get myInvitesEmoji;

  /// No description provided for @declineInviteLabelAction.
  ///
  /// In en, this message translates to:
  /// **'Decline Invite'**
  String get declineInviteLabelAction;

  /// No description provided for @shoppingItemDescription.
  ///
  /// In en, this message translates to:
  /// **'Shopping item'**
  String get shoppingItemDescription;

  /// No description provided for @memberStatisticsDescription.
  ///
  /// In en, this message translates to:
  /// **'Member statistics'**
  String get memberStatisticsDescription;

  /// No description provided for @itemImageDescription.
  ///
  /// In en, this message translates to:
  /// **'Item image'**
  String get itemImageDescription;

  /// No description provided for @colorLabelWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorLabelWhite;

  /// No description provided for @colorLabelRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorLabelRed;

  /// No description provided for @colorLabelGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorLabelGreen;

  /// No description provided for @colorLabelBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorLabelBlue;

  /// No description provided for @colorLabelYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorLabelYellow;

  /// No description provided for @colorLabelPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorLabelPurple;

  /// No description provided for @colorLabelOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorLabelOrange;

  /// No description provided for @colorLabelPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorLabelPink;

  /// No description provided for @colorLabelCyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get colorLabelCyan;

  /// No description provided for @colorLabelTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get colorLabelTeal;

  /// No description provided for @userProfileCardDescription.
  ///
  /// In en, this message translates to:
  /// **'User profile card'**
  String get userProfileCardDescription;

  /// No description provided for @errorAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'You are already a member of this household'**
  String get errorAlreadyMember;

  /// No description provided for @errorInvalidInviteCode.
  ///
  /// In en, this message translates to:
  /// **'The invite code is invalid. Please check and try again.'**
  String get errorInvalidInviteCode;

  /// No description provided for @errorHouseholdFull.
  ///
  /// In en, this message translates to:
  /// **'This household has reached the maximum number of members'**
  String get errorHouseholdFull;

  /// No description provided for @errorPendingInvite.
  ///
  /// In en, this message translates to:
  /// **'You already have a pending invite to this household'**
  String get errorPendingInvite;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get errorRateLimited;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User profile not found. Please complete your profile setup.'**
  String get errorUserNotFound;

  /// No description provided for @errorInvalidCodeFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid invite code format. The code should be 4 letters/numbers.'**
  String get errorInvalidCodeFormat;

  /// No description provided for @errorUnauthenticated.
  ///
  /// In en, this message translates to:
  /// **'Please log in to continue'**
  String get errorUnauthenticated;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested item was not found'**
  String get errorNotFound;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to perform this action'**
  String get errorPermissionDenied;

  /// No description provided for @unableToCompleteRequest.
  ///
  /// In en, this message translates to:
  /// **'Unable to Complete Request'**
  String get unableToCompleteRequest;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @notificationSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Control which notifications you receive.'**
  String get notificationSettingsDescription;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @enableNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications for updates.'**
  String get enableNotificationsDescription;

  /// No description provided for @shoppingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Shopping Notifications'**
  String get shoppingNotifications;

  /// No description provided for @shoppingNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified about shopping list updates.'**
  String get shoppingNotificationsDescription;

  /// No description provided for @cleaningNotifications.
  ///
  /// In en, this message translates to:
  /// **'Cleaning Notifications'**
  String get cleaningNotifications;

  /// No description provided for @cleaningNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified about cleaning task updates.'**
  String get cleaningNotificationsDescription;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabled;

  /// No description provided for @shoppingNotificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Shopping notifications enabled'**
  String get shoppingNotificationsEnabled;

  /// No description provided for @shoppingNotificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Shopping notifications disabled'**
  String get shoppingNotificationsDisabled;

  /// No description provided for @cleaningNotificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Cleaning notifications enabled'**
  String get cleaningNotificationsEnabled;

  /// No description provided for @cleaningNotificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Cleaning notifications disabled'**
  String get cleaningNotificationsDisabled;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @addedToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Added to shopping list'**
  String get addedToShoppingList;

  /// No description provided for @completedShoppingItems.
  ///
  /// In en, this message translates to:
  /// **'Shopping items completed'**
  String get completedShoppingItems;

  /// No description provided for @notificationMarkedAsRead.
  ///
  /// In en, this message translates to:
  /// **'Marked as read'**
  String get notificationMarkedAsRead;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @notificationConsentBannerText.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to know when your roomies go shopping'**
  String get notificationConsentBannerText;

  /// No description provided for @notificationConsentSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay in the Loop'**
  String get notificationConsentSheetTitle;

  /// No description provided for @notificationConsentSheetBody.
  ///
  /// In en, this message translates to:
  /// **'Get notified when your roomies add items to shopping lists or complete tasks. Never miss an update from your household.'**
  String get notificationConsentSheetBody;

  /// No description provided for @notificationConsentCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notificationConsentCancelButton;

  /// No description provided for @notificationConsentAcceptButton.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get notificationConsentAcceptButton;

  /// No description provided for @notificationPermissionGrantedToast.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled! You\'ll now receive updates from your household.'**
  String get notificationPermissionGrantedToast;

  /// No description provided for @notificationPermissionDeniedToast.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled. You can enable them later in Settings.'**
  String get notificationPermissionDeniedToast;

  /// No description provided for @notificationPermissionDeniedInfo.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is disabled. Enable it in your device settings to receive updates.'**
  String get notificationPermissionDeniedInfo;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Turbo Template'**
  String get appName;

  /// No description provided for @welcomeToApp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}'**
  String welcomeToApp(String appName);
}

class _StringsDelegate extends LocalizationsDelegate<Strings> {
  const _StringsDelegate();

  @override
  Future<Strings> load(Locale locale) {
    return SynchronousFuture<Strings>(lookupStrings(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_StringsDelegate old) => false;
}

Strings lookupStrings(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return StringsEn();
    case 'nl':
      return StringsNl();
  }

  throw FlutterError(
    'Strings.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

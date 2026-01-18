// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(householdName) =>
      "This will remove you from \'${householdName}\'. Continue?";

  static String m1(user, date) => "Added by ${user} on ${date}";

  static String m2(count) => "+ ${count} more";

  static String m3(bug) => "${bug} Bug";

  static String m4(dateString) => "Created at ${dateString}";

  static String m5(count) => "${count} days ago";

  static String m6(username) => "Hello @${username}";

  static String m7(count) => "${count} hours ago";

  static String m8(householdName) => "${householdName} created!";

  static String m9(idea) => "${idea} Idea";

  static String m10(email) =>
      "If ${email} is registered with us, a password reset email has been sent.";

  static String m11(count) => "in ${count} days";

  static String m12(count) => "in ${count} months";

  static String m13(inWeeks) => "In ${inWeeks} Weeks";

  static String m14(count) => "in ${count}+ weeks";

  static String m15(supportedLanguage) =>
      "Language changed to ${supportedLanguage}";

  static String m16(lastUpdatedAtString) =>
      "Last update at ${lastUpdatedAtString}";

  static String m17(appName) => "Login to your ${appName} account";

  static String m18(length) =>
      "Maximum length of ${length} characters exceeded";

  static String m19(value) => "Maximum value of ${value} exceeded";

  static String m20(createdAtString) => "Member since ${createdAtString}";

  static String m21(date) => "Member since ${date}";

  static String m22(value) => "Minimum value of ${value} is required";

  static String m23(count) => "${count} minutes ago";

  static String m24(kLimitsMaxNameLength) =>
      "Name can be at most ${kLimitsMaxNameLength} characters long.";

  static String m25(date) => "Next due: ${date}";

  static String m26(count) => "overdue ${count} days";

  static String m27(appName) => "Please login to your ${appName} account";

  static String m28(seconds) => "Wait ${seconds}s.";

  static String m29(minutes, minuteText, seconds, secondText) =>
      "You can request another reset email in ${minutes} ${minuteText} and ${seconds} ${secondText}";

  static String m30(seconds, secondText) =>
      "You can request another reset email in ${seconds} ${secondText}";

  static String m31(count) => "${count} times a day";

  static String m32(count) => "${count} times a month";

  static String m33(count) => "${count} times a week";

  static String m34(count) => "${count} times a year";

  static String m35(username) =>
      "${username} is already a member of this household. Would you like to add someone else?";

  static String m36(username) =>
      "${username} has already been invited to this household. Would you like to invite someone else?";

  static String m37(username) =>
      "We could not find a user with the username ${username}. Please check the username and try again.";

  static String m38(username) => "${username}\'s Household";

  static String m39(seconds) =>
      "Verification email sent,\nchecking again in ${seconds} seconds";

  static String m40(inWeeks) => "${inWeeks} Weeks Ago";

  static String m41(appName) => "Welcome to ${appName}";

  static String m42(name) => "You have been invited to join ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aHousehold": MessageLookupByLibrary.simpleMessage("a household"),
    "accept": MessageLookupByLibrary.simpleMessage("Accept"),
    "acceptInviteLabel": MessageLookupByLibrary.simpleMessage("Accept Invite"),
    "acceptRequestLabel": MessageLookupByLibrary.simpleMessage(
      "Accept Request",
    ),
    "acceptingInviteWillRemoveYouFromCurrentHousehold": m0,
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "accountAlreadyInUseMessage": MessageLookupByLibrary.simpleMessage(
      "The account is already in use, please try again.",
    ),
    "accountAlreadyInUseTitle": MessageLookupByLibrary.simpleMessage(
      "Account already in use",
    ),
    "accountCreated": MessageLookupByLibrary.simpleMessage("Account created"),
    "accountCreatedTitle": MessageLookupByLibrary.simpleMessage(
      "Account created",
    ),
    "accountCreationFailed": MessageLookupByLibrary.simpleMessage(
      "Account creation failed",
    ),
    "accountCreationFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Account creation failed",
    ),
    "accountDeletedMessage": MessageLookupByLibrary.simpleMessage(
      "Your account has been successfully deleted.",
    ),
    "accountDeletedTitle": MessageLookupByLibrary.simpleMessage(
      "Account deleted",
    ),
    "accountDisabledMessage": MessageLookupByLibrary.simpleMessage(
      "The account corresponding to the credential is disabled, please try again.",
    ),
    "accountDisabledTitle": MessageLookupByLibrary.simpleMessage(
      "Account disabled",
    ),
    "accountLinkedMessage": MessageLookupByLibrary.simpleMessage(
      "Your account has been successfully linked.",
    ),
    "accountLinkedTitle": MessageLookupByLibrary.simpleMessage(
      "Account linked",
    ),
    "accountNotFoundMessage": MessageLookupByLibrary.simpleMessage(
      "The account corresponding to the credential was not found, please try again.",
    ),
    "accountNotFoundTitle": MessageLookupByLibrary.simpleMessage(
      "Account not found",
    ),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addEmail": MessageLookupByLibrary.simpleMessage("Add email"),
    "addItem": MessageLookupByLibrary.simpleMessage("Add Item"),
    "addItemToList": MessageLookupByLibrary.simpleMessage("Add item to list"),
    "addLink": MessageLookupByLibrary.simpleMessage("Add link"),
    "addPhoneNumber": MessageLookupByLibrary.simpleMessage("Add phone number"),
    "addReceipt": MessageLookupByLibrary.simpleMessage("Add Receipt"),
    "addRoomy": MessageLookupByLibrary.simpleMessage("Add Roomy"),
    "addSubtask": MessageLookupByLibrary.simpleMessage("Add subtask"),
    "addSubtaskHint": MessageLookupByLibrary.simpleMessage(
      "Add a new subtask...",
    ),
    "addSubtasksToBreakDownYourTask": MessageLookupByLibrary.simpleMessage(
      "Add subtasks to break down your task into smaller steps",
    ),
    "addTask": MessageLookupByLibrary.simpleMessage("Add Task"),
    "addedBy": MessageLookupByLibrary.simpleMessage("Added by"),
    "addedByUserOnDate": m1,
    "addedToShoppingList": MessageLookupByLibrary.simpleMessage(
      "Added to shopping list",
    ),
    "administration": MessageLookupByLibrary.simpleMessage("Administration"),
    "allItemsUnchecked": MessageLookupByLibrary.simpleMessage(
      "All items unchecked",
    ),
    "allPayments": MessageLookupByLibrary.simpleMessage("All Payments"),
    "allTasks": MessageLookupByLibrary.simpleMessage("All Tasks"),
    "allTasksCompleted": MessageLookupByLibrary.simpleMessage(
      "All tasks completed",
    ),
    "allTasksDescription": MessageLookupByLibrary.simpleMessage(
      "View all cleaning tasks in your household. You can claim unassigned tasks, see who\'s responsible for each task, and track the overall cleaning schedule",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "alreadyInUse": MessageLookupByLibrary.simpleMessage("Already in use"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "amountPlaceholder": MessageLookupByLibrary.simpleMessage("0,-"),
    "anErrorOccurredWhileTryingToLogoutPleaseTryAgain":
        MessageLookupByLibrary.simpleMessage(
          "An error occurred while trying to logout. Please try again later.",
        ),
    "anUnknownErrorOccurredPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "An unknown error occurred. Please try again later.",
        ),
    "and": MessageLookupByLibrary.simpleMessage("and"),
    "andCountMore": m2,
    "anotherDayAnotherList": MessageLookupByLibrary.simpleMessage(
      "Another day, another list.",
    ),
    "apiNameCleaningTasks": MessageLookupByLibrary.simpleMessage(
      "CleaningTasksApi",
    ),
    "apiNameCleaningTimeSlots": MessageLookupByLibrary.simpleMessage(
      "CleaningTimeSlotsApi",
    ),
    "apiNameCompletedCleaningTimeSlots": MessageLookupByLibrary.simpleMessage(
      "CompletedCleaningTimeSlotsApi",
    ),
    "apiNameFeedbacks": MessageLookupByLibrary.simpleMessage("FeedbacksApi"),
    "apiNameHouseholdInvites": MessageLookupByLibrary.simpleMessage(
      "HouseholdInvitesApi",
    ),
    "apiNameHouseholds": MessageLookupByLibrary.simpleMessage("HouseholdsApi"),
    "apiNameInviteCodes": MessageLookupByLibrary.simpleMessage(
      "InviteCodesApi",
    ),
    "apiNamePayments": MessageLookupByLibrary.simpleMessage("PaymentsApi"),
    "apiNameProfiles": MessageLookupByLibrary.simpleMessage("ProfilesApi"),
    "apiNameSettings": MessageLookupByLibrary.simpleMessage("SettingsApi"),
    "apiNameShoppingListItems": MessageLookupByLibrary.simpleMessage(
      "ShoppingListItemsApi",
    ),
    "apiNameShoppingLists": MessageLookupByLibrary.simpleMessage(
      "ShoppingListsApi",
    ),
    "apiNameUsernames": MessageLookupByLibrary.simpleMessage("UsernamesApi"),
    "apiNameUsers": MessageLookupByLibrary.simpleMessage("UsersApi"),
    "appName": MessageLookupByLibrary.simpleMessage("Turbo Template"),
    "apr": MessageLookupByLibrary.simpleMessage("apr"),
    "april": MessageLookupByLibrary.simpleMessage("april"),
    "areYouSureYouWantToCancelThisInvite": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to cancel this invite?",
    ),
    "areYouSureYouWantToDeclineThisInvite":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure you want to decline this invite?",
        ),
    "areYouSureYouWantToDeleteThisImage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this image?",
    ),
    "areYouSureYouWantToDeleteThisItem": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this item?",
    ),
    "areYouSureYouWantToDeleteThisShoppingList":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure you want to delete this shopping list?",
        ),
    "areYouSureYouWantToDeleteThisSubtask":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure you want to delete this subtask?",
        ),
    "areYouSureYouWantToDeleteThisTask": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this task?",
    ),
    "areYouSureYouWantToLeaveThisHousehold":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure you want to leave this household?",
        ),
    "areYouSureYouWantToLogout": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to logout?",
    ),
    "areYouSureYouWantToProceedThisWillTake": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to proceed? This will take you to the delete account page.",
    ),
    "areYouSureYouWantToRemoveThisMember": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to remove this member?",
    ),
    "areYouSureYouWantToUnassignThisTask": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to unassign this task?",
    ),
    "areYouSureYouWantToUncheckAllItems": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to uncheck all items?",
    ),
    "assign": MessageLookupByLibrary.simpleMessage("Assign"),
    "assigned": MessageLookupByLibrary.simpleMessage("Assigned"),
    "assignedTo": MessageLookupByLibrary.simpleMessage("Assigned to"),
    "assignment": MessageLookupByLibrary.simpleMessage("Assignment"),
    "aug": MessageLookupByLibrary.simpleMessage("aug"),
    "august": MessageLookupByLibrary.simpleMessage("august"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "beforeMovingOnTakeAMomentToReadHowWe": MessageLookupByLibrary.simpleMessage(
      "Before moving on, take a moment to read how we protect your personal information.",
    ),
    "bekijkSchema": MessageLookupByLibrary.simpleMessage("Check Schema"),
    "biography": MessageLookupByLibrary.simpleMessage("Biography"),
    "breakTaskIntoSmallerSteps": MessageLookupByLibrary.simpleMessage(
      "Break task into smaller steps",
    ),
    "bug": m3,
    "bulkActions": MessageLookupByLibrary.simpleMessage("Bulk Actions"),
    "byClickingContinue": MessageLookupByLibrary.simpleMessage(
      "By clicking continue, you agree to our",
    ),
    "camera": MessageLookupByLibrary.simpleMessage("Camera"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelInvite": MessageLookupByLibrary.simpleMessage("Cancel Invite"),
    "cancelInviteLabel": MessageLookupByLibrary.simpleMessage("Cancel Invite"),
    "cancelInviteLabelAction": MessageLookupByLibrary.simpleMessage(
      "Cancel Invite",
    ),
    "cannotEditPaymentsCreatedByOtherUsers":
        MessageLookupByLibrary.simpleMessage(
          "You cannot edit payments created by other users",
        ),
    "captchaCheckFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Captcha Check Failed",
    ),
    "changeName": MessageLookupByLibrary.simpleMessage("Change Name"),
    "changePassword": MessageLookupByLibrary.simpleMessage("Change Password"),
    "chartDescriptionHouseholdOverTime": MessageLookupByLibrary.simpleMessage(
      "Total household spending per time bucket. Shows expense trends over the selected period.",
    ),
    "chartDescriptionPayerSharePie": MessageLookupByLibrary.simpleMessage(
      "Who paid for expenses in this period. Shows the percentage breakdown by payer.",
    ),
    "chartDescriptionRoommateNetBars": MessageLookupByLibrary.simpleMessage(
      "Balance for each roommate. Green bars show what they are owed, red bars show what they owe.",
    ),
    "chartDescriptionSparklineNet": MessageLookupByLibrary.simpleMessage(
      "Your net balance over time. Positive values mean others owe you, negative means you owe others.",
    ),
    "checkAllTasksToClaimOrGetAssigned": MessageLookupByLibrary.simpleMessage(
      "Check \'Schema\' to claim or assign.",
    ),
    "checkStatus": MessageLookupByLibrary.simpleMessage("Check Status"),
    "checkYourSpamFolder": MessageLookupByLibrary.simpleMessage(
      "Can\'t find it? Check your spam or junk folder.",
    ),
    "checkmarkSymbol": MessageLookupByLibrary.simpleMessage("✅"),
    "chooseAnOptionToGetStarted": MessageLookupByLibrary.simpleMessage(
      "Choose an option to get started",
    ),
    "chooseHouseholdMemberToAssignTask": MessageLookupByLibrary.simpleMessage(
      "Choose a household member to assign this task to.",
    ),
    "claim": MessageLookupByLibrary.simpleMessage("Claim"),
    "claimTask": MessageLookupByLibrary.simpleMessage("Claim Task"),
    "claimTaskConfirmationMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to claim this task? This will assign it to you.",
    ),
    "claimTaskConfirmationTitle": MessageLookupByLibrary.simpleMessage(
      "Claim this task?",
    ),
    "cleaning": MessageLookupByLibrary.simpleMessage("Cleaning"),
    "cleaningFrequency": MessageLookupByLibrary.simpleMessage("Frequency"),
    "cleaningNotifications": MessageLookupByLibrary.simpleMessage(
      "Cleaning Notifications",
    ),
    "cleaningNotificationsDescription": MessageLookupByLibrary.simpleMessage(
      "Get notified about cleaning task updates.",
    ),
    "cleaningNotificationsDisabled": MessageLookupByLibrary.simpleMessage(
      "Cleaning notifications disabled",
    ),
    "cleaningNotificationsEnabled": MessageLookupByLibrary.simpleMessage(
      "Cleaning notifications enabled",
    ),
    "cleaningSchedule": MessageLookupByLibrary.simpleMessage(
      "Cleaning Schedule",
    ),
    "cleaningTaskDescription": MessageLookupByLibrary.simpleMessage(
      "Description",
    ),
    "cleaningTaskDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "e.g. Brief overview of what needs to be done",
    ),
    "cleaningTaskDescriptionMaxLength": MessageLookupByLibrary.simpleMessage(
      "Description can be at most 200 characters long.",
    ),
    "cleaningTaskFrequencyMaxCount": MessageLookupByLibrary.simpleMessage(
      "Frequency must be at most 100.",
    ),
    "cleaningTaskFrequencyMinCount": MessageLookupByLibrary.simpleMessage(
      "Frequency must be at least 1.",
    ),
    "cleaningTaskFrequencyRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "cleaningTaskInstructions": MessageLookupByLibrary.simpleMessage(
      "Instructions",
    ),
    "cleaningTaskInstructionsHint": MessageLookupByLibrary.simpleMessage(
      "e.g. Clean the shower, toilet, and sink",
    ),
    "cleaningTaskInstructionsMaxLength": MessageLookupByLibrary.simpleMessage(
      "Instructions can be at most 200 characters long.",
    ),
    "cleaningTaskName": MessageLookupByLibrary.simpleMessage("Name"),
    "cleaningTaskNameHint": MessageLookupByLibrary.simpleMessage(
      "e.g. Clean the bathroom",
    ),
    "cleaningTaskNameMaxLength": MessageLookupByLibrary.simpleMessage(
      "Name can be at most 50 characters long.",
    ),
    "cleaningTaskNameMinLength": MessageLookupByLibrary.simpleMessage(
      "Name must be at least 1 character long.",
    ),
    "cleaningTaskSize": MessageLookupByLibrary.simpleMessage("Size"),
    "cleaningTaskSizeHint": MessageLookupByLibrary.simpleMessage(
      "Select the effort level for this task",
    ),
    "cleaningTaskSizeL": MessageLookupByLibrary.simpleMessage("Large"),
    "cleaningTaskSizeM": MessageLookupByLibrary.simpleMessage("Medium"),
    "cleaningTaskSizeS": MessageLookupByLibrary.simpleMessage("Small"),
    "cleaningTaskSizeXl": MessageLookupByLibrary.simpleMessage("Extra Large"),
    "cleaningTaskSizeXs": MessageLookupByLibrary.simpleMessage("Extra Small"),
    "cleaningTaskTimespanRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "cleaningTasksEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Create your first cleaning task to get organized.",
    ),
    "cleaningTimespan": MessageLookupByLibrary.simpleMessage("Timespan"),
    "cleaningTimespanDay": MessageLookupByLibrary.simpleMessage("Day"),
    "cleaningTimespanMonth": MessageLookupByLibrary.simpleMessage("Month"),
    "cleaningTimespanWeek": MessageLookupByLibrary.simpleMessage("Week"),
    "cleaningTimespanYear": MessageLookupByLibrary.simpleMessage("Year"),
    "clickHereToLogin": MessageLookupByLibrary.simpleMessage(
      "Click here to log in",
    ),
    "clickToView": MessageLookupByLibrary.simpleMessage("Click to view"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "codeInvullen": MessageLookupByLibrary.simpleMessage("Join household"),
    "codeTonen": MessageLookupByLibrary.simpleMessage("Show Code"),
    "colorLabelBlue": MessageLookupByLibrary.simpleMessage("Blue"),
    "colorLabelCyan": MessageLookupByLibrary.simpleMessage("Cyan"),
    "colorLabelGreen": MessageLookupByLibrary.simpleMessage("Green"),
    "colorLabelOrange": MessageLookupByLibrary.simpleMessage("Orange"),
    "colorLabelPink": MessageLookupByLibrary.simpleMessage("Pink"),
    "colorLabelPurple": MessageLookupByLibrary.simpleMessage("Purple"),
    "colorLabelRed": MessageLookupByLibrary.simpleMessage("Red"),
    "colorLabelTeal": MessageLookupByLibrary.simpleMessage("Teal"),
    "colorLabelWhite": MessageLookupByLibrary.simpleMessage("White"),
    "colorLabelYellow": MessageLookupByLibrary.simpleMessage("Yellow"),
    "complete": MessageLookupByLibrary.simpleMessage("Complete"),
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "completedByYou": MessageLookupByLibrary.simpleMessage("Completed by you"),
    "completedShoppingItems": MessageLookupByLibrary.simpleMessage(
      "Shopping items completed",
    ),
    "components": MessageLookupByLibrary.simpleMessage("Components"),
    "configure": MessageLookupByLibrary.simpleMessage("Configure"),
    "confirmYourPassword": MessageLookupByLibrary.simpleMessage(
      "Confirm your password",
    ),
    "contactTypeEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "contactTypeLink": MessageLookupByLibrary.simpleMessage("Link"),
    "contactTypePhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Phone Number",
    ),
    "contactTypeUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "conversionFailedMessage": MessageLookupByLibrary.simpleMessage(
      "Failed to convert screenshot",
    ),
    "conversionFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Conversion failed",
    ),
    "copyToClipboard": MessageLookupByLibrary.simpleMessage(
      "Copy to clipboard",
    ),
    "core": MessageLookupByLibrary.simpleMessage("Core"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create an account"),
    "createAndManageYourCleaningTasks": MessageLookupByLibrary.simpleMessage(
      "Very important task details.",
    ),
    "createHousehold": MessageLookupByLibrary.simpleMessage("Create Household"),
    "createShoppingList": MessageLookupByLibrary.simpleMessage(
      "Create Shopping List",
    ),
    "createYourFirstHousehold": MessageLookupByLibrary.simpleMessage(
      "Create your first household!",
    ),
    "createYourFirstPaymentToGetStarted": MessageLookupByLibrary.simpleMessage(
      "Create your first payment to get started.",
    ),
    "created": MessageLookupByLibrary.simpleMessage("Created"),
    "createdAtDateString": m4,
    "credentialAlreadyInUseTitle": MessageLookupByLibrary.simpleMessage(
      "Credential Already In Use",
    ),
    "crossSymbol": MessageLookupByLibrary.simpleMessage("❌"),
    "dangerZone": MessageLookupByLibrary.simpleMessage("Danger Zone"),
    "databaseFailure": MessageLookupByLibrary.simpleMessage("Database Failure"),
    "day": MessageLookupByLibrary.simpleMessage("day"),
    "dayOfMonth": MessageLookupByLibrary.simpleMessage("Day of month"),
    "dayOfMonthPlaceholder": MessageLookupByLibrary.simpleMessage("e.g. 15"),
    "days": MessageLookupByLibrary.simpleMessage("days"),
    "daysAgo": m5,
    "deadline": MessageLookupByLibrary.simpleMessage("Deadline"),
    "dec": MessageLookupByLibrary.simpleMessage("dec"),
    "december": MessageLookupByLibrary.simpleMessage("december"),
    "decline": MessageLookupByLibrary.simpleMessage("Decline"),
    "declineInvite": MessageLookupByLibrary.simpleMessage("Decline Invite"),
    "declineInviteLabel": MessageLookupByLibrary.simpleMessage(
      "Decline Invite",
    ),
    "declineInviteLabelAction": MessageLookupByLibrary.simpleMessage(
      "Decline Invite",
    ),
    "decrease": MessageLookupByLibrary.simpleMessage("Decrease"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
    "deleteImage": MessageLookupByLibrary.simpleMessage("Delete Image"),
    "deleteItem": MessageLookupByLibrary.simpleMessage("Delete item"),
    "deletePayment": MessageLookupByLibrary.simpleMessage("Delete Payment"),
    "deletePaymentConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this payment? This action cannot be undone.",
    ),
    "deleteReceipt": MessageLookupByLibrary.simpleMessage("Delete Receipt"),
    "deleteReceiptConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this receipt?",
    ),
    "deleteShoppingList": MessageLookupByLibrary.simpleMessage(
      "Delete Shopping List",
    ),
    "deletingFailed": MessageLookupByLibrary.simpleMessage("Deleting failed"),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "descriptionInvalidCharactersValidation":
        MessageLookupByLibrary.simpleMessage(
          "Description contains invalid characters",
        ),
    "descriptionMaxLengthValidation": MessageLookupByLibrary.simpleMessage(
      "Description cannot exceed 500 characters",
    ),
    "doYouWantToVisitThePrivacyPolicy": MessageLookupByLibrary.simpleMessage(
      "Do you want to visit the privacy policy?",
    ),
    "doYouWantToVisitTheTermsOfService": MessageLookupByLibrary.simpleMessage(
      "Do you want to visit the terms of service?",
    ),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "download": MessageLookupByLibrary.simpleMessage("Download"),
    "dragToReorder": MessageLookupByLibrary.simpleMessage("Drag to reorder"),
    "dutch": MessageLookupByLibrary.simpleMessage("Dutch"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editItem": MessageLookupByLibrary.simpleMessage("Edit item"),
    "editLanguage": MessageLookupByLibrary.simpleMessage("Edit Language"),
    "editName": MessageLookupByLibrary.simpleMessage("Edit Name"),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit profile"),
    "editShoppingListDetails": MessageLookupByLibrary.simpleMessage(
      "Edit shopping list details",
    ),
    "editTask": MessageLookupByLibrary.simpleMessage("Edit Task"),
    "editYourShoppingList": MessageLookupByLibrary.simpleMessage(
      "Edit your shopping list",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailAlreadyInUseMessage": MessageLookupByLibrary.simpleMessage(
      "The email used already exists, please use a different email or try to log in.",
    ),
    "emailAlreadyInUseTitle": MessageLookupByLibrary.simpleMessage(
      "Email already in use",
    ),
    "emailHint": MessageLookupByLibrary.simpleMessage("your@email.com"),
    "emailInputFieldLabel": MessageLookupByLibrary.simpleMessage(
      "Email input field",
    ),
    "emailNotVerifiedMessage": MessageLookupByLibrary.simpleMessage(
      "Could not verify your email at this time. Please try again later.",
    ),
    "emailNotVerifiedTitle": MessageLookupByLibrary.simpleMessage(
      "Email Not Verified",
    ),
    "emailNotYetVerified": MessageLookupByLibrary.simpleMessage(
      "Email not yet verified",
    ),
    "emailSent": MessageLookupByLibrary.simpleMessage("Email Sent"),
    "emailVerified": MessageLookupByLibrary.simpleMessage("Email verified"),
    "emailVerifiedTitle": MessageLookupByLibrary.simpleMessage(
      "Email verified",
    ),
    "emergencyContact": MessageLookupByLibrary.simpleMessage(
      "Emergency Contact",
    ),
    "emptyPlaceholderAnEmptyList": MessageLookupByLibrary.simpleMessage(
      "An empty list is a clear sky; what will you build?",
    ),
    "emptyPlaceholderBlankCanvas": MessageLookupByLibrary.simpleMessage(
      "A blank canvas awaits your masterpiece.",
    ),
    "emptyPlaceholderEmptySpaces": MessageLookupByLibrary.simpleMessage(
      "Empty spaces are just rooms for growth.",
    ),
    "emptyPlaceholderNoEntries": MessageLookupByLibrary.simpleMessage(
      "No entries yet, but infinite potential.",
    ),
    "emptyPlaceholderNotAVoid": MessageLookupByLibrary.simpleMessage(
      "This is not a void, it\'s a stage.",
    ),
    "emptyPlaceholderNotSadJustEmpty": MessageLookupByLibrary.simpleMessage(
      "Not sad, just empty.",
    ),
    "emptyPlaceholderNothingHere": MessageLookupByLibrary.simpleMessage(
      "Nothing here but possibilities.",
    ),
    "emptyPlaceholderTheEmptiness": MessageLookupByLibrary.simpleMessage(
      "The emptiness you see is the space for your next achievement.",
    ),
    "emptyPlaceholderTheEmptinessIsNotALack":
        MessageLookupByLibrary.simpleMessage(
          "The emptiness is not a lack, but a space to fill.",
        ),
    "emptyPlaceholderZeroItems": MessageLookupByLibrary.simpleMessage(
      "Zero items, endless opportunity.",
    ),
    "emptySubtasksMessage": MessageLookupByLibrary.simpleMessage(
      "No subtasks yet. Add one above!",
    ),
    "enableNotifications": MessageLookupByLibrary.simpleMessage(
      "Enable Notifications",
    ),
    "enableNotificationsDescription": MessageLookupByLibrary.simpleMessage(
      "Receive push notifications for updates.",
    ),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterADescriptionForYourShoppingList":
        MessageLookupByLibrary.simpleMessage(
          "Enter a description for your shopping list",
        ),
    "enterANameForYourShoppingList": MessageLookupByLibrary.simpleMessage(
      "Enter a name for your shopping list",
    ),
    "enterAValidEmail": MessageLookupByLibrary.simpleMessage(
      "Enter a valid email",
    ),
    "enterDetailsToRegister": MessageLookupByLibrary.simpleMessage(
      "Enter your details to register",
    ),
    "enterInviteCode": MessageLookupByLibrary.simpleMessage("Enter Code"),
    "enterTheNameForTheNewShoppingList": MessageLookupByLibrary.simpleMessage(
      "Enter the name for the new shopping list. This will be visible to all members.",
    ),
    "enterTheNewNameForTheHouseholdThisWillBe":
        MessageLookupByLibrary.simpleMessage(
          "Enter the new name for the household. This will be visible to all members.",
        ),
    "enterValidNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid number.",
    ),
    "enterValidPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid phone number",
    ),
    "enterValidURL": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid URL",
    ),
    "enterValueBetween1And31": MessageLookupByLibrary.simpleMessage(
      "Enter a value between 1 and 31",
    ),
    "enterWhatWasExpectedAndWhatActuallyHappened":
        MessageLookupByLibrary.simpleMessage(
          "Enter what was expected and what actually happened.",
        ),
    "enterYourEmail": MessageLookupByLibrary.simpleMessage("Enter your email"),
    "enterYourIdeaForAnImprovementOrFeatureRequest":
        MessageLookupByLibrary.simpleMessage(
          "Enter your idea for an improvement or feature request.",
        ),
    "enterYourPassword": MessageLookupByLibrary.simpleMessage(
      "Enter your password",
    ),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorAlreadyMember": MessageLookupByLibrary.simpleMessage(
      "You are already a member of this household",
    ),
    "errorCreatingCleaningTask": MessageLookupByLibrary.simpleMessage(
      "Error creating cleaning task",
    ),
    "errorHouseholdFull": MessageLookupByLibrary.simpleMessage(
      "This household has reached the maximum number of members",
    ),
    "errorInvalidCodeFormat": MessageLookupByLibrary.simpleMessage(
      "Invalid invite code format. The code should be 4 letters/numbers.",
    ),
    "errorInvalidInviteCode": MessageLookupByLibrary.simpleMessage(
      "The invite code is invalid. Please check and try again.",
    ),
    "errorNotFound": MessageLookupByLibrary.simpleMessage(
      "The requested item was not found",
    ),
    "errorPendingInvite": MessageLookupByLibrary.simpleMessage(
      "You already have a pending invite to this household",
    ),
    "errorPermissionDenied": MessageLookupByLibrary.simpleMessage(
      "You don\'t have permission to perform this action",
    ),
    "errorRateLimited": MessageLookupByLibrary.simpleMessage(
      "Too many attempts. Please try again later.",
    ),
    "errorTitle": MessageLookupByLibrary.simpleMessage("Error"),
    "errorUnauthenticated": MessageLookupByLibrary.simpleMessage(
      "Please log in to continue",
    ),
    "errorUpdatingCleaningTask": MessageLookupByLibrary.simpleMessage(
      "Error updating cleaning task",
    ),
    "errorUserNotFound": MessageLookupByLibrary.simpleMessage(
      "User profile not found. Please complete your profile setup.",
    ),
    "every": MessageLookupByLibrary.simpleMessage("Every"),
    "failedToAcceptInvitePleaseTryAgainLaterAndContact":
        MessageLookupByLibrary.simpleMessage(
          "Failed to accept invite, please try again later and contact us if the problem persists.",
        ),
    "failedToAddItem": MessageLookupByLibrary.simpleMessage(
      "Failed to add item",
    ),
    "failedToAddSubtask": MessageLookupByLibrary.simpleMessage(
      "Failed to add subtask",
    ),
    "failedToAssignTaskPleaseTryAgain": MessageLookupByLibrary.simpleMessage(
      "Failed to assign task. Please try again.",
    ),
    "failedToCallCloudFunction": MessageLookupByLibrary.simpleMessage(
      "Failed to call cloud function",
    ),
    "failedToCancelInvitePleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Failed to cancel invite right now, please try again later.",
        ),
    "failedToClaimTaskPleaseTryAgain": MessageLookupByLibrary.simpleMessage(
      "Failed to claim task. Please try again.",
    ),
    "failedToCompleteTask": MessageLookupByLibrary.simpleMessage(
      "Failed to complete task",
    ),
    "failedToCreateCleaningTaskPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Failed to create cleaning task, please try again later",
        ),
    "failedToDeclineInviteRightNowPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Failed to decline invite right now, please try again later and contact us if the problem persist.",
        ),
    "failedToDeleteAccountMessage": MessageLookupByLibrary.simpleMessage(
      "An unknown error occurred while trying to delete your account.",
    ),
    "failedToDeleteAccountTitle": MessageLookupByLibrary.simpleMessage(
      "Failed to delete account",
    ),
    "failedToDeleteImagePleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Failed to delete image. Please try again later.",
        ),
    "failedToDeleteItemMessage": MessageLookupByLibrary.simpleMessage(
      "An error occurred while deleting the item. Please try again.",
    ),
    "failedToDeleteItemPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Failed to delete item. Please try again later.",
        ),
    "failedToDeleteItemTitle": MessageLookupByLibrary.simpleMessage(
      "Failed to delete item",
    ),
    "failedToDeleteShoppingListPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Failed to delete shopping list. Please try again later.",
        ),
    "failedToDeleteSubtask": MessageLookupByLibrary.simpleMessage(
      "Failed to delete subtask",
    ),
    "failedToDeleteTaskPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Failed to delete task. Please try again later.",
        ),
    "failedToDownloadImage": MessageLookupByLibrary.simpleMessage(
      "Failed to download image",
    ),
    "failedToLoadCleaningTasks": MessageLookupByLibrary.simpleMessage(
      "Failed to load cleaning tasks. Please try again.",
    ),
    "failedToLogIn": MessageLookupByLibrary.simpleMessage("Failed to log in"),
    "failedToLogInTitle": MessageLookupByLibrary.simpleMessage(
      "Failed to log in",
    ),
    "failedToNavigateToAddTask": MessageLookupByLibrary.simpleMessage(
      "Failed to navigate to add task. Please try again.",
    ),
    "failedToNavigateToTask": MessageLookupByLibrary.simpleMessage(
      "Failed to navigate to task. Please try again.",
    ),
    "failedToRemoveMemberRightNowPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Failed to remove member right now. Please try again later.",
        ),
    "failedToReorderItemsPleaseTryAgain": MessageLookupByLibrary.simpleMessage(
      "Failed to reorder items, please try again.",
    ),
    "failedToReorderSubtasks": MessageLookupByLibrary.simpleMessage(
      "Failed to reorder subtasks",
    ),
    "failedToSelectImagePleaseTryAgainIfTheProblem":
        MessageLookupByLibrary.simpleMessage(
          "Failed to select image. Please try again. If the problem persists, please contact support.",
        ),
    "failedToSendInvite": MessageLookupByLibrary.simpleMessage(
      "Failed to send invite",
    ),
    "failedToShowAssignmentOptions": MessageLookupByLibrary.simpleMessage(
      "Failed to show assignment options.",
    ),
    "failedToTakePhotoPleaseTryAgainIfTheProblem":
        MessageLookupByLibrary.simpleMessage(
          "Failed to take photo. Please try again. If the problem persists, please contact support.",
        ),
    "failedToUnassignTaskPleaseTryAgain": MessageLookupByLibrary.simpleMessage(
      "Failed to unassign task. Please try again.",
    ),
    "failedToUncheckAllItems": MessageLookupByLibrary.simpleMessage(
      "Failed to uncheck all items",
    ),
    "failedToUncompleteTask": MessageLookupByLibrary.simpleMessage(
      "Failed to uncomplete task",
    ),
    "failedToUpdateCleaningTaskPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Failed to update cleaning task, please try again later",
        ),
    "failedToUpdateName": MessageLookupByLibrary.simpleMessage(
      "Failed to update name",
    ),
    "failedToUpdateShoppingList": MessageLookupByLibrary.simpleMessage(
      "Failed to update shopping list",
    ),
    "failedToUpdateSubtask": MessageLookupByLibrary.simpleMessage(
      "Failed to update subtask",
    ),
    "failedToUpdateSubtaskMessage": MessageLookupByLibrary.simpleMessage(
      "Failed to update subtask. Please try again.",
    ),
    "failedToUpdateTimeSlots": MessageLookupByLibrary.simpleMessage(
      "Failed to update time slots",
    ),
    "failedToUploadImagePleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Failed to upload image. Please try again later.",
        ),
    "feb": MessageLookupByLibrary.simpleMessage("feb"),
    "february": MessageLookupByLibrary.simpleMessage("february"),
    "feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
    "feedbackButton_tooltip": MessageLookupByLibrary.simpleMessage(
      "Send feedback",
    ),
    "feedbackSubmitted": MessageLookupByLibrary.simpleMessage(
      "Feedback submitted",
    ),
    "fillInYourBiography": MessageLookupByLibrary.simpleMessage(
      "Fill in your biography",
    ),
    "fillInYourEmail": MessageLookupByLibrary.simpleMessage(
      "Fill in your email",
    ),
    "fillInYourEmailAddressAndWeWillSendYou":
        MessageLookupByLibrary.simpleMessage("Fill in your email address."),
    "fillInYourLink": MessageLookupByLibrary.simpleMessage("Fill in your link"),
    "fillInYourPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Fill in your phone number",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "frequencyCountPlaceholder": MessageLookupByLibrary.simpleMessage("e.g. 2"),
    "frequencyMode": MessageLookupByLibrary.simpleMessage("Times per period"),
    "frequencyModeExample": MessageLookupByLibrary.simpleMessage(
      "e.g., \"2 times per week\" or \"4 times per month\"",
    ),
    "fri": MessageLookupByLibrary.simpleMessage("fri"),
    "friday": MessageLookupByLibrary.simpleMessage("friday"),
    "friendsTeachUsTrustRoommatesTeachUsHarmony":
        MessageLookupByLibrary.simpleMessage("The chosen few."),
    "gallery": MessageLookupByLibrary.simpleMessage("Gallery"),
    "general": MessageLookupByLibrary.simpleMessage("General"),
    "generalSettingsInTheApp": MessageLookupByLibrary.simpleMessage(
      "General settings in the app.",
    ),
    "generateInviteCode": MessageLookupByLibrary.simpleMessage(
      "Generate Invite Code",
    ),
    "generatingInviteCode": MessageLookupByLibrary.simpleMessage(
      "Generating invite code...",
    ),
    "goBack": MessageLookupByLibrary.simpleMessage("Go back"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it"),
    "helloUsername": m6,
    "hiddenPass": MessageLookupByLibrary.simpleMessage("••••••••"),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "homeScreenLabel": MessageLookupByLibrary.simpleMessage("Home screen"),
    "hoursAgo": m7,
    "household": MessageLookupByLibrary.simpleMessage("Household"),
    "householdCreated": m8,
    "householdInvite": MessageLookupByLibrary.simpleMessage("Household Invite"),
    "householdInvites": MessageLookupByLibrary.simpleMessage(
      "Household Invites",
    ),
    "householdNameAdjectiveBusy": MessageLookupByLibrary.simpleMessage("Busy"),
    "householdNameAdjectiveCharming": MessageLookupByLibrary.simpleMessage(
      "Charming",
    ),
    "householdNameAdjectiveCheerful": MessageLookupByLibrary.simpleMessage(
      "Cheerful",
    ),
    "householdNameAdjectiveComfy": MessageLookupByLibrary.simpleMessage(
      "Comfy",
    ),
    "householdNameAdjectiveCozy": MessageLookupByLibrary.simpleMessage("Cozy"),
    "householdNameAdjectiveCreative": MessageLookupByLibrary.simpleMessage(
      "Creative",
    ),
    "householdNameAdjectiveCute": MessageLookupByLibrary.simpleMessage("Cute"),
    "householdNameAdjectiveFriendly": MessageLookupByLibrary.simpleMessage(
      "Friendly",
    ),
    "householdNameAdjectiveHappy": MessageLookupByLibrary.simpleMessage(
      "Happy",
    ),
    "householdNameAdjectiveInviting": MessageLookupByLibrary.simpleMessage(
      "Inviting",
    ),
    "householdNameAdjectiveLively": MessageLookupByLibrary.simpleMessage(
      "Lively",
    ),
    "householdNameAdjectiveModern": MessageLookupByLibrary.simpleMessage(
      "Modern",
    ),
    "householdNameAdjectivePeaceful": MessageLookupByLibrary.simpleMessage(
      "Peaceful",
    ),
    "householdNameAdjectiveQuaint": MessageLookupByLibrary.simpleMessage(
      "Quaint",
    ),
    "householdNameAdjectiveQuiet": MessageLookupByLibrary.simpleMessage(
      "Quiet",
    ),
    "householdNameAdjectiveRelaxed": MessageLookupByLibrary.simpleMessage(
      "Relaxed",
    ),
    "householdNameAdjectiveRustic": MessageLookupByLibrary.simpleMessage(
      "Rustic",
    ),
    "householdNameAdjectiveSecluded": MessageLookupByLibrary.simpleMessage(
      "Secluded",
    ),
    "householdNameAdjectiveSerene": MessageLookupByLibrary.simpleMessage(
      "Serene",
    ),
    "householdNameAdjectiveShared": MessageLookupByLibrary.simpleMessage(
      "Shared",
    ),
    "householdNameAdjectiveSnug": MessageLookupByLibrary.simpleMessage("Snug"),
    "householdNameAdjectiveSunny": MessageLookupByLibrary.simpleMessage(
      "Sunny",
    ),
    "householdNameAdjectiveTranquil": MessageLookupByLibrary.simpleMessage(
      "Tranquil",
    ),
    "householdNameAdjectiveVibrant": MessageLookupByLibrary.simpleMessage(
      "Vibrant",
    ),
    "householdNameAdjectiveWarm": MessageLookupByLibrary.simpleMessage("Warm"),
    "householdNameMustBeAtLeast3CharactersLong":
        MessageLookupByLibrary.simpleMessage(
          "Household name must be at least 3 characters long",
        ),
    "householdNameMustBeAtMost50CharactersLong":
        MessageLookupByLibrary.simpleMessage(
          "Household name must be at most 50 characters long",
        ),
    "householdNameNounAbode": MessageLookupByLibrary.simpleMessage("Abode"),
    "householdNameNounBase": MessageLookupByLibrary.simpleMessage("Base"),
    "householdNameNounCabin": MessageLookupByLibrary.simpleMessage("Cabin"),
    "householdNameNounCastle": MessageLookupByLibrary.simpleMessage("Castle"),
    "householdNameNounCorner": MessageLookupByLibrary.simpleMessage("Corner"),
    "householdNameNounCottage": MessageLookupByLibrary.simpleMessage("Cottage"),
    "householdNameNounCrew": MessageLookupByLibrary.simpleMessage("Crew"),
    "householdNameNounDen": MessageLookupByLibrary.simpleMessage("Den"),
    "householdNameNounDwelling": MessageLookupByLibrary.simpleMessage(
      "Dwelling",
    ),
    "householdNameNounFamily": MessageLookupByLibrary.simpleMessage("Family"),
    "householdNameNounHangout": MessageLookupByLibrary.simpleMessage("Hangout"),
    "householdNameNounHaven": MessageLookupByLibrary.simpleMessage("Haven"),
    "householdNameNounHeadquarters": MessageLookupByLibrary.simpleMessage(
      "Headquarters",
    ),
    "householdNameNounHideaway": MessageLookupByLibrary.simpleMessage(
      "Hideaway",
    ),
    "householdNameNounHome": MessageLookupByLibrary.simpleMessage("Home"),
    "householdNameNounHub": MessageLookupByLibrary.simpleMessage("Hub"),
    "householdNameNounLodge": MessageLookupByLibrary.simpleMessage("Lodge"),
    "householdNameNounNest": MessageLookupByLibrary.simpleMessage("Nest"),
    "householdNameNounOasis": MessageLookupByLibrary.simpleMessage("Oasis"),
    "householdNameNounPad": MessageLookupByLibrary.simpleMessage("Pad"),
    "householdNameNounPlace": MessageLookupByLibrary.simpleMessage("Place"),
    "householdNameNounRetreat": MessageLookupByLibrary.simpleMessage("Retreat"),
    "householdNameNounSanctuary": MessageLookupByLibrary.simpleMessage(
      "Sanctuary",
    ),
    "householdNameNounSpot": MessageLookupByLibrary.simpleMessage("Spot"),
    "householdNameNounSquad": MessageLookupByLibrary.simpleMessage("Squad"),
    "householdRequests": MessageLookupByLibrary.simpleMessage(
      "Household Requests",
    ),
    "householdsThatYouHaveBeenInvitedTo": MessageLookupByLibrary.simpleMessage(
      "Households that you have been invited to.",
    ),
    "householdsYouRequestedToJoin": MessageLookupByLibrary.simpleMessage(
      "Waiting for approval from",
    ),
    "howToSplitPayment": MessageLookupByLibrary.simpleMessage(
      "How to split the payment",
    ),
    "iAgreeToThe": MessageLookupByLibrary.simpleMessage("I agree to the"),
    "idea": m9,
    "ifRegisteredWeSend": m10,
    "imageDeleted": MessageLookupByLibrary.simpleMessage("Image deleted"),
    "imageSavedToGallery": MessageLookupByLibrary.simpleMessage(
      "Image saved to gallery",
    ),
    "imageUploaded": MessageLookupByLibrary.simpleMessage("Image uploaded"),
    "inDays": m11,
    "inMonths": m12,
    "inOneDay": MessageLookupByLibrary.simpleMessage("in 1 day"),
    "inOneMonth": MessageLookupByLibrary.simpleMessage("in 1 month"),
    "inOnePlusWeek": MessageLookupByLibrary.simpleMessage("in 1+ week"),
    "inWeeks": m13,
    "inWeeksPlus": m14,
    "inbox": MessageLookupByLibrary.simpleMessage("Inbox"),
    "increase": MessageLookupByLibrary.simpleMessage("Increase"),
    "intervalMode": MessageLookupByLibrary.simpleMessage("Repeat every..."),
    "intervalModeExample": MessageLookupByLibrary.simpleMessage(
      "e.g., \"Every 3 days\" or \"Every 2 weeks\"",
    ),
    "intervalValuePlaceholder": MessageLookupByLibrary.simpleMessage("e.g. 3"),
    "invalidCredentialMessage": MessageLookupByLibrary.simpleMessage(
      "Something went wrong verifying the credential, please try again.",
    ),
    "invalidCredentialTitle": MessageLookupByLibrary.simpleMessage(
      "Invalid credential",
    ),
    "invalidCredentialsMessage": MessageLookupByLibrary.simpleMessage(
      "The credentials provided are invalid, please try again.",
    ),
    "invalidCredentialsTitle": MessageLookupByLibrary.simpleMessage(
      "Invalid credentials",
    ),
    "invalidDayOfMonth": MessageLookupByLibrary.simpleMessage(
      "Day of month must be between 1 and 31",
    ),
    "invalidEmailMessage": MessageLookupByLibrary.simpleMessage(
      "The email address provided is invalid, please try again.",
    ),
    "invalidEmailTitle": MessageLookupByLibrary.simpleMessage("Invalid email"),
    "invalidFrequencyCount": MessageLookupByLibrary.simpleMessage(
      "Frequency count must be greater than 0",
    ),
    "invalidIntervalValue": MessageLookupByLibrary.simpleMessage(
      "Interval value must be greater than 0",
    ),
    "invalidPhoneNumberMessage": MessageLookupByLibrary.simpleMessage(
      "The phone number has an invalid format. Please input a valid phone number.",
    ),
    "invalidPhoneNumberTitle": MessageLookupByLibrary.simpleMessage(
      "Invalid Phone Number",
    ),
    "invalidQuantity": MessageLookupByLibrary.simpleMessage("Invalid quantity"),
    "invalidTimeSlot": MessageLookupByLibrary.simpleMessage(
      "Invalid Time Slot",
    ),
    "invalidVerificationCodeMessage": MessageLookupByLibrary.simpleMessage(
      "The verification code of the credential is invalid, please try again.",
    ),
    "invalidVerificationCodeTitle": MessageLookupByLibrary.simpleMessage(
      "Invalid verification code",
    ),
    "invalidVerificationIdMessage": MessageLookupByLibrary.simpleMessage(
      "The verification id of the credential is invalid, please try again.",
    ),
    "invalidVerificationIdTitle": MessageLookupByLibrary.simpleMessage(
      "Invalid verification id",
    ),
    "invite": MessageLookupByLibrary.simpleMessage("Invite"),
    "inviteAccepted": MessageLookupByLibrary.simpleMessage("Invite accepted!"),
    "inviteCanceled": MessageLookupByLibrary.simpleMessage("Invite canceled!"),
    "inviteCode": MessageLookupByLibrary.simpleMessage("Invite Code"),
    "inviteCodeCopied": MessageLookupByLibrary.simpleMessage(
      "Invite code copied to clipboard",
    ),
    "inviteCodeInvalid": MessageLookupByLibrary.simpleMessage(
      "Invalid code. Check and try again.",
    ),
    "inviteCodeMustBeExactly4Characters": MessageLookupByLibrary.simpleMessage(
      "Code must be 4 characters",
    ),
    "inviteCodeRequired": MessageLookupByLibrary.simpleMessage(
      "Enter code (4 characters)",
    ),
    "inviteDeclined": MessageLookupByLibrary.simpleMessage("Invite declined!"),
    "inviteHouseholdMessage": MessageLookupByLibrary.simpleMessage(
      "Enter username to invite.",
    ),
    "inviteSent": MessageLookupByLibrary.simpleMessage("Invite sent"),
    "inviteSentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Invite sent",
    ),
    "invited": MessageLookupByLibrary.simpleMessage("Invited"),
    "invitesEmoji": MessageLookupByLibrary.simpleMessage("📨  "),
    "invitesSentToOthersToJoinYourHousehold":
        MessageLookupByLibrary.simpleMessage(
          "Invites sent to others to join your household.",
        ),
    "item": MessageLookupByLibrary.simpleMessage("Item"),
    "itemAdded": MessageLookupByLibrary.simpleMessage("Item added"),
    "itemCompleted": MessageLookupByLibrary.simpleMessage("Item completed"),
    "itemDeleted": MessageLookupByLibrary.simpleMessage("Item deleted"),
    "itemImageDescription": MessageLookupByLibrary.simpleMessage("Item image"),
    "itemUncompleted": MessageLookupByLibrary.simpleMessage("Item uncompleted"),
    "itemUpdated": MessageLookupByLibrary.simpleMessage("Item updated"),
    "jan": MessageLookupByLibrary.simpleMessage("jan"),
    "january": MessageLookupByLibrary.simpleMessage("january"),
    "joinHousehold": MessageLookupByLibrary.simpleMessage("Join Household"),
    "joinHouseholdScan": MessageLookupByLibrary.simpleMessage("Scan to Join"),
    "joinOrLeaveAHousehold": MessageLookupByLibrary.simpleMessage(
      "Join or leave a household.",
    ),
    "joinRequestSent": MessageLookupByLibrary.simpleMessage(
      "Join Request Sent",
    ),
    "joinRequests": MessageLookupByLibrary.simpleMessage("Join Requests"),
    "jul": MessageLookupByLibrary.simpleMessage("jul"),
    "july": MessageLookupByLibrary.simpleMessage("july"),
    "jun": MessageLookupByLibrary.simpleMessage("jun"),
    "june": MessageLookupByLibrary.simpleMessage("june"),
    "justNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "languageChanged": MessageLookupByLibrary.simpleMessage("Language changed"),
    "languageChangedToSupportedLanguage": m15,
    "languageNameDutchEN": MessageLookupByLibrary.simpleMessage("Dutch"),
    "languageNameEngelsNL": MessageLookupByLibrary.simpleMessage("Engels"),
    "languageNameEnglishEN": MessageLookupByLibrary.simpleMessage("English"),
    "languageNameNederlandsNL": MessageLookupByLibrary.simpleMessage(
      "Nederlands",
    ),
    "lastUpdateAtString": m16,
    "lastWeek": MessageLookupByLibrary.simpleMessage("Last Week"),
    "lazyLoading": MessageLookupByLibrary.simpleMessage("Lazy Loading"),
    "leave": MessageLookupByLibrary.simpleMessage("Leave"),
    "leaveAndJoin": MessageLookupByLibrary.simpleMessage("Leave"),
    "leaveCurrentHousehold": MessageLookupByLibrary.simpleMessage(
      "Leave Current Household?",
    ),
    "leaveHousehold": MessageLookupByLibrary.simpleMessage("Leave household"),
    "leaveJoin": MessageLookupByLibrary.simpleMessage("Leave"),
    "link": MessageLookupByLibrary.simpleMessage("Link"),
    "linkHint": MessageLookupByLibrary.simpleMessage(
      "e.g. https://twitter.com/username",
    ),
    "list": MessageLookupByLibrary.simpleMessage("List"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading"),
    "loggedIn": MessageLookupByLibrary.simpleMessage("Logged in"),
    "loggedInTitle": MessageLookupByLibrary.simpleMessage("Logged in"),
    "loggedOut": MessageLookupByLibrary.simpleMessage("Logged out"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginButtonLabel": MessageLookupByLibrary.simpleMessage("Login button"),
    "loginFailedTitle": MessageLookupByLibrary.simpleMessage("Login failed"),
    "loginToAccount": m17,
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutButtonLabel": MessageLookupByLibrary.simpleMessage("Logout button"),
    "logoutFailed": MessageLookupByLibrary.simpleMessage("Logout failed"),
    "logoutFailedTitle": MessageLookupByLibrary.simpleMessage("Logout failed"),
    "logoutSuccessfulMessage": MessageLookupByLibrary.simpleMessage(
      "You are no longer logged in.",
    ),
    "logoutSuccessfulTitle": MessageLookupByLibrary.simpleMessage(
      "Logout successful",
    ),
    "mainShoppingList": MessageLookupByLibrary.simpleMessage(
      "Main Shopping List",
    ),
    "manage": MessageLookupByLibrary.simpleMessage("Manage"),
    "manageCleaningTask": MessageLookupByLibrary.simpleMessage(
      "Manage Cleaning Task",
    ),
    "manageHouseholdMembers": MessageLookupByLibrary.simpleMessage(
      "Manage household members",
    ),
    "managePendingInvitesToJoinADifferentHousehold":
        MessageLookupByLibrary.simpleMessage(
          "Manage pending invites to join a different household",
        ),
    "managePendingInvitesToJoinThisHousehold":
        MessageLookupByLibrary.simpleMessage(
          "Manage pending invites to join this household.",
        ),
    "manageYourHouseholdMembersAndSettings":
        MessageLookupByLibrary.simpleMessage("Home sweet home."),
    "manageYourShoppingListsAndItems": MessageLookupByLibrary.simpleMessage(
      "Shopping made easy.",
    ),
    "management": MessageLookupByLibrary.simpleMessage("Management"),
    "mar": MessageLookupByLibrary.simpleMessage("mar"),
    "march": MessageLookupByLibrary.simpleMessage("march"),
    "markAllAsRead": MessageLookupByLibrary.simpleMessage("Mark all as read"),
    "maxLengthExceeded": m18,
    "maximumHouseholdMembersReached": MessageLookupByLibrary.simpleMessage(
      "Maximum number of household members reached",
    ),
    "maximumHouseholdMembersReachedMessage": MessageLookupByLibrary.simpleMessage(
      "This household has reached its maximum member limit. Please contact the household owner if you believe this is an error.",
    ),
    "maximumSkipsReached": MessageLookupByLibrary.simpleMessage(
      "Maximum Skips Reached",
    ),
    "maximumValueExceeded": m19,
    "may": MessageLookupByLibrary.simpleMessage("may"),
    "me": MessageLookupByLibrary.simpleMessage("Me"),
    "member": MessageLookupByLibrary.simpleMessage("Member"),
    "memberRemoved": MessageLookupByLibrary.simpleMessage("Member removed!"),
    "memberSinceCreatedAtString": m20,
    "memberSinceDate": m21,
    "memberStatisticsDescription": MessageLookupByLibrary.simpleMessage(
      "Member statistics",
    ),
    "members": MessageLookupByLibrary.simpleMessage("Members"),
    "messageMustBeLessThan500Characters": MessageLookupByLibrary.simpleMessage(
      "Message must be less than 500 characters",
    ),
    "minimumValueRequired": m22,
    "minute": MessageLookupByLibrary.simpleMessage("minute"),
    "minutes": MessageLookupByLibrary.simpleMessage("minutes"),
    "minutesAgo": m23,
    "missingList": MessageLookupByLibrary.simpleMessage("Missing List"),
    "mon": MessageLookupByLibrary.simpleMessage("mon"),
    "monday": MessageLookupByLibrary.simpleMessage("monday"),
    "month": MessageLookupByLibrary.simpleMessage("month"),
    "months": MessageLookupByLibrary.simpleMessage("months"),
    "myCleaningSchedule": MessageLookupByLibrary.simpleMessage(
      "My Cleaning Schedule",
    ),
    "myHousehold": MessageLookupByLibrary.simpleMessage("My Household"),
    "myInvites": MessageLookupByLibrary.simpleMessage("My Invites"),
    "myInvitesEmoji": MessageLookupByLibrary.simpleMessage("📨  "),
    "myRequests": MessageLookupByLibrary.simpleMessage("My Requests"),
    "myRoomies": MessageLookupByLibrary.simpleMessage("My Roomies"),
    "myShoppingLists": MessageLookupByLibrary.simpleMessage(
      "My Shopping Lists",
    ),
    "myTasks": MessageLookupByLibrary.simpleMessage("My Tasks"),
    "myTasksDescription": MessageLookupByLibrary.simpleMessage(
      "Here you can find all tasks assigned to you.",
    ),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameCanBeAtMost": m24,
    "nameChangedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Name changed successfully",
    ),
    "nameMustBeLessThan50Characters": MessageLookupByLibrary.simpleMessage(
      "Name must be less than 50 characters",
    ),
    "networkErrorTitle": MessageLookupByLibrary.simpleMessage("Network Error"),
    "nextDeadline": MessageLookupByLibrary.simpleMessage("Next Deadline"),
    "nextDue": m25,
    "nextWeek": MessageLookupByLibrary.simpleMessage("Next Week"),
    "noCleaningTasksYet": MessageLookupByLibrary.simpleMessage(
      "No cleaning tasks yet!",
    ),
    "noCount": MessageLookupByLibrary.simpleMessage("-"),
    "noDataAvailable": MessageLookupByLibrary.simpleMessage(
      "No data available",
    ),
    "noDataAvailableForTimeframe": MessageLookupByLibrary.simpleMessage(
      "No data available for this timeframe, yet.",
    ),
    "noDeadline": MessageLookupByLibrary.simpleMessage("No deadline"),
    "noDescription": MessageLookupByLibrary.simpleMessage("No description"),
    "noHouseholdFound": MessageLookupByLibrary.simpleMessage(
      "No Household Found",
    ),
    "noHouseholdMembersAvailableForAssignment":
        MessageLookupByLibrary.simpleMessage(
          "No household members available for assignment.",
        ),
    "noInstructionsProvided": MessageLookupByLibrary.simpleMessage(
      "No instructions provided",
    ),
    "noInviteCodeAvailable": MessageLookupByLibrary.simpleMessage(
      "No invite code found, try again later!",
    ),
    "noItems": MessageLookupByLibrary.simpleMessage("No items"),
    "noPaymentsInPeriod": MessageLookupByLibrary.simpleMessage(
      "No payments in this period",
    ),
    "noPaymentsYet": MessageLookupByLibrary.simpleMessage("No payments yet!"),
    "noRecurrence": MessageLookupByLibrary.simpleMessage("No recurrence"),
    "noResultsPlaceholderAnEmptyList": MessageLookupByLibrary.simpleMessage(
      "An empty list is a prompt for new perspectives.",
    ),
    "noResultsPlaceholderConsiderADifferent":
        MessageLookupByLibrary.simpleMessage(
          "Consider a different approach or term.",
        ),
    "noResultsPlaceholderEmbraceThis": MessageLookupByLibrary.simpleMessage(
      "Embrace this empty list as a moment of calm.",
    ),
    "noResultsPlaceholderInThisMoment": MessageLookupByLibrary.simpleMessage(
      "In this moment, no results arise.",
    ),
    "noResultsPlaceholderMaybeWhatYoureLooking":
        MessageLookupByLibrary.simpleMessage(
          "Maybe what you\'re looking for is hidden in another perspective.",
        ),
    "noResultsPlaceholderNoAnswers": MessageLookupByLibrary.simpleMessage(
      "No answers here.",
    ),
    "noResultsPlaceholderNoMatches": MessageLookupByLibrary.simpleMessage(
      "No matches here. Reimagine your query.",
    ),
    "noResultsPlaceholderNoResults": MessageLookupByLibrary.simpleMessage(
      "No results found.",
    ),
    "noResultsPlaceholderNothingFound": MessageLookupByLibrary.simpleMessage(
      "Nothing found here.",
    ),
    "noResultsPlaceholderNothingMatched": MessageLookupByLibrary.simpleMessage(
      "Nothing matched your query.",
    ),
    "noResultsPlaceholderPerhapsItsTime": MessageLookupByLibrary.simpleMessage(
      "Perhaps it\'s time to ask a different question.",
    ),
    "noResultsPlaceholderPerhapsItsTimeToTake":
        MessageLookupByLibrary.simpleMessage(
          "Perhaps it\'s time to take a different route.",
        ),
    "noResultsPlaceholderPerhapsTheAnswer":
        MessageLookupByLibrary.simpleMessage(
          "Perhaps the answer lies elsewhere.",
        ),
    "noResultsPlaceholderSeekInAnother": MessageLookupByLibrary.simpleMessage(
      "Seek in another direction with sharper focus.",
    ),
    "noResultsPlaceholderTheOutcome": MessageLookupByLibrary.simpleMessage(
      "The outcome is clear: nothing found. How will you adapt?",
    ),
    "noResultsPlaceholderTheSearchIsOver": MessageLookupByLibrary.simpleMessage(
      "The search is over, but the journey continues.",
    ),
    "noResultsPlaceholderTheSearchReveals":
        MessageLookupByLibrary.simpleMessage("The search reveals absence."),
    "noRoomies": MessageLookupByLibrary.simpleMessage("No Roomies"),
    "noTasksAssignedToYou": MessageLookupByLibrary.simpleMessage(
      "No tasks assigned to you yet",
    ),
    "none": MessageLookupByLibrary.simpleMessage("None"),
    "notAssignedToAnyone": MessageLookupByLibrary.simpleMessage(
      "Not assigned to anyone.",
    ),
    "notFound": MessageLookupByLibrary.simpleMessage("Not found"),
    "notSadJustEmpty": MessageLookupByLibrary.simpleMessage(
      "Not sad, just empty.",
    ),
    "notSet": MessageLookupByLibrary.simpleMessage("Not set"),
    "notVerified": MessageLookupByLibrary.simpleMessage("Not verified"),
    "notificationConsentAcceptButton": MessageLookupByLibrary.simpleMessage(
      "Enable Notifications",
    ),
    "notificationConsentBannerText": MessageLookupByLibrary.simpleMessage(
      "Enable notifications to know when your roomies go shopping",
    ),
    "notificationConsentCancelButton": MessageLookupByLibrary.simpleMessage(
      "Not Now",
    ),
    "notificationConsentSheetBody": MessageLookupByLibrary.simpleMessage(
      "Get notified when your roomies add items to shopping lists or complete tasks. Never miss an update from your household.",
    ),
    "notificationConsentSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Stay in the Loop",
    ),
    "notificationMarkedAsRead": MessageLookupByLibrary.simpleMessage(
      "Marked as read",
    ),
    "notificationPermissionDeniedInfo": MessageLookupByLibrary.simpleMessage(
      "Notification permission is disabled. Enable it in your device settings to receive updates.",
    ),
    "notificationPermissionDeniedToast": MessageLookupByLibrary.simpleMessage(
      "Notifications disabled. You can enable them later in Settings.",
    ),
    "notificationPermissionGrantedToast": MessageLookupByLibrary.simpleMessage(
      "Notifications enabled! You\'ll now receive updates from your household.",
    ),
    "notificationSettings": MessageLookupByLibrary.simpleMessage(
      "Notification Settings",
    ),
    "notificationSettingsDescription": MessageLookupByLibrary.simpleMessage(
      "Control which notifications you receive.",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "notificationsDisabled": MessageLookupByLibrary.simpleMessage(
      "Notifications disabled",
    ),
    "notificationsEnabled": MessageLookupByLibrary.simpleMessage(
      "Notifications enabled",
    ),
    "nov": MessageLookupByLibrary.simpleMessage("nov"),
    "november": MessageLookupByLibrary.simpleMessage("november"),
    "oct": MessageLookupByLibrary.simpleMessage("oct"),
    "october": MessageLookupByLibrary.simpleMessage("october"),
    "ok": MessageLookupByLibrary.simpleMessage("Ok"),
    "onceADay": MessageLookupByLibrary.simpleMessage("once a day"),
    "onceAMonth": MessageLookupByLibrary.simpleMessage("once a month"),
    "onceAWeek": MessageLookupByLibrary.simpleMessage("once a week"),
    "onceAYear": MessageLookupByLibrary.simpleMessage("once a year"),
    "onetimeTask": MessageLookupByLibrary.simpleMessage("On demand"),
    "oops": MessageLookupByLibrary.simpleMessage("Oops"),
    "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Oops! Something went wrong.",
    ),
    "openEmail": MessageLookupByLibrary.simpleMessage("Open Email"),
    "openSettings": MessageLookupByLibrary.simpleMessage("Open Settings"),
    "operationNotAllowedTitle": MessageLookupByLibrary.simpleMessage(
      "Operation not allowed",
    ),
    "optional": MessageLookupByLibrary.simpleMessage("Optional"),
    "or": MessageLookupByLibrary.simpleMessage("or"),
    "orContinueWith": MessageLookupByLibrary.simpleMessage("Or continue with"),
    "overdue": MessageLookupByLibrary.simpleMessage("Overdue"),
    "overdueDays": m26,
    "overdueOneDay": MessageLookupByLibrary.simpleMessage("overdue 1 day"),
    "overview": MessageLookupByLibrary.simpleMessage("Overview"),
    "owes": MessageLookupByLibrary.simpleMessage("owes"),
    "paid": MessageLookupByLibrary.simpleMessage("receives"),
    "participantValidationAtLeastOne": MessageLookupByLibrary.simpleMessage(
      "At least one participant must be selected.",
    ),
    "participantValidationCreatorMustParticipate":
        MessageLookupByLibrary.simpleMessage(
          "Payment creator must be a participant",
        ),
    "participantValidationManualMustSumToTotal":
        MessageLookupByLibrary.simpleMessage(
          "Manual amounts must sum to total",
        ),
    "participantValidationNoSplitWithoutParticipants":
        MessageLookupByLibrary.simpleMessage(
          "Cannot have split method without participants",
        ),
    "participantValidationPercentagesCannotExceed":
        MessageLookupByLibrary.simpleMessage(
          "Percentage total cannot exceed 100%.",
        ),
    "participantValidationPercentagesMustSumTo100":
        MessageLookupByLibrary.simpleMessage("Percentages must sum to 100%"),
    "participantValidationPercentagesMustTotal":
        MessageLookupByLibrary.simpleMessage(
          "Split percentages must total 100%.",
        ),
    "participantValidationShareGreaterThanZero":
        MessageLookupByLibrary.simpleMessage(
          "Each participant must have a share greater than 0.",
        ),
    "participantValidationSplitCannotExceed":
        MessageLookupByLibrary.simpleMessage(
          "Split total cannot exceed payment amount.",
        ),
    "participantValidationSplitMustMatch": MessageLookupByLibrary.simpleMessage(
      "Split total must match payment amount.",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordDoesNotMatch": MessageLookupByLibrary.simpleMessage(
      "Password does not match",
    ),
    "passwordInputFieldLabel": MessageLookupByLibrary.simpleMessage(
      "Password input field",
    ),
    "payment": MessageLookupByLibrary.simpleMessage("Payment"),
    "paymentCount": MessageLookupByLibrary.simpleMessage("Payments"),
    "paymentDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Payment deleted successfully",
    ),
    "paymentGeneral": MessageLookupByLibrary.simpleMessage("General"),
    "paymentGeneralDescription": MessageLookupByLibrary.simpleMessage(
      "Payment subject and general details.",
    ),
    "paymentParticipants": MessageLookupByLibrary.simpleMessage("Participants"),
    "paymentPeriodAllTime": MessageLookupByLibrary.simpleMessage("All"),
    "paymentPeriodDay": MessageLookupByLibrary.simpleMessage("Day"),
    "paymentPeriodMonth": MessageLookupByLibrary.simpleMessage("Month"),
    "paymentPeriodWeek": MessageLookupByLibrary.simpleMessage("Week"),
    "paymentPeriodYear": MessageLookupByLibrary.simpleMessage("Year"),
    "paymentSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Payment saved successfully",
    ),
    "paymentSection": MessageLookupByLibrary.simpleMessage("Payment"),
    "paymentSectionDescription": MessageLookupByLibrary.simpleMessage(
      "Payment amount and financial details.",
    ),
    "paymentSplit": MessageLookupByLibrary.simpleMessage("Split"),
    "paymentSplitMethod": MessageLookupByLibrary.simpleMessage("Split Method"),
    "paymentTotal": MessageLookupByLibrary.simpleMessage("Total"),
    "payments": MessageLookupByLibrary.simpleMessage("Payments"),
    "paymentsOverview": MessageLookupByLibrary.simpleMessage(
      "Payments Overview",
    ),
    "paymentsOverviewDescription": MessageLookupByLibrary.simpleMessage(
      "You pay some, you owe some.",
    ),
    "pending": MessageLookupByLibrary.simpleMessage("Pending"),
    "pendingInvitations": MessageLookupByLibrary.simpleMessage(
      "Pending Invitations",
    ),
    "peopleWhoWantToJoinYourHousehold": MessageLookupByLibrary.simpleMessage(
      "People who want to join your household",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("per month"),
    "perWeek": MessageLookupByLibrary.simpleMessage("per week"),
    "permissionDenied": MessageLookupByLibrary.simpleMessage(
      "Permission denied",
    ),
    "phone": MessageLookupByLibrary.simpleMessage("Phone"),
    "phoneHint": MessageLookupByLibrary.simpleMessage("e.g. +1 555 555 5555"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "pleaseCheckYourEmailToVerifyYourAccount":
        MessageLookupByLibrary.simpleMessage(
          "Please check your email to verify your account.",
        ),
    "pleaseComeBackSoon": MessageLookupByLibrary.simpleMessage(
      "Please come back soon!",
    ),
    "pleaseEnterAValidEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "pleaseEnterYourEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter your email.",
    ),
    "pleaseEnterYourName": MessageLookupByLibrary.simpleMessage(
      "Please enter your name",
    ),
    "pleaseLogInToContinue": MessageLookupByLibrary.simpleMessage(
      "Please log in to continue.",
    ),
    "pleaseLoginToYourAppnameAccount": m27,
    "pleaseReadAndAcceptOurPrivacyPolicy": MessageLookupByLibrary.simpleMessage(
      "Please read and accept our privacy policy",
    ),
    "pleaseRegisterToContinue": MessageLookupByLibrary.simpleMessage(
      "Please register to continue.",
    ),
    "pleaseVerifyYourEmailAddressToContinue":
        MessageLookupByLibrary.simpleMessage(
          "Please verify your email address to continue.",
        ),
    "pleaseWait": MessageLookupByLibrary.simpleMessage("Please wait"),
    "postponedEmailVerificationUntilNextTime":
        MessageLookupByLibrary.simpleMessage(
          "Postponed email verification until next time.",
        ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "privacyPolicyAndTermsOfServiceAccepted":
        MessageLookupByLibrary.simpleMessage(
          "Privacy policy and terms of service accepted",
        ),
    "proceedWithCaution": MessageLookupByLibrary.simpleMessage(
      "Proceed with caution.",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Profile updated successfully",
    ),
    "providerAlreadyLinkedTitle": MessageLookupByLibrary.simpleMessage(
      "Provider Already Linked",
    ),
    "quantity": MessageLookupByLibrary.simpleMessage("Quantity"),
    "quantityCannotBeNegative": MessageLookupByLibrary.simpleMessage(
      "Quantity must be greater than zero",
    ),
    "quotaExceededTitle": MessageLookupByLibrary.simpleMessage(
      "Quota Exceeded",
    ),
    "rateLimitMessage": m28,
    "readInstructions": MessageLookupByLibrary.simpleMessage(
      "Read the instructions",
    ),
    "receipt": MessageLookupByLibrary.simpleMessage("Receipt"),
    "receiptDeleted": MessageLookupByLibrary.simpleMessage("Receipt deleted"),
    "receiptDescription": MessageLookupByLibrary.simpleMessage(
      "Attach a receipt image for documentation.",
    ),
    "receiptUploaded": MessageLookupByLibrary.simpleMessage("Receipt uploaded"),
    "recurrence": MessageLookupByLibrary.simpleMessage("Recurrence"),
    "recurrenceInvalid": MessageLookupByLibrary.simpleMessage(
      "Recurrence configuration is invalid",
    ),
    "recurrenceMode": MessageLookupByLibrary.simpleMessage("Recurrence Mode"),
    "recurrenceOptionalDescription": MessageLookupByLibrary.simpleMessage(
      "Set up recurring schedule for this task",
    ),
    "recurring": MessageLookupByLibrary.simpleMessage("Recurring"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registerButtonLabel": MessageLookupByLibrary.simpleMessage(
      "Register button",
    ),
    "registerFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Register failed",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "removeMember": MessageLookupByLibrary.simpleMessage("Remove member"),
    "removeSubtask": MessageLookupByLibrary.simpleMessage("Remove subtask"),
    "reorderSubtasks": MessageLookupByLibrary.simpleMessage("Reorder subtasks"),
    "repeatTaskAutomatically": MessageLookupByLibrary.simpleMessage(
      "Repeat task automatically",
    ),
    "requestedToJoin": MessageLookupByLibrary.simpleMessage(
      "requested to join",
    ),
    "requestsEmoji": MessageLookupByLibrary.simpleMessage("🤝  "),
    "requestsFromPeopleThatWantToJoinYourHousehold":
        MessageLookupByLibrary.simpleMessage(
          "Requests from people that want to join your household.",
        ),
    "requestsThatYouHaveSentToJoinAHousehold":
        MessageLookupByLibrary.simpleMessage(
          "Requests that you have sent to join a household.",
        ),
    "required": MessageLookupByLibrary.simpleMessage("Required"),
    "resend": MessageLookupByLibrary.simpleMessage("Resend"),
    "resendEmail": MessageLookupByLibrary.simpleMessage("Resend Email"),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "resetPasswordCooldownMessage": m29,
    "resetPasswordCooldownMessageSeconds": m30,
    "roomies": MessageLookupByLibrary.simpleMessage("Roomies"),
    "roomy": MessageLookupByLibrary.simpleMessage("Roomy"),
    "roomy123": MessageLookupByLibrary.simpleMessage("Roomy123!"),
    "sat": MessageLookupByLibrary.simpleMessage("sat"),
    "saturday": MessageLookupByLibrary.simpleMessage("saturday"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveImage": MessageLookupByLibrary.simpleMessage("Save Image"),
    "saveToGallery": MessageLookupByLibrary.simpleMessage("Save to Gallery"),
    "scanAQrCodeToJoinAnExistingHousehold":
        MessageLookupByLibrary.simpleMessage(
          "Scan a QR code to join an existing household",
        ),
    "scanQrCode": MessageLookupByLibrary.simpleMessage("Scan QR Code"),
    "scanToJoin": MessageLookupByLibrary.simpleMessage("Scan To Join"),
    "schedule": MessageLookupByLibrary.simpleMessage("Schedule"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "second": MessageLookupByLibrary.simpleMessage("second"),
    "seconds": MessageLookupByLibrary.simpleMessage("seconds"),
    "seeAll": MessageLookupByLibrary.simpleMessage("See all"),
    "selectCaps": MessageLookupByLibrary.simpleMessage("SELECT"),
    "selectImage": MessageLookupByLibrary.simpleMessage("Select Image"),
    "selectPeriod": MessageLookupByLibrary.simpleMessage("Select period"),
    "selectWeekDays": MessageLookupByLibrary.simpleMessage("Select weekdays"),
    "send": MessageLookupByLibrary.simpleMessage("Send"),
    "sendEmail": MessageLookupByLibrary.simpleMessage("Send Email"),
    "sentInvitesEmoji": MessageLookupByLibrary.simpleMessage("📤  "),
    "sep": MessageLookupByLibrary.simpleMessage("sep"),
    "september": MessageLookupByLibrary.simpleMessage("september"),
    "setAmountForSplitMethod": MessageLookupByLibrary.simpleMessage(
      "Set amount for the split method.",
    ),
    "setTotalAmountDescription": MessageLookupByLibrary.simpleMessage(
      "Set the total amount",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsButtonLabel": MessageLookupByLibrary.simpleMessage(
      "Settings button",
    ),
    "shareInviteCodeWithNewMembers": MessageLookupByLibrary.simpleMessage(
      "Share this code with new members",
    ),
    "shareThisCodeWithNewMembers": MessageLookupByLibrary.simpleMessage(
      "Share this code with new members",
    ),
    "sharedShoppingLists": MessageLookupByLibrary.simpleMessage(
      "Shared Shopping Lists",
    ),
    "shoppedAndLoaded": MessageLookupByLibrary.simpleMessage(
      "Shopped and loaded.",
    ),
    "shopping": MessageLookupByLibrary.simpleMessage("Shopping"),
    "shoppingItemDescription": MessageLookupByLibrary.simpleMessage(
      "Shopping item",
    ),
    "shoppingList": MessageLookupByLibrary.simpleMessage("Shopping List"),
    "shoppingListCreated": MessageLookupByLibrary.simpleMessage(
      "Shopping list created",
    ),
    "shoppingListDeleted": MessageLookupByLibrary.simpleMessage(
      "Shopping list deleted",
    ),
    "shoppingListDescriptionCannotExceed200Characters":
        MessageLookupByLibrary.simpleMessage(
          "Shopping list description cannot exceed 200 characters",
        ),
    "shoppingListNameMustBeAtLeast3CharactersLong":
        MessageLookupByLibrary.simpleMessage(
          "Shopping list name must be at least 3 characters long",
        ),
    "shoppingListNameMustBeAtMost50CharactersLong":
        MessageLookupByLibrary.simpleMessage(
          "Shopping list name must be at most 50 characters long",
        ),
    "shoppingListNotFound": MessageLookupByLibrary.simpleMessage(
      "Shopping list not found",
    ),
    "shoppingListUpdated": MessageLookupByLibrary.simpleMessage(
      "Shopping list updated",
    ),
    "shoppingLists": MessageLookupByLibrary.simpleMessage("Shopping Lists"),
    "shoppingNotifications": MessageLookupByLibrary.simpleMessage(
      "Shopping Notifications",
    ),
    "shoppingNotificationsDescription": MessageLookupByLibrary.simpleMessage(
      "Get notified about shopping list updates.",
    ),
    "shoppingNotificationsDisabled": MessageLookupByLibrary.simpleMessage(
      "Shopping notifications disabled",
    ),
    "shoppingNotificationsEnabled": MessageLookupByLibrary.simpleMessage(
      "Shopping notifications enabled",
    ),
    "shoppingOverview": MessageLookupByLibrary.simpleMessage(
      "Let\'s Get Shopping!",
    ),
    "shoppingOverviewDescription": MessageLookupByLibrary.simpleMessage(
      "Create and manage shared shopping lists with your roomies. Add items, check them off together, and ensure everyone is aware of what needs to be purchased.",
    ),
    "showInviteCode": MessageLookupByLibrary.simpleMessage("Show Invite Code"),
    "showThisToYourRoomy": MessageLookupByLibrary.simpleMessage(
      "Send this to your roomy.",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign up"),
    "size": MessageLookupByLibrary.simpleMessage("Size"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "skipped": MessageLookupByLibrary.simpleMessage("Skipped"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong",
    ),
    "somethingWentWrongPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Something went wrong, please try again later.",
        ),
    "somethingWentWrongWhileDeletingOldUsernamesPleaseTryAgain":
        MessageLookupByLibrary.simpleMessage(
          "Something went wrong while deleting old usernames, please try again.",
        ),
    "somethingWentWrongWhileSavingTheImagePleaseTryAgain":
        MessageLookupByLibrary.simpleMessage(
          "Something went wrong while saving the image. Please try again. If the problem persists, please contact support.",
        ),
    "somethingWentWrongWhileSortingTheItemsOurApologies":
        MessageLookupByLibrary.simpleMessage(
          "Something went wrong while sorting the items, our apologies.",
        ),
    "somethingWentWrongWhileTryingToCreateYourProfilePlease":
        MessageLookupByLibrary.simpleMessage(
          "Something went wrong while trying to create your profile, please try again.",
        ),
    "somethingWentWrongWhileTryingToLoadYourHouseholdPlease":
        MessageLookupByLibrary.simpleMessage(
          "Something went wrong while trying to load your household, please restart the app and try again.",
        ),
    "startAFreshHouseholdForYouAndYourRoomies":
        MessageLookupByLibrary.simpleMessage(
          "Start a fresh household for you and your roomies",
        ),
    "statistics": MessageLookupByLibrary.simpleMessage("Statistics"),
    "stranger": MessageLookupByLibrary.simpleMessage("stranger"),
    "subject": MessageLookupByLibrary.simpleMessage("Subject"),
    "subjectHint": MessageLookupByLibrary.simpleMessage(
      "e.g. Groceries, Utilities, etc.",
    ),
    "submittingFeedback": MessageLookupByLibrary.simpleMessage(
      "Submitting feedback...",
    ),
    "subtaskAdded": MessageLookupByLibrary.simpleMessage("Subtask added"),
    "subtaskCompleted": MessageLookupByLibrary.simpleMessage(
      "Subtask completed",
    ),
    "subtaskDeleted": MessageLookupByLibrary.simpleMessage("Subtask deleted"),
    "subtaskNameInvalidCharactersValidation":
        MessageLookupByLibrary.simpleMessage(
          "Subtask name contains invalid characters",
        ),
    "subtaskNameMaxLength": MessageLookupByLibrary.simpleMessage(
      "Subtask name cannot exceed 100 characters",
    ),
    "subtaskNameMaxLengthValidation": MessageLookupByLibrary.simpleMessage(
      "Subtask name cannot exceed 100 characters",
    ),
    "subtaskNameRequired": MessageLookupByLibrary.simpleMessage(
      "Subtask name is required",
    ),
    "subtaskNameRequiredValidation": MessageLookupByLibrary.simpleMessage(
      "Subtask name is required",
    ),
    "subtaskReordered": MessageLookupByLibrary.simpleMessage(
      "Subtask reordered",
    ),
    "subtaskUncompleted": MessageLookupByLibrary.simpleMessage(
      "Subtask uncompleted",
    ),
    "subtaskUpdated": MessageLookupByLibrary.simpleMessage("Subtask updated"),
    "subtasks": MessageLookupByLibrary.simpleMessage("Subtasks"),
    "success": MessageLookupByLibrary.simpleMessage("Success"),
    "sun": MessageLookupByLibrary.simpleMessage("sun"),
    "sunday": MessageLookupByLibrary.simpleMessage("sunday"),
    "switchToLoginLabel": MessageLookupByLibrary.simpleMessage(
      "Switch to login",
    ),
    "takePhoto": MessageLookupByLibrary.simpleMessage("Take Photo"),
    "tapToAdd": MessageLookupByLibrary.simpleMessage("Tap to add"),
    "tapToAddItem": MessageLookupByLibrary.simpleMessage("Tap to add item"),
    "tapToViewAndManageTheCleaningSchedule":
        MessageLookupByLibrary.simpleMessage(
          "Tap to view and manage the cleaning schedule.",
        ),
    "taskAssignedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Task assigned successfully",
    ),
    "taskClaimedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Task claimed successfully",
    ),
    "taskCompleted": MessageLookupByLibrary.simpleMessage("Task completed"),
    "taskDeleted": MessageLookupByLibrary.simpleMessage("Task deleted"),
    "taskDetails": MessageLookupByLibrary.simpleMessage("Task Details"),
    "taskManagement": MessageLookupByLibrary.simpleMessage("Task Management"),
    "taskNotFoundMessage": MessageLookupByLibrary.simpleMessage(
      "Unable to find the task to update subtask",
    ),
    "taskNotFoundTitle": MessageLookupByLibrary.simpleMessage("Task not found"),
    "taskUnassignedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Task unassigned successfully",
    ),
    "taskUncompleted": MessageLookupByLibrary.simpleMessage("Task uncompleted"),
    "tasks": MessageLookupByLibrary.simpleMessage("Tasks"),
    "tasksAssignedToYouAndRecentlyCompleted":
        MessageLookupByLibrary.simpleMessage("Tasks assigned to you."),
    "tellUsAboutYourself": MessageLookupByLibrary.simpleMessage(
      "Tell us about yourself..",
    ),
    "termsOfService": MessageLookupByLibrary.simpleMessage("Terms of Service"),
    "thankYou": MessageLookupByLibrary.simpleMessage("Thank you!"),
    "thankYouAndWelcomeToRoomy": MessageLookupByLibrary.simpleMessage(
      "Thank you and welcome to Roomy.",
    ),
    "thankYouForSharingYourInsightsWithUsWeTruly":
        MessageLookupByLibrary.simpleMessage(
          "Thank you for sharing your insights with us. We truly value your feedback and will use it to make the app even better. We appreciate your support!",
        ),
    "thankYouForYourFeedback": MessageLookupByLibrary.simpleMessage(
      "Thank you for your feedback!",
    ),
    "theShoppingListHasGoneMissingReturningYouHomeLet":
        MessageLookupByLibrary.simpleMessage(
          "The shopping list has gone missing! Returning you home.. let us know if this is a mistake.",
        ),
    "theseAreYourRoommates": MessageLookupByLibrary.simpleMessage(
      "The chosen few.",
    ),
    "thisFieldIsRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "thisIsCurrentlyUnderDevelopmentAndWillBeAvailableSoon":
        MessageLookupByLibrary.simpleMessage(
          "This is currently under development and will be available soon.",
        ),
    "thisWeek": MessageLookupByLibrary.simpleMessage("This Week"),
    "thu": MessageLookupByLibrary.simpleMessage("thu"),
    "thursday": MessageLookupByLibrary.simpleMessage("thursday"),
    "timeSpan": MessageLookupByLibrary.simpleMessage("Time Span"),
    "times": MessageLookupByLibrary.simpleMessage("times"),
    "timesADay": m31,
    "timesAMonth": m32,
    "timesAWeek": m33,
    "timesAYear": m34,
    "timesPerMonth": MessageLookupByLibrary.simpleMessage("times per month"),
    "timesPerWeek": MessageLookupByLibrary.simpleMessage("times per week"),
    "titleMustBeAtLeast1CharacterLong": MessageLookupByLibrary.simpleMessage(
      "Title must be at least 1 character long.",
    ),
    "toDo": MessageLookupByLibrary.simpleMessage("To Do"),
    "today": MessageLookupByLibrary.simpleMessage("today"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Try again"),
    "tue": MessageLookupByLibrary.simpleMessage("tue"),
    "tuesday": MessageLookupByLibrary.simpleMessage("tuesday"),
    "unableToAcceptPleaseTryAgainLater": MessageLookupByLibrary.simpleMessage(
      "Unable to accept, please try again later.",
    ),
    "unableToCompleteRequest": MessageLookupByLibrary.simpleMessage(
      "Unable to Complete Request",
    ),
    "unableToEdit": MessageLookupByLibrary.simpleMessage("Unable to Edit"),
    "unableToLogYouOut": MessageLookupByLibrary.simpleMessage(
      "Unable to log you out",
    ),
    "unableToLogYouOutPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Unable to log you out, please try again later.",
        ),
    "unassign": MessageLookupByLibrary.simpleMessage("Unassign"),
    "unassignTask": MessageLookupByLibrary.simpleMessage("Unassign Task"),
    "unassigned": MessageLookupByLibrary.simpleMessage("Unassigned"),
    "unavailable": MessageLookupByLibrary.simpleMessage("Unavailable"),
    "undo": MessageLookupByLibrary.simpleMessage("Undo"),
    "undoAllItems": MessageLookupByLibrary.simpleMessage("Undo all items"),
    "unexpectedErrorMessage": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unknownError": MessageLookupByLibrary.simpleMessage("Unknown Error"),
    "unknownErrorMessage": MessageLookupByLibrary.simpleMessage(
      "An unknown error has occurred, please try again.",
    ),
    "unknownErrorTitle": MessageLookupByLibrary.simpleMessage("Unknown error"),
    "unknownProfileWeWereUnableToFetchTheProfile":
        MessageLookupByLibrary.simpleMessage(
          "Unknown profile. We were unable to fetch the profile.",
        ),
    "unnamedTask": MessageLookupByLibrary.simpleMessage("Unnamed Task"),
    "updateTimeSlots": MessageLookupByLibrary.simpleMessage(
      "Update Time Slots",
    ),
    "updated": MessageLookupByLibrary.simpleMessage("Updated"),
    "useAnInviteCodeToJoinAnExistingHousehold":
        MessageLookupByLibrary.simpleMessage(
          "Use an invite code to join an existing household.",
        ),
    "useInviteCode": MessageLookupByLibrary.simpleMessage("Use Invite Code"),
    "useYourInviteCodeToJoinAnExistingHousehold":
        MessageLookupByLibrary.simpleMessage(
          "Use your invite code to join an existing household",
        ),
    "userIdIsNull": MessageLookupByLibrary.simpleMessage("User ID is null"),
    "userIdNotFound": MessageLookupByLibrary.simpleMessage("User ID not found"),
    "userIsAlreadyAMember": MessageLookupByLibrary.simpleMessage(
      "User is already a member",
    ),
    "userIsAlreadyAMemberMessage": m35,
    "userIsAlreadyInvited": MessageLookupByLibrary.simpleMessage(
      "User is already invited",
    ),
    "userIsAlreadyInvitedMessage": m36,
    "userNotFound": MessageLookupByLibrary.simpleMessage("User not found"),
    "userNotFoundForUsername": m37,
    "userProfileCardDescription": MessageLookupByLibrary.simpleMessage(
      "User profile card",
    ),
    "userProfileInformation": MessageLookupByLibrary.simpleMessage(
      "User profile information",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Username"),
    "usernameCopied": MessageLookupByLibrary.simpleMessage("Username copied"),
    "usernameFieldHint": MessageLookupByLibrary.simpleMessage("@roomydoe"),
    "usernameFieldLabel": MessageLookupByLibrary.simpleMessage("Username"),
    "usernameInvalid": MessageLookupByLibrary.simpleMessage("Invalid username"),
    "usernameInvalidFormat": MessageLookupByLibrary.simpleMessage(
      "Username can only contain alphanumeric characters, underscores, and periods.",
    ),
    "usernameIsAlreadyInUsePleaseChooseADifferentOne":
        MessageLookupByLibrary.simpleMessage(
          "Username is already in use, please choose a different one.",
        ),
    "usernameIsAlreadyTaken": MessageLookupByLibrary.simpleMessage(
      "Username is already taken.",
    ),
    "usernameMaxLength": MessageLookupByLibrary.simpleMessage(
      "Username must be no more than 30 characters long.",
    ),
    "usernameMinLength": MessageLookupByLibrary.simpleMessage(
      "Username must be at least 3 characters long.",
    ),
    "usernameRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "usernamesHousehold": m38,
    "validationError": MessageLookupByLibrary.simpleMessage("Validation Error"),
    "verificationEmailHasBeenResent": MessageLookupByLibrary.simpleMessage(
      "Verification email has been resent.",
    ),
    "verificationEmailSent": MessageLookupByLibrary.simpleMessage(
      "Verification email sent",
    ),
    "verificationEmailSentCheckingAgainInSeconds": m39,
    "verifyEmail": MessageLookupByLibrary.simpleMessage("Verify Email"),
    "verifyEmailSentMessage": MessageLookupByLibrary.simpleMessage(
      "Please check your email to verify your account.",
    ),
    "verifyEmailSentTitle": MessageLookupByLibrary.simpleMessage(
      "Verify email sent",
    ),
    "verifyYourEmail": MessageLookupByLibrary.simpleMessage(
      "Verify your email",
    ),
    "view": MessageLookupByLibrary.simpleMessage("View"),
    "viewAllTasks": MessageLookupByLibrary.simpleMessage("View All Tasks"),
    "viewCaps": MessageLookupByLibrary.simpleMessage("VIEW"),
    "viewOnlyMode": MessageLookupByLibrary.simpleMessage(
      "View only - This payment was created by another user",
    ),
    "viewPayments": MessageLookupByLibrary.simpleMessage("View Payments"),
    "waitingForApproval": MessageLookupByLibrary.simpleMessage(
      "Waiting for approval",
    ),
    "waitingForInviteCode": MessageLookupByLibrary.simpleMessage(
      "Waiting for invite code...",
    ),
    "weEncounteredAnUnexpectedErrorPleaseTryAgainOrContact":
        MessageLookupByLibrary.simpleMessage(
          "We encountered an unexpected error. Please try again or contact support if the issue persists.",
        ),
    "weHaveResentTheVerificationEmailPleaseCheckYourInbox":
        MessageLookupByLibrary.simpleMessage(
          "We have resent the verification email. Please check your inbox and try again.",
        ),
    "weNoticedYouHaveNotVerifiedYourEmailAddressYet":
        MessageLookupByLibrary.simpleMessage(
          "We noticed you have not verified your email address yet, please check your inbox and follow the instructions to verify your email address.",
        ),
    "weTakeYourPrivacynverySerious": MessageLookupByLibrary.simpleMessage(
      "We take your privacy\nvery serious",
    ),
    "weWereUnableToCheckTheTimeSlotPleaseReload":
        MessageLookupByLibrary.simpleMessage(
          "We were unable to check the time slot. Please reload the app and try again.",
        ),
    "weakPasswordMessage": MessageLookupByLibrary.simpleMessage(
      "The password provided is too weak, please try again.",
    ),
    "weakPasswordTitle": MessageLookupByLibrary.simpleMessage("Weak password"),
    "wed": MessageLookupByLibrary.simpleMessage("wed"),
    "wednesday": MessageLookupByLibrary.simpleMessage("wednesday"),
    "week": MessageLookupByLibrary.simpleMessage("week"),
    "weekDaysRequired": MessageLookupByLibrary.simpleMessage(
      "At least one weekday must be selected for weekly frequency",
    ),
    "weeks": MessageLookupByLibrary.simpleMessage("weeks"),
    "weeksAgo": m40,
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome to Roomy 🎉"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome back"),
    "welcomeBackTitle": MessageLookupByLibrary.simpleMessage("Welcome back!"),
    "welcomeHome": MessageLookupByLibrary.simpleMessage("Welcome Home"),
    "welcomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "We\'re excited to help you organize your household! Through the button below you can read how to easily send feedback.",
    ),
    "welcomeToApp": m41,
    "welcomeToRoomy": MessageLookupByLibrary.simpleMessage("Welcome to Roomy!"),
    "welcomeToRoomyDescription": MessageLookupByLibrary.simpleMessage(
      "Welcome to Roomy",
    ),
    "welcomeToShoppingLists": MessageLookupByLibrary.simpleMessage(
      "Welcome to Shopping Lists 🛒",
    ),
    "welcomeToShoppingListsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Create shared shopping lists with your household members. Add items, mark them as completed, and keep everyone organized!",
    ),
    "whatNameSuitsYouBest": MessageLookupByLibrary.simpleMessage(
      "What name suits you best?",
    ),
    "whatsNew": MessageLookupByLibrary.simpleMessage("What\'s New?"),
    "whoSharesThisExpense": MessageLookupByLibrary.simpleMessage(
      "Who shares this expense?",
    ),
    "wouldYouLikeToResendTheVerificationEmail":
        MessageLookupByLibrary.simpleMessage(
          "Would you like to resend the verification email?",
        ),
    "wrongPasswordMessage": MessageLookupByLibrary.simpleMessage(
      "The password is invalid, please try again.",
    ),
    "wrongPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Wrong password",
    ),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
    "you": MessageLookupByLibrary.simpleMessage("you"),
    "youCanOnlySkipEmailVerificationOnce": MessageLookupByLibrary.simpleMessage(
      "You can only skip email verification once. Please verify your email to continue.",
    ),
    "youCannotDeleteTheMainShoppingList": MessageLookupByLibrary.simpleMessage(
      "You cannot delete the main shopping list",
    ),
    "youCreator": MessageLookupByLibrary.simpleMessage("You"),
    "youHaveBeenInvited": MessageLookupByLibrary.simpleMessage(
      "You have been invited!",
    ),
    "youHaveBeenInvitedToJoinName": m42,
    "youHaveLeftTheHousehold": MessageLookupByLibrary.simpleMessage(
      "You have left the household",
    ),
    "youOwe": MessageLookupByLibrary.simpleMessage("You Owe"),
    "youPaid": MessageLookupByLibrary.simpleMessage("You Paid"),
    "youWillNoLongerHaveAccessToThisHouseholdYou":
        MessageLookupByLibrary.simpleMessage(
          "You have automatically joined your old household if you had one.",
        ),
    "yourCurrentHousehold": MessageLookupByLibrary.simpleMessage(
      "your current household",
    ),
    "yourExpenses": MessageLookupByLibrary.simpleMessage("My Expenses"),
    "yourPasswordMustBeAtLeast8CharactersLong":
        MessageLookupByLibrary.simpleMessage(
          "Your password must be at least 8 characters long.",
        ),
    "yourRequestToJoinTheHouseholdHasBeenSent":
        MessageLookupByLibrary.simpleMessage(
          "Your request to join the household has been sent. An admin will review it shortly.",
        ),
  };
}

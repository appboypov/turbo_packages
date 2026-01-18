// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class StringsEn extends Strings {
  StringsEn([String locale = 'en']) : super(locale);

  @override
  String get aHousehold => 'a household';

  @override
  String get accept => 'Accept';

  @override
  String acceptingInviteWillRemoveYouFromCurrentHousehold(
    Object householdName,
  ) {
    return 'This will remove you from \'$householdName\'. Continue?';
  }

  @override
  String get account => 'Account';

  @override
  String get accountCreated => 'Account created';

  @override
  String get accountCreationFailed => 'Account creation failed';

  @override
  String get add => 'Add';

  @override
  String get addEmail => 'Add email';

  @override
  String get addItem => 'Add Item';

  @override
  String get addItemToList => 'Add item to list';

  @override
  String get addLink => 'Add link';

  @override
  String get addPhoneNumber => 'Add phone number';

  @override
  String get addRoomy => 'Add Roomy';

  @override
  String get addSubtask => 'Add subtask';

  @override
  String get addSubtaskHint => 'Add a new subtask...';

  @override
  String get addSubtasksToBreakDownYourTask =>
      'Add subtasks to break down your task into smaller steps';

  @override
  String get addTask => 'Add Task';

  @override
  String get addedBy => 'Added by';

  @override
  String addedByUserOnDate(Object date, Object user) {
    return 'Added by $user on $date';
  }

  @override
  String get allItemsUnchecked => 'All items unchecked';

  @override
  String get allTasks => 'All Tasks';

  @override
  String get allTasksDescription =>
      'View all cleaning tasks in your household. You can claim unassigned tasks, see who\'s responsible for each task, and track the overall cleaning schedule';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get alreadyInUse => 'Already in use';

  @override
  String get anErrorOccurredWhileTryingToLogoutPleaseTryAgain =>
      'An error occurred while trying to logout. Please try again later.';

  @override
  String get anUnknownErrorOccurredPleaseTryAgainLater =>
      'An unknown error occurred. Please try again later.';

  @override
  String get and => 'and';

  @override
  String andCountMore(int count) {
    return '+ $count more';
  }

  @override
  String get anotherDayAnotherList => 'Another day, another list.';

  @override
  String get apr => 'apr';

  @override
  String get april => 'april';

  @override
  String get areYouSureYouWantToDeclineThisInvite =>
      'Are you sure you want to decline this invite?';

  @override
  String get areYouSureYouWantToDeleteThisImage =>
      'Are you sure you want to delete this image?';

  @override
  String get areYouSureYouWantToDeleteThisItem =>
      'Are you sure you want to delete this item?';

  @override
  String get areYouSureYouWantToDeleteThisShoppingList =>
      'Are you sure you want to delete this shopping list?';

  @override
  String get areYouSureYouWantToDeleteThisSubtask =>
      'Are you sure you want to delete this subtask?';

  @override
  String get areYouSureYouWantToDeleteThisTask =>
      'Are you sure you want to delete this task?';

  @override
  String get areYouSureYouWantToLeaveThisHousehold =>
      'Are you sure you want to leave this household?';

  @override
  String get areYouSureYouWantToLogout => 'Are you sure you want to logout?';

  @override
  String get areYouSureYouWantToProceedThisWillTake =>
      'Are you sure you want to proceed? This will take you to the delete account page.';

  @override
  String get areYouSureYouWantToRemoveThisMember =>
      'Are you sure you want to remove this member?';

  @override
  String get areYouSureYouWantToUnassignThisTask =>
      'Are you sure you want to unassign this task?';

  @override
  String get areYouSureYouWantToUncheckAllItems =>
      'Are you sure you want to uncheck all items?';

  @override
  String get assign => 'Assign';

  @override
  String get assigned => 'Assigned';

  @override
  String get assignedTo => 'Assigned to';

  @override
  String get assignment => 'Assignment';

  @override
  String get aug => 'aug';

  @override
  String get august => 'august';

  @override
  String get back => 'Back';

  @override
  String get beforeMovingOnTakeAMomentToReadHowWe =>
      'Before moving on, take a moment to read how we protect your personal information.';

  @override
  String get bekijkSchema => 'Check Schema';

  @override
  String get biography => 'Biography';

  @override
  String bug(Object bug) {
    return '$bug Bug';
  }

  @override
  String get bulkActions => 'Bulk Actions';

  @override
  String get byClickingContinue => 'By clicking continue, you agree to our';

  @override
  String get camera => 'Camera';

  @override
  String get cancel => 'Cancel';

  @override
  String get cancelInvite => 'Cancel Invite';

  @override
  String get areYouSureYouWantToCancelThisInvite =>
      'Are you sure you want to cancel this invite?';

  @override
  String get failedToCancelInvitePleaseTryAgainLater =>
      'Failed to cancel invite right now, please try again later.';

  @override
  String get changeName => 'Change Name';

  @override
  String get changePassword => 'Change Password';

  @override
  String get checkAllTasksToClaimOrGetAssigned =>
      'Check \'Schema\' to claim or assign.';

  @override
  String get checkStatus => 'Check Status';

  @override
  String get checkYourSpamFolder =>
      'Can\'t find it? Check your spam or junk folder.';

  @override
  String get checkmarkSymbol => '✅';

  @override
  String get claim => 'Claim';

  @override
  String get claimTask => 'Claim Task';

  @override
  String get claimTaskConfirmationMessage =>
      'Are you sure you want to claim this task? This will assign it to you.';

  @override
  String get claimTaskConfirmationTitle => 'Claim this task?';

  @override
  String get cleaning => 'Cleaning';

  @override
  String get cleaningFrequency => 'Frequency';

  @override
  String get cleaningSchedule => 'Cleaning Schedule';

  @override
  String get cleaningTaskDescription => 'Description';

  @override
  String get cleaningTaskDescriptionHint =>
      'e.g. Brief overview of what needs to be done';

  @override
  String get cleaningTaskDescriptionMaxLength =>
      'Description can be at most 200 characters long.';

  @override
  String get enterValidNumber => 'Please enter a valid number.';

  @override
  String get cleaningTaskFrequencyMaxCount => 'Frequency must be at most 100.';

  @override
  String get cleaningTaskFrequencyMinCount => 'Frequency must be at least 1.';

  @override
  String get cleaningTaskFrequencyRequired => 'This field is required';

  @override
  String get cleaningTaskInstructions => 'Instructions';

  @override
  String get cleaningTaskInstructionsHint =>
      'e.g. Clean the shower, toilet, and sink';

  @override
  String get cleaningTaskInstructionsMaxLength =>
      'Instructions can be at most 200 characters long.';

  @override
  String get cleaningTaskName => 'Name';

  @override
  String get cleaningTaskNameHint => 'e.g. Clean the bathroom';

  @override
  String get cleaningTaskNameMaxLength =>
      'Name can be at most 50 characters long.';

  @override
  String get cleaningTaskNameMinLength =>
      'Name must be at least 1 character long.';

  @override
  String get cleaningTaskSize => 'Size';

  @override
  String get cleaningTaskSizeHint => 'Select the effort level for this task';

  @override
  String get cleaningTaskSizeL => 'Large';

  @override
  String get cleaningTaskSizeM => 'Medium';

  @override
  String get cleaningTaskSizeS => 'Small';

  @override
  String get cleaningTaskSizeXl => 'Extra Large';

  @override
  String get cleaningTaskSizeXs => 'Extra Small';

  @override
  String get cleaningTaskTimespanRequired => 'This field is required';

  @override
  String get cleaningTasksEmptySubtitle =>
      'Create your first cleaning task to get organized.';

  @override
  String get cleaningTimespan => 'Timespan';

  @override
  String get cleaningTimespanDay => 'Day';

  @override
  String get cleaningTimespanMonth => 'Month';

  @override
  String get cleaningTimespanWeek => 'Week';

  @override
  String get cleaningTimespanYear => 'Year';

  @override
  String get clickHereToLogin => 'Click here to log in';

  @override
  String get clickToView => 'Click to view';

  @override
  String get codeInvullen => 'Join household';

  @override
  String get codeTonen => 'Show Code';

  @override
  String get complete => 'Complete';

  @override
  String get completed => 'Completed';

  @override
  String get completedByYou => 'Completed by you';

  @override
  String get components => 'Components';

  @override
  String get configure => 'Configure';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get copyToClipboard => 'Copy to clipboard';

  @override
  String get core => 'Core';

  @override
  String get create => 'Create';

  @override
  String get createAccount => 'Create an account';

  @override
  String get createAndManageYourCleaningTasks => 'Very important task details.';

  @override
  String get createShoppingList => 'Create Shopping List';

  @override
  String get createYourFirstHousehold => 'Create your first household!';

  @override
  String createdAtDateString(Object dateString) {
    return 'Created at $dateString';
  }

  @override
  String get crossSymbol => '❌';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get databaseFailure => 'Database Failure';

  @override
  String get day => 'day';

  @override
  String get dayOfMonth => 'Day of month';

  @override
  String get dayOfMonthPlaceholder => 'e.g. 15';

  @override
  String get days => 'days';

  @override
  String get deadline => 'Deadline';

  @override
  String get dec => 'dec';

  @override
  String get december => 'december';

  @override
  String get decline => 'Decline';

  @override
  String get declineInvite => 'Decline Invite';

  @override
  String get decrease => 'Decrease';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteImage => 'Delete Image';

  @override
  String get deleteItem => 'Delete item';

  @override
  String get deleteShoppingList => 'Delete Shopping List';

  @override
  String get deletingFailed => 'Deleting failed';

  @override
  String get description => 'Description';

  @override
  String get doYouWantToVisitThePrivacyPolicy =>
      'Do you want to visit the privacy policy?';

  @override
  String get doYouWantToVisitTheTermsOfService =>
      'Do you want to visit the terms of service?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get dragToReorder => 'Drag to reorder';

  @override
  String get dutch => 'Dutch';

  @override
  String get edit => 'Edit';

  @override
  String get editItem => 'Edit item';

  @override
  String get editLanguage => 'Edit Language';

  @override
  String get editName => 'Edit Name';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editShoppingListDetails => 'Edit shopping list details';

  @override
  String get editTask => 'Edit Task';

  @override
  String get editYourShoppingList => 'Edit your shopping list';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get emailNotYetVerified => 'Email not yet verified';

  @override
  String get emailSent => 'Email Sent';

  @override
  String get emailVerified => 'Email verified';

  @override
  String get emptyPlaceholderAnEmptyList =>
      'An empty list is a clear sky; what will you build?';

  @override
  String get emptyPlaceholderBlankCanvas =>
      'A blank canvas awaits your masterpiece.';

  @override
  String get emptyPlaceholderEmptySpaces =>
      'Empty spaces are just rooms for growth.';

  @override
  String get emptyPlaceholderNoEntries =>
      'No entries yet, but infinite potential.';

  @override
  String get emptyPlaceholderNotAVoid => 'This is not a void, it\'s a stage.';

  @override
  String get emptyPlaceholderNotSadJustEmpty => 'Not sad, just empty.';

  @override
  String get emptyPlaceholderNothingHere => 'Nothing here but possibilities.';

  @override
  String get emptyPlaceholderTheEmptiness =>
      'The emptiness you see is the space for your next achievement.';

  @override
  String get emptyPlaceholderTheEmptinessIsNotALack =>
      'The emptiness is not a lack, but a space to fill.';

  @override
  String get emptyPlaceholderZeroItems => 'Zero items, endless opportunity.';

  @override
  String get emptySubtasksMessage => 'No subtasks yet. Add one above!';

  @override
  String get english => 'English';

  @override
  String get enterADescriptionForYourShoppingList =>
      'Enter a description for your shopping list';

  @override
  String get enterANameForYourShoppingList =>
      'Enter a name for your shopping list';

  @override
  String get enterAValidEmail => 'Enter a valid email';

  @override
  String get enterDetailsToRegister => 'Enter your details to register';

  @override
  String get enterInviteCode => 'Enter Code';

  @override
  String get enterTheNameForTheNewShoppingList =>
      'Enter the name for the new shopping list. This will be visible to all members.';

  @override
  String get enterTheNewNameForTheHouseholdThisWillBe =>
      'Enter the new name for the household. This will be visible to all members.';

  @override
  String get enterValidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get enterValidURL => 'Please enter a valid URL';

  @override
  String get enterValueBetween1And31 => 'Enter a value between 1 and 31';

  @override
  String get enterWhatWasExpectedAndWhatActuallyHappened =>
      'Enter what was expected and what actually happened.';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterYourIdeaForAnImprovementOrFeatureRequest =>
      'Enter your idea for an improvement or feature request.';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get error => 'Error';

  @override
  String get errorCreatingCleaningTask => 'Error creating cleaning task';

  @override
  String get errorUpdatingCleaningTask => 'Error updating cleaning task';

  @override
  String get every => 'Every';

  @override
  String get failedToAcceptInvitePleaseTryAgainLaterAndContact =>
      'Failed to accept invite, please try again later and contact us if the problem persists.';

  @override
  String get failedToAddItem => 'Failed to add item';

  @override
  String get failedToAddSubtask => 'Failed to add subtask';

  @override
  String get failedToAssignTaskPleaseTryAgain =>
      'Failed to assign task. Please try again.';

  @override
  String get failedToCallCloudFunction => 'Failed to call cloud function';

  @override
  String get failedToClaimTaskPleaseTryAgain =>
      'Failed to claim task. Please try again.';

  @override
  String get failedToCompleteTask => 'Failed to complete task';

  @override
  String get failedToCreateCleaningTaskPleaseTryAgainLater =>
      'Failed to create cleaning task, please try again later';

  @override
  String get failedToDeclineInviteRightNowPleaseTryAgainLater =>
      'Failed to decline invite right now, please try again later and contact us if the problem persist.';

  @override
  String get failedToDeleteImagePleaseTryAgainLater =>
      'Failed to delete image. Please try again later.';

  @override
  String get failedToDeleteItemPleaseTryAgainLater =>
      'Failed to delete item. Please try again later.';

  @override
  String get failedToDeleteShoppingListPleaseTryAgainLater =>
      'Failed to delete shopping list. Please try again later.';

  @override
  String get failedToDeleteSubtask => 'Failed to delete subtask';

  @override
  String get failedToDeleteTaskPleaseTryAgainLater =>
      'Failed to delete task. Please try again later.';

  @override
  String get failedToLoadCleaningTasks =>
      'Failed to load cleaning tasks. Please try again.';

  @override
  String get failedToLogIn => 'Failed to log in';

  @override
  String get failedToNavigateToAddTask =>
      'Failed to navigate to add task. Please try again.';

  @override
  String get failedToNavigateToTask =>
      'Failed to navigate to task. Please try again.';

  @override
  String get failedToRemoveMemberRightNowPleaseTryAgainLater =>
      'Failed to remove member right now. Please try again later.';

  @override
  String get failedToReorderItemsPleaseTryAgain =>
      'Failed to reorder items, please try again.';

  @override
  String get failedToReorderSubtasks => 'Failed to reorder subtasks';

  @override
  String get failedToSelectImagePleaseTryAgainIfTheProblem =>
      'Failed to select image. Please try again. If the problem persists, please contact support.';

  @override
  String get failedToSendInvite => 'Failed to send invite';

  @override
  String get failedToShowAssignmentOptions =>
      'Failed to show assignment options.';

  @override
  String get failedToTakePhotoPleaseTryAgainIfTheProblem =>
      'Failed to take photo. Please try again. If the problem persists, please contact support.';

  @override
  String get failedToUnassignTaskPleaseTryAgain =>
      'Failed to unassign task. Please try again.';

  @override
  String get failedToUncheckAllItems => 'Failed to uncheck all items';

  @override
  String get failedToUncompleteTask => 'Failed to uncomplete task';

  @override
  String get failedToUpdateCleaningTaskPleaseTryAgainLater =>
      'Failed to update cleaning task, please try again later';

  @override
  String get failedToUpdateName => 'Failed to update name';

  @override
  String get failedToUpdateShoppingList => 'Failed to update shopping list';

  @override
  String get failedToUpdateSubtask => 'Failed to update subtask';

  @override
  String get failedToUpdateTimeSlots => 'Failed to update time slots';

  @override
  String get failedToUploadImagePleaseTryAgainLater =>
      'Failed to upload image. Please try again later.';

  @override
  String get feb => 'feb';

  @override
  String get february => 'february';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackButton_tooltip => 'Send feedback';

  @override
  String get feedbackSubmitted => 'Feedback submitted';

  @override
  String get fillInYourBiography => 'Fill in your biography';

  @override
  String get fillInYourEmail => 'Fill in your email';

  @override
  String get fillInYourEmailAddressAndWeWillSendYou =>
      'Fill in your email address.';

  @override
  String get fillInYourLink => 'Fill in your link';

  @override
  String get fillInYourPhoneNumber => 'Fill in your phone number';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get frequencyCountPlaceholder => 'e.g. 2';

  @override
  String get frequencyMode => 'Times per period';

  @override
  String get frequencyModeExample =>
      'e.g., \"2 times per week\" or \"4 times per month\"';

  @override
  String get fri => 'fri';

  @override
  String get friday => 'friday';

  @override
  String get friendsTeachUsTrustRoommatesTeachUsHarmony => 'The chosen few.';

  @override
  String get gallery => 'Gallery';

  @override
  String get general => 'General';

  @override
  String get generalSettingsInTheApp => 'General settings in the app.';

  @override
  String get generateInviteCode => 'Generate Invite Code';

  @override
  String get generatingInviteCode => 'Generating invite code...';

  @override
  String get goBack => 'Go back';

  @override
  String get gotIt => 'Got it';

  @override
  String helloUsername(Object username) {
    return 'Hello @$username';
  }

  @override
  String get hiddenPass => '••••••••';

  @override
  String get home => 'Home';

  @override
  String get household => 'Household';

  @override
  String householdCreated(Object householdName) {
    return '$householdName created!';
  }

  @override
  String get householdInvite => 'Household Invite';

  @override
  String get householdInvites => 'Household Invites';

  @override
  String get householdNameAdjectiveBusy => 'Busy';

  @override
  String get householdNameAdjectiveCharming => 'Charming';

  @override
  String get householdNameAdjectiveCheerful => 'Cheerful';

  @override
  String get householdNameAdjectiveComfy => 'Comfy';

  @override
  String get householdNameAdjectiveCozy => 'Cozy';

  @override
  String get householdNameAdjectiveCreative => 'Creative';

  @override
  String get householdNameAdjectiveCute => 'Cute';

  @override
  String get householdNameAdjectiveFriendly => 'Friendly';

  @override
  String get householdNameAdjectiveHappy => 'Happy';

  @override
  String get householdNameAdjectiveInviting => 'Inviting';

  @override
  String get householdNameAdjectiveLively => 'Lively';

  @override
  String get householdNameAdjectiveModern => 'Modern';

  @override
  String get householdNameAdjectivePeaceful => 'Peaceful';

  @override
  String get householdNameAdjectiveQuaint => 'Quaint';

  @override
  String get householdNameAdjectiveQuiet => 'Quiet';

  @override
  String get householdNameAdjectiveRelaxed => 'Relaxed';

  @override
  String get householdNameAdjectiveRustic => 'Rustic';

  @override
  String get householdNameAdjectiveSecluded => 'Secluded';

  @override
  String get householdNameAdjectiveSerene => 'Serene';

  @override
  String get householdNameAdjectiveShared => 'Shared';

  @override
  String get householdNameAdjectiveSnug => 'Snug';

  @override
  String get householdNameAdjectiveSunny => 'Sunny';

  @override
  String get householdNameAdjectiveTranquil => 'Tranquil';

  @override
  String get householdNameAdjectiveVibrant => 'Vibrant';

  @override
  String get householdNameAdjectiveWarm => 'Warm';

  @override
  String get householdNameMustBeAtLeast3CharactersLong =>
      'Household name must be at least 3 characters long';

  @override
  String get householdNameMustBeAtMost50CharactersLong =>
      'Household name must be at most 50 characters long';

  @override
  String get householdNameNounAbode => 'Abode';

  @override
  String get householdNameNounBase => 'Base';

  @override
  String get householdNameNounCabin => 'Cabin';

  @override
  String get householdNameNounCastle => 'Castle';

  @override
  String get householdNameNounCorner => 'Corner';

  @override
  String get householdNameNounCottage => 'Cottage';

  @override
  String get householdNameNounCrew => 'Crew';

  @override
  String get householdNameNounDen => 'Den';

  @override
  String get householdNameNounDwelling => 'Dwelling';

  @override
  String get householdNameNounFamily => 'Family';

  @override
  String get householdNameNounHangout => 'Hangout';

  @override
  String get householdNameNounHaven => 'Haven';

  @override
  String get householdNameNounHeadquarters => 'Headquarters';

  @override
  String get householdNameNounHideaway => 'Hideaway';

  @override
  String get householdNameNounHome => 'Home';

  @override
  String get householdNameNounHub => 'Hub';

  @override
  String get householdNameNounLodge => 'Lodge';

  @override
  String get householdNameNounNest => 'Nest';

  @override
  String get householdNameNounOasis => 'Oasis';

  @override
  String get householdNameNounPad => 'Pad';

  @override
  String get householdNameNounPlace => 'Place';

  @override
  String get householdNameNounRetreat => 'Retreat';

  @override
  String get householdNameNounSanctuary => 'Sanctuary';

  @override
  String get householdNameNounSpot => 'Spot';

  @override
  String get householdNameNounSquad => 'Squad';

  @override
  String get householdRequests => 'Household Requests';

  @override
  String get householdsThatYouHaveBeenInvitedTo =>
      'Households that you have been invited to.';

  @override
  String get householdsYouRequestedToJoin => 'Waiting for approval from';

  @override
  String get iAgreeToThe => 'I agree to the';

  @override
  String idea(Object idea) {
    return '$idea Idea';
  }

  @override
  String ifRegisteredWeSend(Object email) {
    return 'If $email is registered with us, a password reset email has been sent.';
  }

  @override
  String get imageDeleted => 'Image deleted';

  @override
  String get imageUploaded => 'Image uploaded';

  @override
  String inDays(int count) {
    return 'in $count days';
  }

  @override
  String inMonths(int count) {
    return 'in $count months';
  }

  @override
  String get inOneDay => 'in 1 day';

  @override
  String get inOneMonth => 'in 1 month';

  @override
  String get inOnePlusWeek => 'in 1+ week';

  @override
  String inWeeks(Object inWeeks) {
    return 'In $inWeeks Weeks';
  }

  @override
  String inWeeksPlus(int count) {
    return 'in $count+ weeks';
  }

  @override
  String get inbox => 'Inbox';

  @override
  String get increase => 'Increase';

  @override
  String get intervalMode => 'Repeat every...';

  @override
  String get intervalModeExample =>
      'e.g., \"Every 3 days\" or \"Every 2 weeks\"';

  @override
  String get intervalValuePlaceholder => 'e.g. 3';

  @override
  String get invalidDayOfMonth => 'Day of month must be between 1 and 31';

  @override
  String get invalidFrequencyCount => 'Frequency count must be greater than 0';

  @override
  String get invalidIntervalValue => 'Interval value must be greater than 0';

  @override
  String get invalidQuantity => 'Invalid quantity';

  @override
  String get invalidTimeSlot => 'Invalid Time Slot';

  @override
  String get invite => 'Invite';

  @override
  String get inviteAccepted => 'Invite accepted!';

  @override
  String get inviteCanceled => 'Invite canceled!';

  @override
  String get inviteCode => 'Invite Code';

  @override
  String get inviteCodeCopied => 'Invite code copied to clipboard';

  @override
  String get inviteCodeInvalid => 'Invalid code. Check and try again.';

  @override
  String get inviteCodeMustBeExactly4Characters => 'Code must be 4 characters';

  @override
  String get inviteCodeRequired => 'Enter code (4 characters)';

  @override
  String get inviteDeclined => 'Invite declined!';

  @override
  String get inviteHouseholdMessage => 'Enter username to invite.';

  @override
  String get inviteSent => 'Invite sent';

  @override
  String get inviteSentSuccessfully => 'Invite sent';

  @override
  String get invited => 'Invited';

  @override
  String get invitesSentToOthersToJoinYourHousehold =>
      'Invites sent to others to join your household.';

  @override
  String get item => 'Item';

  @override
  String get itemAdded => 'Item added';

  @override
  String get itemCompleted => 'Item completed';

  @override
  String get itemDeleted => 'Item deleted';

  @override
  String get itemUncompleted => 'Item uncompleted';

  @override
  String get itemUpdated => 'Item updated';

  @override
  String get jan => 'jan';

  @override
  String get january => 'january';

  @override
  String get joinHousehold => 'Join Household';

  @override
  String get joinOrLeaveAHousehold => 'Join or leave a household.';

  @override
  String get joinRequestSent => 'Join Request Sent';

  @override
  String get joinRequests => 'Join Requests';

  @override
  String get jul => 'jul';

  @override
  String get july => 'july';

  @override
  String get jun => 'jun';

  @override
  String get june => 'june';

  @override
  String get language => 'Language';

  @override
  String get languageChanged => 'Language changed';

  @override
  String languageChangedToSupportedLanguage(Object supportedLanguage) {
    return 'Language changed to $supportedLanguage';
  }

  @override
  String lastUpdateAtString(Object lastUpdatedAtString) {
    return 'Last update at $lastUpdatedAtString';
  }

  @override
  String get lastWeek => 'Last Week';

  @override
  String get lazyLoading => 'Lazy Loading';

  @override
  String get leave => 'Leave';

  @override
  String get leaveAndJoin => 'Leave';

  @override
  String get leaveCurrentHousehold => 'Leave Current Household?';

  @override
  String get leaveHousehold => 'Leave household';

  @override
  String get leaveJoin => 'Leave';

  @override
  String get link => 'Link';

  @override
  String get linkHint => 'e.g. https://twitter.com/username';

  @override
  String get list => 'List';

  @override
  String get loading => 'Loading';

  @override
  String get loggedIn => 'Logged in';

  @override
  String get loggedOut => 'Logged out';

  @override
  String get login => 'Login';

  @override
  String loginToAccount(Object appName) {
    return 'Login to your $appName account';
  }

  @override
  String get logout => 'Logout';

  @override
  String get logoutFailed => 'Logout failed';

  @override
  String get mainShoppingList => 'Main Shopping List';

  @override
  String get manage => 'Manage';

  @override
  String get manageCleaningTask => 'Manage Cleaning Task';

  @override
  String get manageHouseholdMembers => 'Manage household members';

  @override
  String get managePendingInvitesToJoinADifferentHousehold =>
      'Manage pending invites to join a different household';

  @override
  String get managePendingInvitesToJoinThisHousehold =>
      'Manage pending invites to join this household.';

  @override
  String get manageYourHouseholdMembersAndSettings => 'Home sweet home.';

  @override
  String get manageYourShoppingListsAndItems => 'Shopping made easy.';

  @override
  String get management => 'Management';

  @override
  String get mar => 'mar';

  @override
  String get march => 'march';

  @override
  String maxLengthExceeded(int length) {
    return 'Maximum length of $length characters exceeded';
  }

  @override
  String get maximumHouseholdMembersReached =>
      'Maximum number of household members reached';

  @override
  String get maximumHouseholdMembersReachedMessage =>
      'This household has reached its maximum member limit. Please contact the household owner if you believe this is an error.';

  @override
  String get maximumSkipsReached => 'Maximum Skips Reached';

  @override
  String maximumValueExceeded(double value) {
    return 'Maximum value of $value exceeded';
  }

  @override
  String get may => 'may';

  @override
  String get member => 'Member';

  @override
  String get memberRemoved => 'Member removed!';

  @override
  String memberSinceCreatedAtString(Object createdAtString) {
    return 'Member since $createdAtString';
  }

  @override
  String memberSinceDate(Object date) {
    return 'Member since $date';
  }

  @override
  String get members => 'Members';

  @override
  String get messageMustBeLessThan500Characters =>
      'Message must be less than 500 characters';

  @override
  String minimumValueRequired(double value) {
    return 'Minimum value of $value is required';
  }

  @override
  String get minute => 'minute';

  @override
  String get minutes => 'minutes';

  @override
  String get missingList => 'Missing List';

  @override
  String get mon => 'mon';

  @override
  String get monday => 'monday';

  @override
  String get month => 'month';

  @override
  String get months => 'months';

  @override
  String get myCleaningSchedule => 'My Cleaning Schedule';

  @override
  String get myHousehold => 'My Household';

  @override
  String get myInvites => 'My Invites';

  @override
  String get myRequests => 'My Requests';

  @override
  String get myRoomies => 'My Roomies';

  @override
  String get myShoppingLists => 'My Shopping Lists';

  @override
  String get myTasks => 'My Tasks';

  @override
  String get myTasksDescription =>
      'Here you can find all tasks assigned to you.';

  @override
  String get name => 'Name';

  @override
  String nameCanBeAtMost(Object kLimitsMaxNameLength) {
    return 'Name can be at most $kLimitsMaxNameLength characters long.';
  }

  @override
  String get nameChangedSuccessfully => 'Name changed successfully';

  @override
  String get nameMustBeLessThan50Characters =>
      'Name must be less than 50 characters';

  @override
  String get nextDeadline => 'Next Deadline';

  @override
  String nextDue(Object date) {
    return 'Next due: $date';
  }

  @override
  String get nextWeek => 'Next Week';

  @override
  String get noCleaningTasksYet => 'No cleaning tasks yet!';

  @override
  String get noCount => '-';

  @override
  String get noDeadline => 'No deadline';

  @override
  String get noDescription => 'No description';

  @override
  String get noHouseholdFound => 'No Household Found';

  @override
  String get noHouseholdMembersAvailableForAssignment =>
      'No household members available for assignment.';

  @override
  String get noInstructionsProvided => 'No instructions provided';

  @override
  String get noInviteCodeAvailable => 'No invite code found, try again later!';

  @override
  String get noRecurrence => 'No recurrence';

  @override
  String get noResultsPlaceholderAnEmptyList =>
      'An empty list is a prompt for new perspectives.';

  @override
  String get noResultsPlaceholderConsiderADifferent =>
      'Consider a different approach or term.';

  @override
  String get noResultsPlaceholderEmbraceThis =>
      'Embrace this empty list as a moment of calm.';

  @override
  String get noResultsPlaceholderInThisMoment =>
      'In this moment, no results arise.';

  @override
  String get noResultsPlaceholderMaybeWhatYoureLooking =>
      'Maybe what you\'re looking for is hidden in another perspective.';

  @override
  String get noResultsPlaceholderNoAnswers => 'No answers here.';

  @override
  String get noResultsPlaceholderNoMatches =>
      'No matches here. Reimagine your query.';

  @override
  String get noResultsPlaceholderNoResults => 'No results found.';

  @override
  String get noResultsPlaceholderNothingFound => 'Nothing found here.';

  @override
  String get noResultsPlaceholderNothingMatched =>
      'Nothing matched your query.';

  @override
  String get noResultsPlaceholderPerhapsItsTime =>
      'Perhaps it\'s time to ask a different question.';

  @override
  String get noResultsPlaceholderPerhapsItsTimeToTake =>
      'Perhaps it\'s time to take a different route.';

  @override
  String get noResultsPlaceholderPerhapsTheAnswer =>
      'Perhaps the answer lies elsewhere.';

  @override
  String get noResultsPlaceholderSeekInAnother =>
      'Seek in another direction with sharper focus.';

  @override
  String get noResultsPlaceholderTheOutcome =>
      'The outcome is clear: nothing found. How will you adapt?';

  @override
  String get noResultsPlaceholderTheSearchIsOver =>
      'The search is over, but the journey continues.';

  @override
  String get noResultsPlaceholderTheSearchReveals =>
      'The search reveals absence.';

  @override
  String get noRoomies => 'No Roomies';

  @override
  String get noTasksAssignedToYou => 'No tasks assigned to you yet';

  @override
  String get none => 'None';

  @override
  String get notAssignedToAnyone => 'Not assigned to anyone.';

  @override
  String get notFound => 'Not found';

  @override
  String get notSadJustEmpty => 'Not sad, just empty.';

  @override
  String get notSet => 'Not set';

  @override
  String get notVerified => 'Not verified';

  @override
  String get nov => 'nov';

  @override
  String get november => 'november';

  @override
  String get oct => 'oct';

  @override
  String get october => 'october';

  @override
  String get ok => 'Ok';

  @override
  String get onceADay => 'once a day';

  @override
  String get onceAMonth => 'once a month';

  @override
  String get onceAWeek => 'once a week';

  @override
  String get onceAYear => 'once a year';

  @override
  String get onetimeTask => 'On demand';

  @override
  String get oops => 'Oops';

  @override
  String get oopsSomethingWentWrong => 'Oops! Something went wrong.';

  @override
  String get optional => 'Optional';

  @override
  String get or => 'or';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get overdue => 'Overdue';

  @override
  String overdueDays(int count) {
    return 'overdue $count days';
  }

  @override
  String get overdueOneDay => 'overdue 1 day';

  @override
  String get overview => 'Overview';

  @override
  String get password => 'Password';

  @override
  String get passwordDoesNotMatch => 'Password does not match';

  @override
  String get payments => 'Payments';

  @override
  String get pending => 'Pending';

  @override
  String get openEmail => 'Open Email';

  @override
  String get pendingInvitations => 'Pending Invitations';

  @override
  String get peopleWhoWantToJoinYourHousehold =>
      'People who want to join your household';

  @override
  String get perMonth => 'per month';

  @override
  String get perWeek => 'per week';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get phone => 'Phone';

  @override
  String get phoneHint => 'e.g. +1 555 555 5555';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get pleaseCheckYourEmailToVerifyYourAccount =>
      'Please check your email to verify your account.';

  @override
  String get pleaseComeBackSoon => 'Please come back soon!';

  @override
  String get pleaseEnterAValidEmailAddress =>
      'Please enter a valid email address';

  @override
  String get pleaseEnterYourEmail => 'Please enter your email.';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get pleaseLogInToContinue => 'Please log in to continue.';

  @override
  String pleaseLoginToYourAppnameAccount(Object appName) {
    return 'Please login to your $appName account';
  }

  @override
  String get pleaseReadAndAcceptOurPrivacyPolicy =>
      'Please read and accept our privacy policy';

  @override
  String get pleaseRegisterToContinue => 'Please register to continue.';

  @override
  String get pleaseVerifyYourEmailAddressToContinue =>
      'Please verify your email address to continue.';

  @override
  String get pleaseWait => 'Please wait';

  @override
  String get postponedEmailVerificationUntilNextTime =>
      'Postponed email verification until next time.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyAndTermsOfServiceAccepted =>
      'Privacy policy and terms of service accepted';

  @override
  String get proceedWithCaution => 'Proceed with caution.';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get quantity => 'Quantity';

  @override
  String get quantityCannotBeNegative => 'Quantity must be greater than zero';

  @override
  String rateLimitMessage(int seconds) {
    return 'Wait ${seconds}s.';
  }

  @override
  String get readInstructions => 'Read the instructions';

  @override
  String get recurrence => 'Recurrence';

  @override
  String get repeatTaskAutomatically => 'Repeat task automatically';

  @override
  String get recurrenceInvalid => 'Recurrence configuration is invalid';

  @override
  String get recurrenceMode => 'Recurrence Mode';

  @override
  String get recurrenceOptionalDescription =>
      'Set up recurring schedule for this task';

  @override
  String get recurring => 'Recurring';

  @override
  String get register => 'Register';

  @override
  String get remove => 'Remove';

  @override
  String get removeMember => 'Remove member';

  @override
  String get removeSubtask => 'Remove subtask';

  @override
  String get reorderSubtasks => 'Reorder subtasks';

  @override
  String get requestedToJoin => 'requested to join';

  @override
  String get requestsFromPeopleThatWantToJoinYourHousehold =>
      'Requests from people that want to join your household.';

  @override
  String get requestsThatYouHaveSentToJoinAHousehold =>
      'Requests that you have sent to join a household.';

  @override
  String get required => 'Required';

  @override
  String get resend => 'Resend';

  @override
  String get resendEmail => 'Resend Email';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String resetPasswordCooldownMessage(
    Object minuteText,
    Object minutes,
    Object secondText,
    Object seconds,
  ) {
    return 'You can request another reset email in $minutes $minuteText and $seconds $secondText';
  }

  @override
  String resetPasswordCooldownMessageSeconds(
    Object secondText,
    Object seconds,
  ) {
    return 'You can request another reset email in $seconds $secondText';
  }

  @override
  String get roomies => 'Roomies';

  @override
  String get theseAreYourRoommates => 'The chosen few.';

  @override
  String get administration => 'Administration';

  @override
  String get roomy => 'Roomy';

  @override
  String get roomy123 => 'Roomy123!';

  @override
  String get sat => 'sat';

  @override
  String get saturday => 'saturday';

  @override
  String get save => 'Save';

  @override
  String get saveImage => 'Save Image';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get schedule => 'Schedule';

  @override
  String get search => 'Search';

  @override
  String get second => 'second';

  @override
  String get seconds => 'seconds';

  @override
  String get selectImage => 'Select Image';

  @override
  String get selectPeriod => 'Select period';

  @override
  String get selectWeekDays => 'Select weekdays';

  @override
  String get send => 'Send';

  @override
  String get sendEmail => 'Send Email';

  @override
  String get sep => 'sep';

  @override
  String get september => 'september';

  @override
  String get settings => 'Settings';

  @override
  String get shareInviteCodeWithNewMembers =>
      'Share this code with new members';

  @override
  String get shareThisCodeWithNewMembers => 'Share this code with new members';

  @override
  String get sharedShoppingLists => 'Shared Shopping Lists';

  @override
  String get shopping => 'Shopping';

  @override
  String get shoppingList => 'Shopping List';

  @override
  String get shoppingListCreated => 'Shopping list created';

  @override
  String get shoppingListDeleted => 'Shopping list deleted';

  @override
  String get shoppingListDescriptionCannotExceed200Characters =>
      'Shopping list description cannot exceed 200 characters';

  @override
  String get shoppingListNameMustBeAtLeast3CharactersLong =>
      'Shopping list name must be at least 3 characters long';

  @override
  String get shoppingListNameMustBeAtMost50CharactersLong =>
      'Shopping list name must be at most 50 characters long';

  @override
  String get shoppingListNotFound => 'Shopping list not found';

  @override
  String get shoppingListUpdated => 'Shopping list updated';

  @override
  String get shoppingLists => 'Shopping Lists';

  @override
  String get shoppingOverview => 'Let\'s Get Shopping!';

  @override
  String get shoppingOverviewDescription =>
      'Create and manage shared shopping lists with your roomies. Add items, check them off together, and ensure everyone is aware of what needs to be purchased.';

  @override
  String get showInviteCode => 'Show Invite Code';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get size => 'Size';

  @override
  String get skip => 'Skip';

  @override
  String get skipped => 'Skipped';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get somethingWentWrongPleaseTryAgainLater =>
      'Something went wrong, please try again later.';

  @override
  String get somethingWentWrongWhileDeletingOldUsernamesPleaseTryAgain =>
      'Something went wrong while deleting old usernames, please try again.';

  @override
  String get somethingWentWrongWhileSavingTheImagePleaseTryAgain =>
      'Something went wrong while saving the image. Please try again. If the problem persists, please contact support.';

  @override
  String get somethingWentWrongWhileSortingTheItemsOurApologies =>
      'Something went wrong while sorting the items, our apologies.';

  @override
  String get somethingWentWrongWhileTryingToCreateYourProfilePlease =>
      'Something went wrong while trying to create your profile, please try again.';

  @override
  String get somethingWentWrongWhileTryingToLoadYourHouseholdPlease =>
      'Something went wrong while trying to load your household, please restart the app and try again.';

  @override
  String get statistics => 'Statistics';

  @override
  String get stranger => 'stranger';

  @override
  String get submittingFeedback => 'Submitting feedback...';

  @override
  String get subtaskAdded => 'Subtask added';

  @override
  String get subtaskCompleted => 'Subtask completed';

  @override
  String get subtaskDeleted => 'Subtask deleted';

  @override
  String get subtaskNameMaxLength =>
      'Subtask name cannot exceed 100 characters';

  @override
  String get subtaskNameRequired => 'Subtask name is required';

  @override
  String get subtaskReordered => 'Subtask reordered';

  @override
  String get subtaskUncompleted => 'Subtask uncompleted';

  @override
  String get subtaskUpdated => 'Subtask updated';

  @override
  String get subtasks => 'Subtasks';

  @override
  String get breakTaskIntoSmallerSteps => 'Break task into smaller steps';

  @override
  String get success => 'Success';

  @override
  String get sun => 'sun';

  @override
  String get sunday => 'sunday';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get tapToAdd => 'Tap to add';

  @override
  String get tapToAddItem => 'Tap to add item';

  @override
  String get tapToViewAndManageTheCleaningSchedule =>
      'Tap to view and manage the cleaning schedule.';

  @override
  String get taskAssignedSuccessfully => 'Task assigned successfully';

  @override
  String get taskClaimedSuccessfully => 'Task claimed successfully';

  @override
  String get taskCompleted => 'Task completed';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get taskDetails => 'Task Details';

  @override
  String get taskManagement => 'Task Management';

  @override
  String get taskUnassignedSuccessfully => 'Task unassigned successfully';

  @override
  String get taskUncompleted => 'Task uncompleted';

  @override
  String get tasks => 'Tasks';

  @override
  String get tasksAssignedToYouAndRecentlyCompleted => 'Tasks assigned to you.';

  @override
  String get tellUsAboutYourself => 'Tell us about yourself..';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get thankYou => 'Thank you!';

  @override
  String get thankYouAndWelcomeToRoomy => 'Thank you and welcome to Roomy.';

  @override
  String get thankYouForSharingYourInsightsWithUsWeTruly =>
      'Thank you for sharing your insights with us. We truly value your feedback and will use it to make the app even better. We appreciate your support!';

  @override
  String get thankYouForYourFeedback => 'Thank you for your feedback!';

  @override
  String get theShoppingListHasGoneMissingReturningYouHomeLet =>
      'The shopping list has gone missing! Returning you home.. let us know if this is a mistake.';

  @override
  String get thisFieldIsRequired => 'This field is required';

  @override
  String get thisIsCurrentlyUnderDevelopmentAndWillBeAvailableSoon =>
      'This is currently under development and will be available soon.';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thu => 'thu';

  @override
  String get thursday => 'thursday';

  @override
  String get timeSpan => 'Time Span';

  @override
  String get times => 'times';

  @override
  String timesADay(int count) {
    return '$count times a day';
  }

  @override
  String timesAMonth(int count) {
    return '$count times a month';
  }

  @override
  String timesAWeek(int count) {
    return '$count times a week';
  }

  @override
  String timesAYear(int count) {
    return '$count times a year';
  }

  @override
  String get timesPerMonth => 'times per month';

  @override
  String get timesPerWeek => 'times per week';

  @override
  String get titleMustBeAtLeast1CharacterLong =>
      'Title must be at least 1 character long.';

  @override
  String get toDo => 'To Do';

  @override
  String get today => 'today';

  @override
  String get tryAgain => 'Try again';

  @override
  String get tue => 'tue';

  @override
  String get tuesday => 'tuesday';

  @override
  String get unableToAcceptPleaseTryAgainLater =>
      'Unable to accept, please try again later.';

  @override
  String get unableToLogYouOut => 'Unable to log you out';

  @override
  String get unableToLogYouOutPleaseTryAgainLater =>
      'Unable to log you out, please try again later.';

  @override
  String get unassign => 'Unassign';

  @override
  String get unassignTask => 'Unassign Task';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get undo => 'Undo';

  @override
  String get undoAllItems => 'Undo all items';

  @override
  String get unknown => 'Unknown';

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get unknownProfileWeWereUnableToFetchTheProfile =>
      'Unknown profile. We were unable to fetch the profile.';

  @override
  String get unnamedTask => 'Unnamed Task';

  @override
  String get updateTimeSlots => 'Update Time Slots';

  @override
  String get useAnInviteCodeToJoinAnExistingHousehold =>
      'Use an invite code to join an existing household.';

  @override
  String get userIdNotFound => 'User ID not found';

  @override
  String get userIsAlreadyAMember => 'User is already a member';

  @override
  String userIsAlreadyAMemberMessage(String username) {
    return '$username is already a member of this household. Would you like to add someone else?';
  }

  @override
  String get userIsAlreadyInvited => 'User is already invited';

  @override
  String userIsAlreadyInvitedMessage(String username) {
    return '$username has already been invited to this household. Would you like to invite someone else?';
  }

  @override
  String get userNotFound => 'User not found';

  @override
  String userNotFoundForUsername(String username) {
    return 'We could not find a user with the username $username. Please check the username and try again.';
  }

  @override
  String get username => 'Username';

  @override
  String get usernameCopied => 'Username copied';

  @override
  String get usernameFieldHint => '@roomydoe';

  @override
  String get usernameFieldLabel => 'Username';

  @override
  String get usernameInvalid => 'Invalid username';

  @override
  String get usernameInvalidFormat =>
      'Username can only contain alphanumeric characters, underscores, and periods.';

  @override
  String get usernameIsAlreadyInUsePleaseChooseADifferentOne =>
      'Username is already in use, please choose a different one.';

  @override
  String get usernameIsAlreadyTaken => 'Username is already taken.';

  @override
  String get usernameMaxLength =>
      'Username must be no more than 30 characters long.';

  @override
  String get usernameMinLength =>
      'Username must be at least 3 characters long.';

  @override
  String get usernameRequired => 'This field is required';

  @override
  String usernamesHousehold(Object username) {
    return '$username\'s Household';
  }

  @override
  String get verificationEmailHasBeenResent =>
      'Verification email has been resent.';

  @override
  String get verificationEmailSent => 'Verification email sent';

  @override
  String verificationEmailSentCheckingAgainInSeconds(Object seconds) {
    return 'Verification email sent,\nchecking again in $seconds seconds';
  }

  @override
  String get verifyEmail => 'Verify Email';

  @override
  String get verifyYourEmail => 'Verify your email';

  @override
  String get view => 'View';

  @override
  String get viewAllTasks => 'View All Tasks';

  @override
  String get viewCaps => 'VIEW';

  @override
  String get waitingForApproval => 'Waiting for approval';

  @override
  String get waitingForInviteCode => 'Waiting for invite code...';

  @override
  String get weEncounteredAnUnexpectedErrorPleaseTryAgainOrContact =>
      'We encountered an unexpected error. Please try again or contact support if the issue persists.';

  @override
  String get weHaveResentTheVerificationEmailPleaseCheckYourInbox =>
      'We have resent the verification email. Please check your inbox and try again.';

  @override
  String get weNoticedYouHaveNotVerifiedYourEmailAddressYet =>
      'We noticed you have not verified your email address yet, please check your inbox and follow the instructions to verify your email address.';

  @override
  String get weTakeYourPrivacynverySerious =>
      'We take your privacy\nvery serious';

  @override
  String get weWereUnableToCheckTheTimeSlotPleaseReload =>
      'We were unable to check the time slot. Please reload the app and try again.';

  @override
  String get wed => 'wed';

  @override
  String get wednesday => 'wednesday';

  @override
  String get week => 'week';

  @override
  String get weekDaysRequired =>
      'At least one weekday must be selected for weekly frequency';

  @override
  String get weeks => 'weeks';

  @override
  String weeksAgo(Object inWeeks) {
    return '$inWeeks Weeks Ago';
  }

  @override
  String get welcome => 'Welcome to Roomy 🎉';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get welcomeSubtitle =>
      'We\'re excited to help you organize your household! Through the button below you can read how to easily send feedback.';

  @override
  String get welcomeToShoppingLists => 'Welcome to Shopping Lists 🛒';

  @override
  String get welcomeToShoppingListsSubtitle =>
      'Create shared shopping lists with your household members. Add items, mark them as completed, and keep everyone organized!';

  @override
  String get whatNameSuitsYouBest => 'What name suits you best?';

  @override
  String get whatsNew => 'What\'s New?';

  @override
  String get wouldYouLikeToResendTheVerificationEmail =>
      'Would you like to resend the verification email?';

  @override
  String get yes => 'Yes';

  @override
  String get youCanOnlySkipEmailVerificationOnce =>
      'You can only skip email verification once. Please verify your email to continue.';

  @override
  String get youCannotDeleteTheMainShoppingList =>
      'You cannot delete the main shopping list';

  @override
  String get youHaveBeenInvited => 'You have been invited!';

  @override
  String youHaveBeenInvitedToJoinName(Object name) {
    return 'You have been invited to join $name!';
  }

  @override
  String get youHaveLeftTheHousehold => 'You have left the household';

  @override
  String get youWillNoLongerHaveAccessToThisHouseholdYou =>
      'You have automatically joined your old household if you had one.';

  @override
  String get yourCurrentHousehold => 'your current household';

  @override
  String get yourPasswordMustBeAtLeast8CharactersLong =>
      'Your password must be at least 8 characters long.';

  @override
  String get yourRequestToJoinTheHouseholdHasBeenSent =>
      'Your request to join the household has been sent. An admin will review it shortly.';

  @override
  String get welcomeToRoomy => 'Welcome to Roomy!';

  @override
  String get welcomeHome => 'Welcome Home';

  @override
  String get chooseAnOptionToGetStarted => 'Choose an option to get started';

  @override
  String get createHousehold => 'Create Household';

  @override
  String get startAFreshHouseholdForYouAndYourRoomies =>
      'Start a fresh household for you and your roomies';

  @override
  String get useInviteCode => 'Use Invite Code';

  @override
  String get useYourInviteCodeToJoinAnExistingHousehold =>
      'Use your invite code to join an existing household';

  @override
  String get joinHouseholdScan => 'Scan to Join';

  @override
  String get scanAQrCodeToJoinAnExistingHousehold =>
      'Scan a QR code to join an existing household';

  @override
  String get selectCaps => 'SELECT';

  @override
  String get scanToJoin => 'Scan To Join';

  @override
  String get noPaymentsYet => 'No payments yet!';

  @override
  String get createYourFirstPaymentToGetStarted =>
      'Create your first payment to get started.';

  @override
  String get history => 'History';

  @override
  String get amount => 'Amount';

  @override
  String get amountPlaceholder => '0,-';

  @override
  String get paymentSavedSuccessfully => 'Payment saved successfully';

  @override
  String get subject => 'Subject';

  @override
  String get subjectHint => 'e.g. Groceries, Utilities, etc.';

  @override
  String get deletePayment => 'Delete Payment';

  @override
  String get deletePaymentConfirmation =>
      'Are you sure you want to delete this payment? This action cannot be undone.';

  @override
  String get paymentDeletedSuccessfully => 'Payment deleted successfully';

  @override
  String get allPayments => 'All Payments';

  @override
  String get paymentGeneral => 'General';

  @override
  String get paymentGeneralDescription =>
      'Payment subject and general details.';

  @override
  String get paymentSection => 'Payment';

  @override
  String get paymentSectionDescription =>
      'Payment amount and financial details.';

  @override
  String get receipt => 'Receipt';

  @override
  String get receiptDescription => 'Attach a receipt image for documentation.';

  @override
  String get deleteReceipt => 'Delete Receipt';

  @override
  String get deleteReceiptConfirmation =>
      'Are you sure you want to delete this receipt?';

  @override
  String get addReceipt => 'Add Receipt';

  @override
  String get receiptDeleted => 'Receipt deleted';

  @override
  String get receiptUploaded => 'Receipt uploaded';

  @override
  String get saveToGallery => 'Save to Gallery';

  @override
  String get imageSavedToGallery => 'Image saved to gallery';

  @override
  String get failedToDownloadImage => 'Failed to download image';

  @override
  String get seeAll => 'See all';

  @override
  String get me => 'Me';

  @override
  String get paymentsOverview => 'Payments Overview';

  @override
  String get paymentsOverviewDescription => 'You pay some, you owe some.';

  @override
  String get paymentPeriodDay => 'Day';

  @override
  String get paymentPeriodWeek => 'Week';

  @override
  String get paymentPeriodMonth => 'Month';

  @override
  String get paymentPeriodYear => 'Year';

  @override
  String get paymentPeriodAllTime => 'All';

  @override
  String get yourExpenses => 'My Expenses';

  @override
  String get paymentCount => 'Payments';

  @override
  String get paymentTotal => 'Total';

  @override
  String get noPaymentsInPeriod => 'No payments in this period';

  @override
  String get unableToEdit => 'Unable to Edit';

  @override
  String get cannotEditPaymentsCreatedByOtherUsers =>
      'You cannot edit payments created by other users';

  @override
  String get viewOnlyMode =>
      'View only - This payment was created by another user';

  @override
  String get download => 'Download';

  @override
  String get close => 'Close';

  @override
  String get paid => 'receives';

  @override
  String get owes => 'owes';

  @override
  String get youPaid => 'You Paid';

  @override
  String get youOwe => 'You Owe';

  @override
  String get viewPayments => 'View Payments';

  @override
  String get chartDescriptionSparklineNet =>
      'Your net balance over time. Positive values mean others owe you, negative means you owe others.';

  @override
  String get chartDescriptionPayerSharePie =>
      'Who paid for expenses in this period. Shows the percentage breakdown by payer.';

  @override
  String get chartDescriptionRoommateNetBars =>
      'Balance for each roommate. Green bars show what they are owed, red bars show what they owe.';

  @override
  String get chartDescriptionHouseholdOverTime =>
      'Total household spending per time bucket. Shows expense trends over the selected period.';

  @override
  String get participantValidationAtLeastOne =>
      'At least one participant must be selected.';

  @override
  String get participantValidationSplitMustMatch =>
      'Split total must match payment amount.';

  @override
  String get participantValidationSplitCannotExceed =>
      'Split total cannot exceed payment amount.';

  @override
  String get participantValidationShareGreaterThanZero =>
      'Each participant must have a share greater than 0.';

  @override
  String get participantValidationPercentagesMustTotal =>
      'Split percentages must total 100%.';

  @override
  String get participantValidationPercentagesCannotExceed =>
      'Percentage total cannot exceed 100%.';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get noDataAvailableForTimeframe =>
      'No data available for this timeframe, yet.';

  @override
  String get participantValidationNoSplitWithoutParticipants =>
      'Cannot have split method without participants';

  @override
  String get participantValidationCreatorMustParticipate =>
      'Payment creator must be a participant';

  @override
  String get participantValidationManualMustSumToTotal =>
      'Manual amounts must sum to total';

  @override
  String get participantValidationPercentagesMustSumTo100 =>
      'Percentages must sum to 100%';

  @override
  String get chooseHouseholdMemberToAssignTask =>
      'Choose a household member to assign this task to.';

  @override
  String get paymentParticipants => 'Participants';

  @override
  String get paymentSplitMethod => 'Split Method';

  @override
  String get paymentSplit => 'Split';

  @override
  String get payment => 'Payment';

  @override
  String get whoSharesThisExpense => 'Who shares this expense?';

  @override
  String get howToSplitPayment => 'How to split the payment';

  @override
  String get setAmountForSplitMethod => 'Set amount for the split method.';

  @override
  String get reset => 'Reset';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get created => 'Created';

  @override
  String get updated => 'Updated';

  @override
  String get validationError => 'Validation Error';

  @override
  String get setTotalAmountDescription => 'Set the total amount';

  @override
  String get youCreator => 'You';

  @override
  String get you => 'you';

  @override
  String get profile => 'Profile';

  @override
  String get userProfileInformation => 'User profile information';

  @override
  String get noItems => 'No items';

  @override
  String get shoppedAndLoaded => 'Shopped and loaded.';

  @override
  String get allTasksCompleted => 'All tasks completed';

  @override
  String get showThisToYourRoomy => 'Send this to your roomy.';

  @override
  String get invalidCredentialsMessage =>
      'The credentials provided are invalid, please try again.';

  @override
  String get invalidCredentialsTitle => 'Invalid credentials';

  @override
  String get networkErrorTitle => 'Network Error';

  @override
  String get accountAlreadyInUseMessage =>
      'The account is already in use, please try again.';

  @override
  String get accountAlreadyInUseTitle => 'Account already in use';

  @override
  String get invalidCredentialMessage =>
      'Something went wrong verifying the credential, please try again.';

  @override
  String get invalidCredentialTitle => 'Invalid credential';

  @override
  String get operationNotAllowedTitle => 'Operation not allowed';

  @override
  String get accountDisabledMessage =>
      'The account corresponding to the credential is disabled, please try again.';

  @override
  String get accountDisabledTitle => 'Account disabled';

  @override
  String get accountNotFoundMessage =>
      'The account corresponding to the credential was not found, please try again.';

  @override
  String get accountNotFoundTitle => 'Account not found';

  @override
  String get wrongPasswordMessage =>
      'The password is invalid, please try again.';

  @override
  String get wrongPasswordTitle => 'Wrong password';

  @override
  String get invalidVerificationCodeMessage =>
      'The verification code of the credential is invalid, please try again.';

  @override
  String get invalidVerificationCodeTitle => 'Invalid verification code';

  @override
  String get invalidVerificationIdMessage =>
      'The verification id of the credential is invalid, please try again.';

  @override
  String get invalidVerificationIdTitle => 'Invalid verification id';

  @override
  String get invalidEmailMessage =>
      'The email address provided is invalid, please try again.';

  @override
  String get invalidEmailTitle => 'Invalid email';

  @override
  String get emailAlreadyInUseMessage =>
      'The email used already exists, please use a different email or try to log in.';

  @override
  String get emailAlreadyInUseTitle => 'Email already in use';

  @override
  String get weakPasswordMessage =>
      'The password provided is too weak, please try again.';

  @override
  String get weakPasswordTitle => 'Weak password';

  @override
  String get invalidPhoneNumberMessage =>
      'The phone number has an invalid format. Please input a valid phone number.';

  @override
  String get invalidPhoneNumberTitle => 'Invalid Phone Number';

  @override
  String get captchaCheckFailedTitle => 'Captcha Check Failed';

  @override
  String get quotaExceededTitle => 'Quota Exceeded';

  @override
  String get providerAlreadyLinkedTitle => 'Provider Already Linked';

  @override
  String get credentialAlreadyInUseTitle => 'Credential Already In Use';

  @override
  String get unknownErrorMessage =>
      'An unknown error has occurred, please try again.';

  @override
  String get unknownErrorTitle => 'Unknown error';

  @override
  String get accountDeletedMessage =>
      'Your account has been successfully deleted.';

  @override
  String get accountDeletedTitle => 'Account deleted';

  @override
  String get failedToDeleteAccountMessage =>
      'An unknown error occurred while trying to delete your account.';

  @override
  String get failedToDeleteAccountTitle => 'Failed to delete account';

  @override
  String get accountLinkedMessage =>
      'Your account has been successfully linked.';

  @override
  String get accountLinkedTitle => 'Account linked';

  @override
  String get logoutSuccessfulMessage => 'You are no longer logged in.';

  @override
  String get logoutSuccessfulTitle => 'Logout successful';

  @override
  String get loginFailedTitle => 'Login failed';

  @override
  String get accountCreatedTitle => 'Account created';

  @override
  String get registerFailedTitle => 'Register failed';

  @override
  String get logoutFailedTitle => 'Logout failed';

  @override
  String get verifyEmailSentMessage =>
      'Please check your email to verify your account.';

  @override
  String get verifyEmailSentTitle => 'Verify email sent';

  @override
  String get emailNotVerifiedMessage =>
      'Could not verify your email at this time. Please try again later.';

  @override
  String get emailNotVerifiedTitle => 'Email Not Verified';

  @override
  String get emailVerifiedTitle => 'Email verified';

  @override
  String get welcomeBackTitle => 'Welcome back!';

  @override
  String get failedToLogInTitle => 'Failed to log in';

  @override
  String get accountCreationFailedTitle => 'Account creation failed';

  @override
  String get userIdIsNull => 'User ID is null';

  @override
  String get taskNotFoundMessage => 'Unable to find the task to update subtask';

  @override
  String get taskNotFoundTitle => 'Task not found';

  @override
  String get failedToUpdateSubtaskMessage =>
      'Failed to update subtask. Please try again.';

  @override
  String get conversionFailedMessage => 'Failed to convert screenshot';

  @override
  String get conversionFailedTitle => 'Conversion failed';

  @override
  String get unexpectedErrorMessage => 'An unexpected error occurred';

  @override
  String get errorTitle => 'Error';

  @override
  String get failedToDeleteItemMessage =>
      'An error occurred while deleting the item. Please try again.';

  @override
  String get failedToDeleteItemTitle => 'Failed to delete item';

  @override
  String get subtaskNameRequiredValidation => 'Subtask name is required';

  @override
  String get subtaskNameInvalidCharactersValidation =>
      'Subtask name contains invalid characters';

  @override
  String get subtaskNameMaxLengthValidation =>
      'Subtask name cannot exceed 100 characters';

  @override
  String get descriptionMaxLengthValidation =>
      'Description cannot exceed 500 characters';

  @override
  String get descriptionInvalidCharactersValidation =>
      'Description contains invalid characters';

  @override
  String get apiNameUsers => 'UsersApi';

  @override
  String get apiNameProfiles => 'ProfilesApi';

  @override
  String get apiNameUsernames => 'UsernamesApi';

  @override
  String get apiNameHouseholds => 'HouseholdsApi';

  @override
  String get apiNameSettings => 'SettingsApi';

  @override
  String get apiNameHouseholdInvites => 'HouseholdInvitesApi';

  @override
  String get apiNameInviteCodes => 'InviteCodesApi';

  @override
  String get apiNameShoppingLists => 'ShoppingListsApi';

  @override
  String get apiNameShoppingListItems => 'ShoppingListItemsApi';

  @override
  String get apiNameCleaningTasks => 'CleaningTasksApi';

  @override
  String get apiNameCleaningTimeSlots => 'CleaningTimeSlotsApi';

  @override
  String get apiNameCompletedCleaningTimeSlots =>
      'CompletedCleaningTimeSlotsApi';

  @override
  String get apiNameFeedbacks => 'FeedbacksApi';

  @override
  String get apiNamePayments => 'PaymentsApi';

  @override
  String get languageNameEngelsNL => 'Engels';

  @override
  String get languageNameEnglishEN => 'English';

  @override
  String get languageNameNederlandsNL => 'Nederlands';

  @override
  String get languageNameDutchEN => 'Dutch';

  @override
  String get contactTypeEmail => 'Email';

  @override
  String get contactTypePhoneNumber => 'Phone Number';

  @override
  String get contactTypeLink => 'Link';

  @override
  String get contactTypeUnknown => 'Unknown';

  @override
  String get welcomeToRoomyDescription => 'Welcome to Roomy';

  @override
  String get emailInputFieldLabel => 'Email input field';

  @override
  String get passwordInputFieldLabel => 'Password input field';

  @override
  String get loginButtonLabel => 'Login button';

  @override
  String get registerButtonLabel => 'Register button';

  @override
  String get switchToLoginLabel => 'Switch to login';

  @override
  String get loggedInTitle => 'Logged in';

  @override
  String get logoutButtonLabel => 'Logout button';

  @override
  String get acceptInviteLabel => 'Accept Invite';

  @override
  String get declineInviteLabel => 'Decline Invite';

  @override
  String get cancelInviteLabel => 'Cancel Invite';

  @override
  String get homeScreenLabel => 'Home screen';

  @override
  String get settingsButtonLabel => 'Settings button';

  @override
  String get invitesEmoji => '📨  ';

  @override
  String get requestsEmoji => '🤝  ';

  @override
  String get cancelInviteLabelAction => 'Cancel Invite';

  @override
  String get acceptRequestLabel => 'Accept Request';

  @override
  String get sentInvitesEmoji => '📤  ';

  @override
  String get myInvitesEmoji => '📨  ';

  @override
  String get declineInviteLabelAction => 'Decline Invite';

  @override
  String get shoppingItemDescription => 'Shopping item';

  @override
  String get memberStatisticsDescription => 'Member statistics';

  @override
  String get itemImageDescription => 'Item image';

  @override
  String get colorLabelWhite => 'White';

  @override
  String get colorLabelRed => 'Red';

  @override
  String get colorLabelGreen => 'Green';

  @override
  String get colorLabelBlue => 'Blue';

  @override
  String get colorLabelYellow => 'Yellow';

  @override
  String get colorLabelPurple => 'Purple';

  @override
  String get colorLabelOrange => 'Orange';

  @override
  String get colorLabelPink => 'Pink';

  @override
  String get colorLabelCyan => 'Cyan';

  @override
  String get colorLabelTeal => 'Teal';

  @override
  String get userProfileCardDescription => 'User profile card';

  @override
  String get errorAlreadyMember => 'You are already a member of this household';

  @override
  String get errorInvalidInviteCode =>
      'The invite code is invalid. Please check and try again.';

  @override
  String get errorHouseholdFull =>
      'This household has reached the maximum number of members';

  @override
  String get errorPendingInvite =>
      'You already have a pending invite to this household';

  @override
  String get errorRateLimited => 'Too many attempts. Please try again later.';

  @override
  String get errorUserNotFound =>
      'User profile not found. Please complete your profile setup.';

  @override
  String get errorInvalidCodeFormat =>
      'Invalid invite code format. The code should be 4 letters/numbers.';

  @override
  String get errorUnauthenticated => 'Please log in to continue';

  @override
  String get errorNotFound => 'The requested item was not found';

  @override
  String get errorPermissionDenied =>
      'You don\'t have permission to perform this action';

  @override
  String get unableToCompleteRequest => 'Unable to Complete Request';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notificationSettingsDescription =>
      'Control which notifications you receive.';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get enableNotificationsDescription =>
      'Receive push notifications for updates.';

  @override
  String get shoppingNotifications => 'Shopping Notifications';

  @override
  String get shoppingNotificationsDescription =>
      'Get notified about shopping list updates.';

  @override
  String get cleaningNotifications => 'Cleaning Notifications';

  @override
  String get cleaningNotificationsDescription =>
      'Get notified about cleaning task updates.';

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsDisabled => 'Notifications disabled';

  @override
  String get shoppingNotificationsEnabled => 'Shopping notifications enabled';

  @override
  String get shoppingNotificationsDisabled => 'Shopping notifications disabled';

  @override
  String get cleaningNotificationsEnabled => 'Cleaning notifications enabled';

  @override
  String get cleaningNotificationsDisabled => 'Cleaning notifications disabled';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get addedToShoppingList => 'Added to shopping list';

  @override
  String get completedShoppingItems => 'Shopping items completed';

  @override
  String get notificationMarkedAsRead => 'Marked as read';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String get notificationConsentBannerText =>
      'Enable notifications to know when your roomies go shopping';

  @override
  String get notificationConsentSheetTitle => 'Stay in the Loop';

  @override
  String get notificationConsentSheetBody =>
      'Get notified when your roomies add items to shopping lists or complete tasks. Never miss an update from your household.';

  @override
  String get notificationConsentCancelButton => 'Not Now';

  @override
  String get notificationConsentAcceptButton => 'Enable Notifications';

  @override
  String get notificationPermissionGrantedToast =>
      'Notifications enabled! You\'ll now receive updates from your household.';

  @override
  String get notificationPermissionDeniedToast =>
      'Notifications disabled. You can enable them later in Settings.';

  @override
  String get notificationPermissionDeniedInfo =>
      'Notification permission is disabled. Enable it in your device settings to receive updates.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get appName => 'Turbo Template';

  @override
  String welcomeToApp(String appName) {
    return 'Welcome to $appName';
  }
}

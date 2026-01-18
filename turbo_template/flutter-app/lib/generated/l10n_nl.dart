// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class StringsNl extends Strings {
  StringsNl([String locale = 'nl']) : super(locale);

  @override
  String get aHousehold => 'een huishouden';

  @override
  String get accept => 'Accepteren';

  @override
  String acceptingInviteWillRemoveYouFromCurrentHousehold(
    Object householdName,
  ) {
    return 'Dit verwijdert je uit \'$householdName\'. Doorgaan?';
  }

  @override
  String get account => 'Account';

  @override
  String get accountCreated => 'Account aangemaakt';

  @override
  String get accountCreationFailed => 'Account aanmaken mislukt';

  @override
  String get add => 'Toevoegen';

  @override
  String get addEmail => 'E-mail toevoegen';

  @override
  String get addItem => 'Item toevoegen';

  @override
  String get addItemToList => 'Item aan lijst toevoegen';

  @override
  String get addLink => 'Link toevoegen';

  @override
  String get addPhoneNumber => 'Telefoonnummer toevoegen';

  @override
  String get addRoomy => 'Lid toevoegen';

  @override
  String get addSubtask => 'Subtaak toevoegen';

  @override
  String get addSubtaskHint => 'Nieuwe subtaak toevoegen...';

  @override
  String get addSubtasksToBreakDownYourTask =>
      'Voeg subtaken toe om je taak op te delen in kleinere stappen';

  @override
  String get addTask => 'Taak toevoegen';

  @override
  String get addedBy => 'Toegevoegd door';

  @override
  String addedByUserOnDate(Object date, Object user) {
    return 'Toegevoegd door $user op $date';
  }

  @override
  String get allItemsUnchecked => 'Alle items uitgevinkt';

  @override
  String get allTasks => 'Alle taken';

  @override
  String get allTasksDescription =>
      'Bekijk alle schoonmaaktaken in je huishouden. Je kunt niet-toegewezen taken claimen, zien wie verantwoordelijk is voor elke taak en het volledige schoonmaakschema volgen';

  @override
  String get alreadyHaveAccount => 'Heb je al een account?';

  @override
  String get alreadyInUse => 'Al in gebruik';

  @override
  String get anErrorOccurredWhileTryingToLogoutPleaseTryAgain =>
      'Er is een fout opgetreden bij het uitloggen. Probeer het later opnieuw.';

  @override
  String get anUnknownErrorOccurredPleaseTryAgainLater =>
      'Er is een onbekende fout opgetreden. Probeer het later opnieuw.';

  @override
  String get and => 'en';

  @override
  String andCountMore(int count) {
    return '+ $count meer';
  }

  @override
  String get anotherDayAnotherList => 'Weer een dag, weer een lijst.';

  @override
  String get apr => 'apr';

  @override
  String get april => 'april';

  @override
  String get areYouSureYouWantToDeclineThisInvite =>
      'Weet je zeker dat je deze uitnodiging wilt weigeren?';

  @override
  String get areYouSureYouWantToDeleteThisImage =>
      'Weet je zeker dat je deze afbeelding wilt verwijderen?';

  @override
  String get areYouSureYouWantToDeleteThisItem =>
      'Weet je zeker dat je dit item wilt verwijderen?';

  @override
  String get areYouSureYouWantToDeleteThisShoppingList =>
      'Weet je zeker dat je deze boodschappenlijst wilt verwijderen?';

  @override
  String get areYouSureYouWantToDeleteThisSubtask =>
      'Weet je zeker dat je deze subtaak wilt verwijderen?';

  @override
  String get areYouSureYouWantToDeleteThisTask =>
      'Weet je zeker dat je deze taak wilt verwijderen?';

  @override
  String get areYouSureYouWantToLeaveThisHousehold =>
      'Weet je zeker dat je dit huishouden wilt verlaten?';

  @override
  String get areYouSureYouWantToLogout =>
      'Weet je zeker dat je wilt uitloggen?';

  @override
  String get areYouSureYouWantToProceedThisWillTake =>
      'Weet je zeker dat je wilt doorgaan? Dit brengt je naar de pagina om je account te verwijderen.';

  @override
  String get areYouSureYouWantToRemoveThisMember =>
      'Weet je zeker dat je dit lid wilt verwijderen?';

  @override
  String get areYouSureYouWantToUnassignThisTask =>
      'Weet je zeker dat je deze taak wilt loskoppelen?';

  @override
  String get areYouSureYouWantToUncheckAllItems =>
      'Weet je zeker dat je alle items wilt uitvinken?';

  @override
  String get assign => 'Toewijzen';

  @override
  String get assigned => 'Toegewezen';

  @override
  String get assignedTo => 'Toegewezen aan';

  @override
  String get assignment => 'Toewijzing';

  @override
  String get aug => 'aug';

  @override
  String get august => 'augustus';

  @override
  String get back => 'Terug';

  @override
  String get beforeMovingOnTakeAMomentToReadHowWe =>
      'Neem even de tijd om te lezen hoe wij je persoonlijke gegevens beschermen voordat je verdergaat.';

  @override
  String get bekijkSchema => 'Bekijk schema';

  @override
  String get biography => 'Biografie';

  @override
  String bug(Object bug) {
    return '$bug Bug';
  }

  @override
  String get bulkActions => 'Bulk acties';

  @override
  String get byClickingContinue =>
      'Door op doorgaan te klikken, ga je akkoord met onze';

  @override
  String get camera => 'Camera';

  @override
  String get cancel => 'Annuleren';

  @override
  String get cancelInvite => 'Uitnodiging annuleren';

  @override
  String get areYouSureYouWantToCancelThisInvite =>
      'Weet je zeker dat je deze uitnodiging wilt annuleren?';

  @override
  String get failedToCancelInvitePleaseTryAgainLater =>
      'Uitnodiging annuleren is nu niet gelukt, probeer het later opnieuw.';

  @override
  String get changeName => 'Naam wijzigen';

  @override
  String get changePassword => 'Wachtwoord wijzigen';

  @override
  String get checkAllTasksToClaimOrGetAssigned =>
      'Bekijk \'Schema\' om te claimen of toe te wijzen.';

  @override
  String get checkStatus => 'Status controleren';

  @override
  String get checkYourSpamFolder =>
      'Kun je hem niet vinden? Controleer je spam of ongewenste map.';

  @override
  String get checkmarkSymbol => '✅';

  @override
  String get claim => 'Claimen';

  @override
  String get claimTask => 'Taak claimen';

  @override
  String get claimTaskConfirmationMessage =>
      'Weet je zeker dat je deze taak wilt claimen? Dit wijst hem aan jou toe.';

  @override
  String get claimTaskConfirmationTitle => 'Deze taak claimen?';

  @override
  String get cleaning => 'Schoonmaken';

  @override
  String get cleaningFrequency => 'Frequentie';

  @override
  String get cleaningSchedule => 'Schoonmaakschema';

  @override
  String get cleaningTaskDescription => 'Beschrijving';

  @override
  String get cleaningTaskDescriptionHint =>
      'bijv. Kort overzicht van wat er gedaan moet worden';

  @override
  String get cleaningTaskDescriptionMaxLength =>
      'Beschrijving mag maximaal 200 tekens lang zijn.';

  @override
  String get enterValidNumber => 'Voer een geldig nummer in.';

  @override
  String get cleaningTaskFrequencyMaxCount =>
      'Frequentie moet maximaal 100 zijn.';

  @override
  String get cleaningTaskFrequencyMinCount =>
      'Frequentie moet minimaal 1 zijn.';

  @override
  String get cleaningTaskFrequencyRequired => 'Dit veld is verplicht';

  @override
  String get cleaningTaskInstructions => 'Instructies';

  @override
  String get cleaningTaskInstructionsHint =>
      'bijv. Maak de douche, toilet en wastafel schoon';

  @override
  String get cleaningTaskInstructionsMaxLength =>
      'Instructies mogen maximaal 200 tekens lang zijn.';

  @override
  String get cleaningTaskName => 'Naam';

  @override
  String get cleaningTaskNameHint => 'bijv. Badkamer schoonmaken';

  @override
  String get cleaningTaskNameMaxLength =>
      'Naam mag maximaal 50 tekens lang zijn.';

  @override
  String get cleaningTaskNameMinLength =>
      'Naam moet minimaal 1 teken lang zijn.';

  @override
  String get cleaningTaskSize => 'Grootte';

  @override
  String get cleaningTaskSizeHint =>
      'Selecteer het inspanningsniveau voor deze taak';

  @override
  String get cleaningTaskSizeL => 'Groot';

  @override
  String get cleaningTaskSizeM => 'Medium';

  @override
  String get cleaningTaskSizeS => 'Klein';

  @override
  String get cleaningTaskSizeXl => 'Extra groot';

  @override
  String get cleaningTaskSizeXs => 'Extra klein';

  @override
  String get cleaningTaskTimespanRequired => 'Dit veld is verplicht';

  @override
  String get cleaningTasksEmptySubtitle =>
      'Maak je eerste schoonmaaktaak aan om georganiseerd te worden.';

  @override
  String get cleaningTimespan => 'Tijdsperiode';

  @override
  String get cleaningTimespanDay => 'Dag';

  @override
  String get cleaningTimespanMonth => 'Maand';

  @override
  String get cleaningTimespanWeek => 'Week';

  @override
  String get cleaningTimespanYear => 'Jaar';

  @override
  String get clickHereToLogin => 'Klik hier om in te loggen';

  @override
  String get clickToView => 'Klik om te bekijken';

  @override
  String get codeInvullen => 'Huishouden joinen';

  @override
  String get codeTonen => 'Code tonen';

  @override
  String get complete => 'Voltooien';

  @override
  String get completed => 'Voltooid';

  @override
  String get completedByYou => 'Door jou voltooid';

  @override
  String get components => 'Componenten';

  @override
  String get configure => 'Configureren';

  @override
  String get confirmYourPassword => 'Bevestig je wachtwoord';

  @override
  String get copyToClipboard => 'Kopiëren naar klembord';

  @override
  String get core => 'Kern';

  @override
  String get create => 'Aanmaken';

  @override
  String get createAccount => 'Account aanmaken';

  @override
  String get createAndManageYourCleaningTasks =>
      'Zeer belangrijke taakdetails.';

  @override
  String get createShoppingList => 'Boodschappenlijst aanmaken';

  @override
  String get createYourFirstHousehold => 'Maak je eerste huishouden aan!';

  @override
  String createdAtDateString(Object dateString) {
    return 'Aangemaakt op $dateString';
  }

  @override
  String get crossSymbol => '❌';

  @override
  String get dangerZone => 'Gevarenzone';

  @override
  String get databaseFailure => 'Database fout';

  @override
  String get day => 'dag';

  @override
  String get dayOfMonth => 'Dag van de maand';

  @override
  String get dayOfMonthPlaceholder => 'bijv. 15';

  @override
  String get days => 'dagen';

  @override
  String get deadline => 'Deadline';

  @override
  String get dec => 'dec';

  @override
  String get december => 'december';

  @override
  String get decline => 'Weigeren';

  @override
  String get declineInvite => 'Uitnodiging weigeren';

  @override
  String get decrease => 'Verlagen';

  @override
  String get delete => 'Verwijderen';

  @override
  String get deleteAccount => 'Account verwijderen';

  @override
  String get deleteImage => 'Afbeelding verwijderen';

  @override
  String get deleteItem => 'Item verwijderen';

  @override
  String get deleteShoppingList => 'Boodschappenlijst verwijderen';

  @override
  String get deletingFailed => 'Verwijderen mislukt';

  @override
  String get description => 'Beschrijving';

  @override
  String get doYouWantToVisitThePrivacyPolicy =>
      'Wil je het privacybeleid bekijken?';

  @override
  String get doYouWantToVisitTheTermsOfService =>
      'Wil je de servicevoorwaarden bekijken?';

  @override
  String get dontHaveAccount => 'Heb je geen account?';

  @override
  String get dragToReorder => 'Sleep om te herschikken';

  @override
  String get dutch => 'Nederlands';

  @override
  String get edit => 'Bewerken';

  @override
  String get editItem => 'Item bewerken';

  @override
  String get editLanguage => 'Taal bewerken';

  @override
  String get editName => 'Naam bewerken';

  @override
  String get editProfile => 'Profiel bewerken';

  @override
  String get editShoppingListDetails => 'Boodschappenlijst details bewerken';

  @override
  String get editTask => 'Taak bewerken';

  @override
  String get editYourShoppingList => 'Bewerk je boodschappenlijst';

  @override
  String get email => 'E-mail';

  @override
  String get emailHint => 'jouw@email.com';

  @override
  String get emailNotYetVerified => 'E-mail nog niet geverifieerd';

  @override
  String get emailSent => 'E-mail verzonden';

  @override
  String get emailVerified => 'E-mail geverifieerd';

  @override
  String get emptyPlaceholderAnEmptyList =>
      'Een lege lijst is een heldere hemel; wat ga je bouwen?';

  @override
  String get emptyPlaceholderBlankCanvas =>
      'Een leeg canvas wacht op je meesterwerk.';

  @override
  String get emptyPlaceholderEmptySpaces =>
      'Lege ruimtes zijn slechts ruimte voor groei.';

  @override
  String get emptyPlaceholderNoEntries =>
      'Nog geen items, maar eindeloos potentieel.';

  @override
  String get emptyPlaceholderNotAVoid =>
      'Dit is geen leegte, het is een podium.';

  @override
  String get emptyPlaceholderNotSadJustEmpty => 'Niet treurig, gewoon leeg.';

  @override
  String get emptyPlaceholderNothingHere =>
      'Hier is niets behalve mogelijkheden.';

  @override
  String get emptyPlaceholderTheEmptiness =>
      'De leegte die je ziet is de ruimte voor je volgende prestatie.';

  @override
  String get emptyPlaceholderTheEmptinessIsNotALack =>
      'De leegte is geen gebrek, maar een ruimte om te vullen.';

  @override
  String get emptyPlaceholderZeroItems => 'Nul items, eindeloze mogelijkheden.';

  @override
  String get emptySubtasksMessage =>
      'Nog geen subtaken. Voeg er hierboven een toe!';

  @override
  String get english => 'Engels';

  @override
  String get enterADescriptionForYourShoppingList =>
      'Voer een beschrijving in voor je boodschappenlijst';

  @override
  String get enterANameForYourShoppingList =>
      'Voer een naam in voor je boodschappenlijst';

  @override
  String get enterAValidEmail => 'Voer een geldig e-mailadres in';

  @override
  String get enterDetailsToRegister => 'Voer je gegevens in om te registreren';

  @override
  String get enterInviteCode => 'Code invoeren';

  @override
  String get enterTheNameForTheNewShoppingList =>
      'Voer de naam in voor de nieuwe boodschappenlijst. Deze is zichtbaar voor alle leden.';

  @override
  String get enterTheNewNameForTheHouseholdThisWillBe =>
      'Voer de nieuwe naam in voor het huishouden. Deze is zichtbaar voor alle leden.';

  @override
  String get enterValidPhoneNumber => 'Voer een geldig telefoonnummer in';

  @override
  String get enterValidURL => 'Voer een geldige URL in';

  @override
  String get enterValueBetween1And31 => 'Voer een waarde in tussen 1 en 31';

  @override
  String get enterWhatWasExpectedAndWhatActuallyHappened =>
      'Voer in wat er verwacht werd en wat er daadwerkelijk gebeurde.';

  @override
  String get enterYourEmail => 'Voer je e-mail in';

  @override
  String get enterYourIdeaForAnImprovementOrFeatureRequest =>
      'Voer je idee in voor een verbetering of functie-aanvraag.';

  @override
  String get enterYourPassword => 'Voer je wachtwoord in';

  @override
  String get error => 'Fout';

  @override
  String get errorCreatingCleaningTask => 'Fout bij aanmaken schoonmaaktaak';

  @override
  String get errorUpdatingCleaningTask => 'Fout bij bijwerken schoonmaaktaak';

  @override
  String get every => 'Elke';

  @override
  String get failedToAcceptInvitePleaseTryAgainLaterAndContact =>
      'Uitnodiging accepteren mislukt, probeer het later opnieuw en neem contact met ons op als het probleem aanhoudt.';

  @override
  String get failedToAddItem => 'Item toevoegen mislukt';

  @override
  String get failedToAddSubtask => 'Subtaak toevoegen mislukt';

  @override
  String get failedToAssignTaskPleaseTryAgain =>
      'Taak toewijzen mislukt. Probeer het opnieuw.';

  @override
  String get failedToCallCloudFunction => 'Cloud functie aanroepen mislukt';

  @override
  String get failedToClaimTaskPleaseTryAgain =>
      'Taak claimen mislukt. Probeer het opnieuw.';

  @override
  String get failedToCompleteTask => 'Taak voltooien mislukt';

  @override
  String get failedToCreateCleaningTaskPleaseTryAgainLater =>
      'Schoonmaaktaak aanmaken mislukt, probeer het later opnieuw';

  @override
  String get failedToDeclineInviteRightNowPleaseTryAgainLater =>
      'Uitnodiging weigeren is nu niet gelukt, probeer het later opnieuw en neem contact met ons op als het probleem aanhoudt.';

  @override
  String get failedToDeleteImagePleaseTryAgainLater =>
      'Afbeelding verwijderen mislukt. Probeer het later opnieuw.';

  @override
  String get failedToDeleteItemPleaseTryAgainLater =>
      'Item verwijderen mislukt. Probeer het later opnieuw.';

  @override
  String get failedToDeleteShoppingListPleaseTryAgainLater =>
      'Boodschappenlijst verwijderen mislukt. Probeer het later opnieuw.';

  @override
  String get failedToDeleteSubtask => 'Subtaak verwijderen mislukt';

  @override
  String get failedToDeleteTaskPleaseTryAgainLater =>
      'Taak verwijderen mislukt. Probeer het later opnieuw.';

  @override
  String get failedToLoadCleaningTasks =>
      'Schoonmaaktaken laden mislukt. Probeer het opnieuw.';

  @override
  String get failedToLogIn => 'Inloggen mislukt';

  @override
  String get failedToNavigateToAddTask =>
      'Navigeren naar taak toevoegen mislukt. Probeer het opnieuw.';

  @override
  String get failedToNavigateToTask =>
      'Navigeren naar taak mislukt. Probeer het opnieuw.';

  @override
  String get failedToRemoveMemberRightNowPleaseTryAgainLater =>
      'Lid verwijderen is nu niet gelukt. Probeer het later opnieuw.';

  @override
  String get failedToReorderItemsPleaseTryAgain =>
      'Items herschikken mislukt, probeer het opnieuw.';

  @override
  String get failedToReorderSubtasks => 'Subtaken herschikken mislukt';

  @override
  String get failedToSelectImagePleaseTryAgainIfTheProblem =>
      'Afbeelding selecteren mislukt. Probeer het opnieuw. Neem contact op met support als het probleem aanhoudt.';

  @override
  String get failedToSendInvite => 'Uitnodiging verzenden mislukt';

  @override
  String get failedToShowAssignmentOptions =>
      'Toewijzingsopties tonen mislukt.';

  @override
  String get failedToTakePhotoPleaseTryAgainIfTheProblem =>
      'Foto maken mislukt. Probeer het opnieuw. Neem contact op met support als het probleem aanhoudt.';

  @override
  String get failedToUnassignTaskPleaseTryAgain =>
      'Taak loskoppelen mislukt. Probeer het opnieuw.';

  @override
  String get failedToUncheckAllItems => 'Alle items uitvinken mislukt';

  @override
  String get failedToUncompleteTask => 'Taak ongedaan maken mislukt';

  @override
  String get failedToUpdateCleaningTaskPleaseTryAgainLater =>
      'Schoonmaaktaak bijwerken mislukt, probeer het later opnieuw';

  @override
  String get failedToUpdateName => 'Naam bijwerken mislukt';

  @override
  String get failedToUpdateShoppingList =>
      'Boodschappenlijst bijwerken mislukt';

  @override
  String get failedToUpdateSubtask => 'Subtaak bijwerken mislukt';

  @override
  String get failedToUpdateTimeSlots => 'Tijdsloten bijwerken mislukt';

  @override
  String get failedToUploadImagePleaseTryAgainLater =>
      'Afbeelding uploaden mislukt. Probeer het later opnieuw.';

  @override
  String get feb => 'feb';

  @override
  String get february => 'februari';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackButton_tooltip => 'Feedback verzenden';

  @override
  String get feedbackSubmitted => 'Feedback verzonden';

  @override
  String get fillInYourBiography => 'Vul je biografie in';

  @override
  String get fillInYourEmail => 'Vul je e-mail in';

  @override
  String get fillInYourEmailAddressAndWeWillSendYou => 'Vul je e-mailadres in.';

  @override
  String get fillInYourLink => 'Vul je link in';

  @override
  String get fillInYourPhoneNumber => 'Vul je telefoonnummer in';

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get frequencyCountPlaceholder => 'bijv. 2';

  @override
  String get frequencyMode => 'Keer per periode';

  @override
  String get frequencyModeExample =>
      'bijv. \"2 keer per week\" of \"4 keer per maand\"';

  @override
  String get fri => 'vr';

  @override
  String get friday => 'vrijdag';

  @override
  String get friendsTeachUsTrustRoommatesTeachUsHarmony => 'De uitverkorenen.';

  @override
  String get gallery => 'Galerij';

  @override
  String get general => 'Algemeen';

  @override
  String get generalSettingsInTheApp => 'Algemene instellingen in de app.';

  @override
  String get generateInviteCode => 'Uitnodigingscode genereren';

  @override
  String get generatingInviteCode => 'Uitnodigingscode genereren...';

  @override
  String get goBack => 'Ga terug';

  @override
  String get gotIt => 'Begrepen';

  @override
  String helloUsername(Object username) {
    return 'Hallo @$username';
  }

  @override
  String get hiddenPass => '••••••••';

  @override
  String get home => 'Home';

  @override
  String get household => 'Huishouden';

  @override
  String householdCreated(Object householdName) {
    return '$householdName aangemaakt!';
  }

  @override
  String get householdInvite => 'Huishouden uitnodiging';

  @override
  String get householdInvites => 'Huishouden uitnodigingen';

  @override
  String get householdNameAdjectiveBusy => 'Druk';

  @override
  String get householdNameAdjectiveCharming => 'Charmant';

  @override
  String get householdNameAdjectiveCheerful => 'Vrolijk';

  @override
  String get householdNameAdjectiveComfy => 'Comfortabel';

  @override
  String get householdNameAdjectiveCozy => 'Gezellig';

  @override
  String get householdNameAdjectiveCreative => 'Creatief';

  @override
  String get householdNameAdjectiveCute => 'Schattig';

  @override
  String get householdNameAdjectiveFriendly => 'Vriendelijk';

  @override
  String get householdNameAdjectiveHappy => 'Blij';

  @override
  String get householdNameAdjectiveInviting => 'Uitnodigend';

  @override
  String get householdNameAdjectiveLively => 'Levendig';

  @override
  String get householdNameAdjectiveModern => 'Modern';

  @override
  String get householdNameAdjectivePeaceful => 'Vredig';

  @override
  String get householdNameAdjectiveQuaint => 'Pittoresk';

  @override
  String get householdNameAdjectiveQuiet => 'Rustig';

  @override
  String get householdNameAdjectiveRelaxed => 'Ontspannen';

  @override
  String get householdNameAdjectiveRustic => 'Rustiek';

  @override
  String get householdNameAdjectiveSecluded => 'Afgelegen';

  @override
  String get householdNameAdjectiveSerene => 'Sereen';

  @override
  String get householdNameAdjectiveShared => 'Gedeeld';

  @override
  String get householdNameAdjectiveSnug => 'Knus';

  @override
  String get householdNameAdjectiveSunny => 'Zonnig';

  @override
  String get householdNameAdjectiveTranquil => 'Rustig';

  @override
  String get householdNameAdjectiveVibrant => 'Levendig';

  @override
  String get householdNameAdjectiveWarm => 'Warm';

  @override
  String get householdNameMustBeAtLeast3CharactersLong =>
      'Huishoudnaam moet minimaal 3 tekens lang zijn';

  @override
  String get householdNameMustBeAtMost50CharactersLong =>
      'Huishoudnaam mag maximaal 50 tekens lang zijn';

  @override
  String get householdNameNounAbode => 'Verblijf';

  @override
  String get householdNameNounBase => 'Basis';

  @override
  String get householdNameNounCabin => 'Hut';

  @override
  String get householdNameNounCastle => 'Kasteel';

  @override
  String get householdNameNounCorner => 'Hoek';

  @override
  String get householdNameNounCottage => 'Huisje';

  @override
  String get householdNameNounCrew => 'Crew';

  @override
  String get householdNameNounDen => 'Hol';

  @override
  String get householdNameNounDwelling => 'Woning';

  @override
  String get householdNameNounFamily => 'Familie';

  @override
  String get householdNameNounHangout => 'Hangplek';

  @override
  String get householdNameNounHaven => 'Haven';

  @override
  String get householdNameNounHeadquarters => 'Hoofdkwartier';

  @override
  String get householdNameNounHideaway => 'Schuilplaats';

  @override
  String get householdNameNounHome => 'Thuis';

  @override
  String get householdNameNounHub => 'Hub';

  @override
  String get householdNameNounLodge => 'Lodge';

  @override
  String get householdNameNounNest => 'Nest';

  @override
  String get householdNameNounOasis => 'Oase';

  @override
  String get householdNameNounPad => 'Stekkie';

  @override
  String get householdNameNounPlace => 'Plek';

  @override
  String get householdNameNounRetreat => 'Toevluchtsoord';

  @override
  String get householdNameNounSanctuary => 'Heiligdom';

  @override
  String get householdNameNounSpot => 'Spot';

  @override
  String get householdNameNounSquad => 'Squad';

  @override
  String get householdRequests => 'Huishouden verzoeken';

  @override
  String get householdsThatYouHaveBeenInvitedTo =>
      'Huishoudens waarvoor je bent uitgenodigd.';

  @override
  String get householdsYouRequestedToJoin => 'Wachtend op goedkeuring van';

  @override
  String get iAgreeToThe => 'Ik ga akkoord met de';

  @override
  String idea(Object idea) {
    return '$idea Idee';
  }

  @override
  String ifRegisteredWeSend(Object email) {
    return 'Als $email bij ons is geregistreerd, is er een wachtwoord reset e-mail verzonden.';
  }

  @override
  String get imageDeleted => 'Afbeelding verwijderd';

  @override
  String get imageUploaded => 'Afbeelding geüpload';

  @override
  String inDays(int count) {
    return 'over $count dagen';
  }

  @override
  String inMonths(int count) {
    return 'over $count maanden';
  }

  @override
  String get inOneDay => 'over 1 dag';

  @override
  String get inOneMonth => 'over 1 maand';

  @override
  String get inOnePlusWeek => 'over 1+ week';

  @override
  String inWeeks(Object inWeeks) {
    return 'Over $inWeeks weken';
  }

  @override
  String inWeeksPlus(int count) {
    return 'over $count+ weken';
  }

  @override
  String get inbox => 'Inbox';

  @override
  String get increase => 'Verhogen';

  @override
  String get intervalMode => 'Herhaal elke...';

  @override
  String get intervalModeExample =>
      'bijv. \"Elke 3 dagen\" of \"Elke 2 weken\"';

  @override
  String get intervalValuePlaceholder => 'bijv. 3';

  @override
  String get invalidDayOfMonth => 'Dag van de maand moet tussen 1 en 31 zijn';

  @override
  String get invalidFrequencyCount => 'Frequentie moet groter zijn dan 0';

  @override
  String get invalidIntervalValue => 'Intervalwaarde moet groter zijn dan 0';

  @override
  String get invalidQuantity => 'Ongeldige hoeveelheid';

  @override
  String get invalidTimeSlot => 'Ongeldig tijdslot';

  @override
  String get invite => 'Uitnodigen';

  @override
  String get inviteAccepted => 'Uitnodiging geaccepteerd!';

  @override
  String get inviteCanceled => 'Uitnodiging geannuleerd!';

  @override
  String get inviteCode => 'Uitnodigingscode';

  @override
  String get inviteCodeCopied => 'Uitnodigingscode gekopieerd naar klembord';

  @override
  String get inviteCodeInvalid =>
      'Ongeldige code. Controleer en probeer opnieuw.';

  @override
  String get inviteCodeMustBeExactly4Characters => 'Code moet 4 tekens zijn';

  @override
  String get inviteCodeRequired => 'Voer code in (4 tekens)';

  @override
  String get inviteDeclined => 'Uitnodiging geweigerd!';

  @override
  String get inviteHouseholdMessage =>
      'Voer gebruikersnaam in om uit te nodigen.';

  @override
  String get inviteSent => 'Uitnodiging verzonden';

  @override
  String get inviteSentSuccessfully => 'Uitnodiging verzonden';

  @override
  String get invited => 'Uitgenodigd';

  @override
  String get invitesSentToOthersToJoinYourHousehold =>
      'Uitnodigingen verzonden aan anderen om lid te worden van je huishouden.';

  @override
  String get item => 'Item';

  @override
  String get itemAdded => 'Item toegevoegd';

  @override
  String get itemCompleted => 'Item voltooid';

  @override
  String get itemDeleted => 'Item verwijderd';

  @override
  String get itemUncompleted => 'Item ongedaan gemaakt';

  @override
  String get itemUpdated => 'Item bijgewerkt';

  @override
  String get jan => 'jan';

  @override
  String get january => 'januari';

  @override
  String get joinHousehold => 'Huishouden joinen';

  @override
  String get joinOrLeaveAHousehold => 'Een huishouden joinen of verlaten.';

  @override
  String get joinRequestSent => 'Lidmaatschapsverzoek verzonden';

  @override
  String get joinRequests => 'Lidmaatschapsverzoeken';

  @override
  String get jul => 'jul';

  @override
  String get july => 'juli';

  @override
  String get jun => 'jun';

  @override
  String get june => 'juni';

  @override
  String get language => 'Taal';

  @override
  String get languageChanged => 'Taal gewijzigd';

  @override
  String languageChangedToSupportedLanguage(Object supportedLanguage) {
    return 'Taal gewijzigd naar $supportedLanguage';
  }

  @override
  String lastUpdateAtString(Object lastUpdatedAtString) {
    return 'Laatste update op $lastUpdatedAtString';
  }

  @override
  String get lastWeek => 'Vorige week';

  @override
  String get lazyLoading => 'Lazy Loading';

  @override
  String get leave => 'Verlaten';

  @override
  String get leaveAndJoin => 'Verlaten';

  @override
  String get leaveCurrentHousehold => 'Huidig huishouden verlaten?';

  @override
  String get leaveHousehold => 'Huishouden verlaten';

  @override
  String get leaveJoin => 'Verlaten';

  @override
  String get link => 'Link';

  @override
  String get linkHint => 'bijv. https://twitter.com/gebruikersnaam';

  @override
  String get list => 'Lijst';

  @override
  String get loading => 'Laden';

  @override
  String get loggedIn => 'Ingelogd';

  @override
  String get loggedOut => 'Uitgelogd';

  @override
  String get login => 'Inloggen';

  @override
  String loginToAccount(Object appName) {
    return 'Log in op je $appName account';
  }

  @override
  String get logout => 'Uitloggen';

  @override
  String get logoutFailed => 'Uitloggen mislukt';

  @override
  String get mainShoppingList => 'Hoofd boodschappenlijst';

  @override
  String get manage => 'Beheren';

  @override
  String get manageCleaningTask => 'Schoonmaaktaak beheren';

  @override
  String get manageHouseholdMembers => 'Huishoudenleden beheren';

  @override
  String get managePendingInvitesToJoinADifferentHousehold =>
      'Beheer openstaande uitnodigingen om lid te worden van een ander huishouden';

  @override
  String get managePendingInvitesToJoinThisHousehold =>
      'Beheer openstaande uitnodigingen om lid te worden van dit huishouden.';

  @override
  String get manageYourHouseholdMembersAndSettings => 'Home sweet home.';

  @override
  String get manageYourShoppingListsAndItems =>
      'Boodschappen doen makkelijk gemaakt.';

  @override
  String get management => 'Beheer';

  @override
  String get mar => 'mrt';

  @override
  String get march => 'maart';

  @override
  String maxLengthExceeded(int length) {
    return 'Maximale lengte van $length tekens overschreden';
  }

  @override
  String get maximumHouseholdMembersReached =>
      'Maximaal aantal huishoudenleden bereikt';

  @override
  String get maximumHouseholdMembersReachedMessage =>
      'Dit huishouden heeft het maximale ledenlimiet bereikt. Neem contact op met de eigenaar van het huishouden als je denkt dat dit een fout is.';

  @override
  String get maximumSkipsReached => 'Maximaal aantal overgeslagen bereikt';

  @override
  String maximumValueExceeded(double value) {
    return 'Maximale waarde van $value overschreden';
  }

  @override
  String get may => 'mei';

  @override
  String get member => 'Lid';

  @override
  String get memberRemoved => 'Lid verwijderd!';

  @override
  String memberSinceCreatedAtString(Object createdAtString) {
    return 'Lid sinds $createdAtString';
  }

  @override
  String memberSinceDate(Object date) {
    return 'Lid sinds $date';
  }

  @override
  String get members => 'Leden';

  @override
  String get messageMustBeLessThan500Characters =>
      'Bericht moet minder dan 500 tekens zijn';

  @override
  String minimumValueRequired(double value) {
    return 'Minimale waarde van $value is vereist';
  }

  @override
  String get minute => 'minuut';

  @override
  String get minutes => 'minuten';

  @override
  String get missingList => 'Ontbrekende lijst';

  @override
  String get mon => 'ma';

  @override
  String get monday => 'maandag';

  @override
  String get month => 'maand';

  @override
  String get months => 'maanden';

  @override
  String get myCleaningSchedule => 'Mijn schoonmaakschema';

  @override
  String get myHousehold => 'Mijn huishouden';

  @override
  String get myInvites => 'Mijn uitnodigingen';

  @override
  String get myRequests => 'Mijn verzoeken';

  @override
  String get myRoomies => 'Mijn huisgenoten';

  @override
  String get myShoppingLists => 'Mijn boodschappenlijsten';

  @override
  String get myTasks => 'Mijn taken';

  @override
  String get myTasksDescription =>
      'Hier vind je alle taken die aan jou zijn toegewezen.';

  @override
  String get name => 'Naam';

  @override
  String nameCanBeAtMost(Object kLimitsMaxNameLength) {
    return 'Naam mag maximaal $kLimitsMaxNameLength tekens lang zijn.';
  }

  @override
  String get nameChangedSuccessfully => 'Naam succesvol gewijzigd';

  @override
  String get nameMustBeLessThan50Characters =>
      'Naam moet minder dan 50 tekens zijn';

  @override
  String get nextDeadline => 'Volgende deadline';

  @override
  String nextDue(Object date) {
    return 'Volgende: $date';
  }

  @override
  String get nextWeek => 'Volgende week';

  @override
  String get noCleaningTasksYet => 'Nog geen schoonmaaktaken!';

  @override
  String get noCount => '-';

  @override
  String get noDeadline => 'Geen deadline';

  @override
  String get noDescription => 'Geen beschrijving';

  @override
  String get noHouseholdFound => 'Geen huishouden gevonden';

  @override
  String get noHouseholdMembersAvailableForAssignment =>
      'Geen huishoudenleden beschikbaar voor toewijzing.';

  @override
  String get noInstructionsProvided => 'Geen instructies gegeven';

  @override
  String get noInviteCodeAvailable =>
      'Geen uitnodigingscode gevonden, probeer het later opnieuw!';

  @override
  String get noRecurrence => 'Geen herhaling';

  @override
  String get noResultsPlaceholderAnEmptyList =>
      'Een lege lijst nodigt uit tot nieuwe perspectieven.';

  @override
  String get noResultsPlaceholderConsiderADifferent =>
      'Overweeg een andere aanpak of term.';

  @override
  String get noResultsPlaceholderEmbraceThis =>
      'Omarm deze lege lijst als een moment van rust.';

  @override
  String get noResultsPlaceholderInThisMoment =>
      'Op dit moment zijn er geen resultaten.';

  @override
  String get noResultsPlaceholderMaybeWhatYoureLooking =>
      'Misschien is wat je zoekt verborgen in een ander perspectief.';

  @override
  String get noResultsPlaceholderNoAnswers => 'Hier geen antwoorden.';

  @override
  String get noResultsPlaceholderNoMatches =>
      'Geen overeenkomsten hier. Herformuleer je zoekopdracht.';

  @override
  String get noResultsPlaceholderNoResults => 'Geen resultaten gevonden.';

  @override
  String get noResultsPlaceholderNothingFound => 'Hier niets gevonden.';

  @override
  String get noResultsPlaceholderNothingMatched =>
      'Niets kwam overeen met je zoekopdracht.';

  @override
  String get noResultsPlaceholderPerhapsItsTime =>
      'Misschien is het tijd om een andere vraag te stellen.';

  @override
  String get noResultsPlaceholderPerhapsItsTimeToTake =>
      'Misschien is het tijd om een andere route te nemen.';

  @override
  String get noResultsPlaceholderPerhapsTheAnswer =>
      'Misschien ligt het antwoord ergens anders.';

  @override
  String get noResultsPlaceholderSeekInAnother =>
      'Zoek in een andere richting met scherpere focus.';

  @override
  String get noResultsPlaceholderTheOutcome =>
      'De uitkomst is duidelijk: niets gevonden. Hoe ga je je aanpassen?';

  @override
  String get noResultsPlaceholderTheSearchIsOver =>
      'De zoektocht is voorbij, maar de reis gaat door.';

  @override
  String get noResultsPlaceholderTheSearchReveals =>
      'De zoektocht onthult afwezigheid.';

  @override
  String get noRoomies => 'Geen huisgenoten';

  @override
  String get noTasksAssignedToYou => 'Nog geen taken aan jou toegewezen';

  @override
  String get none => 'Geen';

  @override
  String get notAssignedToAnyone => 'Aan niemand toegewezen.';

  @override
  String get notFound => 'Niet gevonden';

  @override
  String get notSadJustEmpty => 'Niet treurig, gewoon leeg.';

  @override
  String get notSet => 'Niet ingesteld';

  @override
  String get notVerified => 'Niet geverifieerd';

  @override
  String get nov => 'nov';

  @override
  String get november => 'november';

  @override
  String get oct => 'okt';

  @override
  String get october => 'oktober';

  @override
  String get ok => 'Ok';

  @override
  String get onceADay => 'eens per dag';

  @override
  String get onceAMonth => 'eens per maand';

  @override
  String get onceAWeek => 'eens per week';

  @override
  String get onceAYear => 'eens per jaar';

  @override
  String get onetimeTask => 'Op aanvraag';

  @override
  String get oops => 'Oeps';

  @override
  String get oopsSomethingWentWrong => 'Oeps! Er is iets misgegaan.';

  @override
  String get optional => 'Optioneel';

  @override
  String get or => 'of';

  @override
  String get orContinueWith => 'Of ga verder met';

  @override
  String get overdue => 'Te laat';

  @override
  String overdueDays(int count) {
    return '$count dagen te laat';
  }

  @override
  String get overdueOneDay => '1 dag te laat';

  @override
  String get overview => 'Overzicht';

  @override
  String get password => 'Wachtwoord';

  @override
  String get passwordDoesNotMatch => 'Wachtwoord komt niet overeen';

  @override
  String get payments => 'Betalingen';

  @override
  String get pending => 'In behandeling';

  @override
  String get openEmail => 'E-mail openen';

  @override
  String get pendingInvitations => 'Openstaande uitnodigingen';

  @override
  String get peopleWhoWantToJoinYourHousehold =>
      'Mensen die lid willen worden van je huishouden';

  @override
  String get perMonth => 'per maand';

  @override
  String get perWeek => 'per week';

  @override
  String get permissionDenied => 'Toegang geweigerd';

  @override
  String get phone => 'Telefoon';

  @override
  String get phoneHint => 'bijv. +31 6 12345678';

  @override
  String get phoneNumber => 'Telefoonnummer';

  @override
  String get pleaseCheckYourEmailToVerifyYourAccount =>
      'Controleer je e-mail om je account te verifiëren.';

  @override
  String get pleaseComeBackSoon => 'Kom snel terug!';

  @override
  String get pleaseEnterAValidEmailAddress => 'Voer een geldig e-mailadres in';

  @override
  String get pleaseEnterYourEmail => 'Voer je e-mail in.';

  @override
  String get pleaseEnterYourName => 'Voer je naam in';

  @override
  String get pleaseLogInToContinue => 'Log in om door te gaan.';

  @override
  String pleaseLoginToYourAppnameAccount(Object appName) {
    return 'Log in op je $appName account';
  }

  @override
  String get pleaseReadAndAcceptOurPrivacyPolicy =>
      'Lees en accepteer ons privacybeleid';

  @override
  String get pleaseRegisterToContinue => 'Registreer om door te gaan.';

  @override
  String get pleaseVerifyYourEmailAddressToContinue =>
      'Verifieer je e-mailadres om door te gaan.';

  @override
  String get pleaseWait => 'Even geduld';

  @override
  String get postponedEmailVerificationUntilNextTime =>
      'E-mailverificatie uitgesteld tot de volgende keer.';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get privacyPolicyAndTermsOfServiceAccepted =>
      'Privacybeleid en servicevoorwaarden geaccepteerd';

  @override
  String get proceedWithCaution => 'Ga voorzichtig te werk.';

  @override
  String get profileUpdatedSuccessfully => 'Profiel succesvol bijgewerkt';

  @override
  String get quantity => 'Hoeveelheid';

  @override
  String get quantityCannotBeNegative => 'Hoeveelheid moet groter zijn dan nul';

  @override
  String rateLimitMessage(int seconds) {
    return 'Wacht ${seconds}s.';
  }

  @override
  String get readInstructions => 'Lees de instructies';

  @override
  String get recurrence => 'Herhaling';

  @override
  String get repeatTaskAutomatically => 'Taak automatisch herhalen';

  @override
  String get recurrenceInvalid => 'Herhalingsconfiguratie is ongeldig';

  @override
  String get recurrenceMode => 'Herhalingsmodus';

  @override
  String get recurrenceOptionalDescription =>
      'Stel een herhalend schema in voor deze taak';

  @override
  String get recurring => 'Herhalend';

  @override
  String get register => 'Registreren';

  @override
  String get remove => 'Verwijderen';

  @override
  String get removeMember => 'Lid verwijderen';

  @override
  String get removeSubtask => 'Subtaak verwijderen';

  @override
  String get reorderSubtasks => 'Subtaken herschikken';

  @override
  String get requestedToJoin => 'verzocht om lid te worden';

  @override
  String get requestsFromPeopleThatWantToJoinYourHousehold =>
      'Verzoeken van mensen die lid willen worden van je huishouden.';

  @override
  String get requestsThatYouHaveSentToJoinAHousehold =>
      'Verzoeken die je hebt verzonden om lid te worden van een huishouden.';

  @override
  String get required => 'Verplicht';

  @override
  String get resend => 'Opnieuw verzenden';

  @override
  String get resendEmail => 'E-mail opnieuw verzenden';

  @override
  String get resetPassword => 'Wachtwoord resetten';

  @override
  String resetPasswordCooldownMessage(
    Object minuteText,
    Object minutes,
    Object secondText,
    Object seconds,
  ) {
    return 'Je kunt over $minutes $minuteText en $seconds $secondText een nieuwe reset e-mail aanvragen';
  }

  @override
  String resetPasswordCooldownMessageSeconds(
    Object secondText,
    Object seconds,
  ) {
    return 'Je kunt over $seconds $secondText een nieuwe reset e-mail aanvragen';
  }

  @override
  String get roomies => 'Leden';

  @override
  String get theseAreYourRoommates => 'De uitverkorenen.';

  @override
  String get administration => 'Beheer';

  @override
  String get roomy => 'Template';

  @override
  String get roomy123 => 'Wachtwoord123!';

  @override
  String get sat => 'za';

  @override
  String get saturday => 'zaterdag';

  @override
  String get save => 'Opslaan';

  @override
  String get saveImage => 'Afbeelding opslaan';

  @override
  String get scanQrCode => 'QR-code scannen';

  @override
  String get schedule => 'Schema';

  @override
  String get search => 'Zoeken';

  @override
  String get second => 'seconde';

  @override
  String get seconds => 'seconden';

  @override
  String get selectImage => 'Afbeelding selecteren';

  @override
  String get selectPeriod => 'Selecteer periode';

  @override
  String get selectWeekDays => 'Selecteer weekdagen';

  @override
  String get send => 'Verzenden';

  @override
  String get sendEmail => 'E-mail verzenden';

  @override
  String get sep => 'sep';

  @override
  String get september => 'september';

  @override
  String get settings => 'Instellingen';

  @override
  String get shareInviteCodeWithNewMembers => 'Deel deze code met nieuwe leden';

  @override
  String get shareThisCodeWithNewMembers => 'Deel deze code met nieuwe leden';

  @override
  String get sharedShoppingLists => 'Gedeelde boodschappenlijsten';

  @override
  String get shopping => 'Boodschappen';

  @override
  String get shoppingList => 'Boodschappenlijst';

  @override
  String get shoppingListCreated => 'Boodschappenlijst aangemaakt';

  @override
  String get shoppingListDeleted => 'Boodschappenlijst verwijderd';

  @override
  String get shoppingListDescriptionCannotExceed200Characters =>
      'Boodschappenlijst beschrijving mag niet meer dan 200 tekens bevatten';

  @override
  String get shoppingListNameMustBeAtLeast3CharactersLong =>
      'Boodschappenlijst naam moet minimaal 3 tekens lang zijn';

  @override
  String get shoppingListNameMustBeAtMost50CharactersLong =>
      'Boodschappenlijst naam mag maximaal 50 tekens lang zijn';

  @override
  String get shoppingListNotFound => 'Boodschappenlijst niet gevonden';

  @override
  String get shoppingListUpdated => 'Boodschappenlijst bijgewerkt';

  @override
  String get shoppingLists => 'Boodschappenlijsten';

  @override
  String get shoppingOverview => 'Laten we gaan winkelen!';

  @override
  String get shoppingOverviewDescription =>
      'Maak en beheer gedeelde boodschappenlijsten met je huisgenoten. Voeg items toe, vink ze samen af en zorg dat iedereen weet wat er gekocht moet worden.';

  @override
  String get showInviteCode => 'Uitnodigingscode tonen';

  @override
  String get signIn => 'Inloggen';

  @override
  String get signUp => 'Registreren';

  @override
  String get size => 'Grootte';

  @override
  String get skip => 'Overslaan';

  @override
  String get skipped => 'Overgeslagen';

  @override
  String get somethingWentWrong => 'Er is iets misgegaan';

  @override
  String get somethingWentWrongPleaseTryAgainLater =>
      'Er is iets misgegaan, probeer het later opnieuw.';

  @override
  String get somethingWentWrongWhileDeletingOldUsernamesPleaseTryAgain =>
      'Er is iets misgegaan bij het verwijderen van oude gebruikersnamen, probeer het opnieuw.';

  @override
  String get somethingWentWrongWhileSavingTheImagePleaseTryAgain =>
      'Er is iets misgegaan bij het opslaan van de afbeelding. Probeer het opnieuw. Neem contact op met support als het probleem aanhoudt.';

  @override
  String get somethingWentWrongWhileSortingTheItemsOurApologies =>
      'Er is iets misgegaan bij het sorteren van de items, onze excuses.';

  @override
  String get somethingWentWrongWhileTryingToCreateYourProfilePlease =>
      'Er is iets misgegaan bij het aanmaken van je profiel, probeer het opnieuw.';

  @override
  String get somethingWentWrongWhileTryingToLoadYourHouseholdPlease =>
      'Er is iets misgegaan bij het laden van je huishouden, herstart de app en probeer het opnieuw.';

  @override
  String get statistics => 'Statistieken';

  @override
  String get stranger => 'vreemdeling';

  @override
  String get submittingFeedback => 'Feedback verzenden...';

  @override
  String get subtaskAdded => 'Subtaak toegevoegd';

  @override
  String get subtaskCompleted => 'Subtaak voltooid';

  @override
  String get subtaskDeleted => 'Subtaak verwijderd';

  @override
  String get subtaskNameMaxLength =>
      'Subtaaknaam mag niet meer dan 100 tekens bevatten';

  @override
  String get subtaskNameRequired => 'Subtaaknaam is verplicht';

  @override
  String get subtaskReordered => 'Subtaak herschikt';

  @override
  String get subtaskUncompleted => 'Subtaak ongedaan gemaakt';

  @override
  String get subtaskUpdated => 'Subtaak bijgewerkt';

  @override
  String get subtasks => 'Subtaken';

  @override
  String get breakTaskIntoSmallerSteps => 'Verdeel taak in kleinere stappen';

  @override
  String get success => 'Succes';

  @override
  String get sun => 'zo';

  @override
  String get sunday => 'zondag';

  @override
  String get takePhoto => 'Foto maken';

  @override
  String get tapToAdd => 'Tik om toe te voegen';

  @override
  String get tapToAddItem => 'Tik om item toe te voegen';

  @override
  String get tapToViewAndManageTheCleaningSchedule =>
      'Tik om het schoonmaakschema te bekijken en beheren.';

  @override
  String get taskAssignedSuccessfully => 'Taak succesvol toegewezen';

  @override
  String get taskClaimedSuccessfully => 'Taak succesvol geclaimd';

  @override
  String get taskCompleted => 'Taak voltooid';

  @override
  String get taskDeleted => 'Taak verwijderd';

  @override
  String get taskDetails => 'Taakdetails';

  @override
  String get taskManagement => 'Taakbeheer';

  @override
  String get taskUnassignedSuccessfully => 'Taak succesvol losgekoppeld';

  @override
  String get taskUncompleted => 'Taak ongedaan gemaakt';

  @override
  String get tasks => 'Taken';

  @override
  String get tasksAssignedToYouAndRecentlyCompleted =>
      'Taken toegewezen aan jou.';

  @override
  String get tellUsAboutYourself => 'Vertel ons over jezelf..';

  @override
  String get termsOfService => 'Servicevoorwaarden';

  @override
  String get thankYou => 'Dank je!';

  @override
  String get thankYouAndWelcomeToRoomy => 'Bedankt en welkom.';

  @override
  String get thankYouForSharingYourInsightsWithUsWeTruly =>
      'Bedankt voor het delen van je inzichten. We waarderen je feedback enorm en zullen deze gebruiken om de app nog beter te maken. We waarderen je steun!';

  @override
  String get thankYouForYourFeedback => 'Bedankt voor je feedback!';

  @override
  String get theShoppingListHasGoneMissingReturningYouHomeLet =>
      'De boodschappenlijst is verdwenen! Je wordt teruggebracht naar home.. laat ons weten als dit een fout is.';

  @override
  String get thisFieldIsRequired => 'Dit veld is verplicht';

  @override
  String get thisIsCurrentlyUnderDevelopmentAndWillBeAvailableSoon =>
      'Dit is momenteel in ontwikkeling en zal binnenkort beschikbaar zijn.';

  @override
  String get thisWeek => 'Deze week';

  @override
  String get thu => 'do';

  @override
  String get thursday => 'donderdag';

  @override
  String get timeSpan => 'Tijdspanne';

  @override
  String get times => 'keer';

  @override
  String timesADay(int count) {
    return '$count keer per dag';
  }

  @override
  String timesAMonth(int count) {
    return '$count keer per maand';
  }

  @override
  String timesAWeek(int count) {
    return '$count keer per week';
  }

  @override
  String timesAYear(int count) {
    return '$count keer per jaar';
  }

  @override
  String get timesPerMonth => 'keer per maand';

  @override
  String get timesPerWeek => 'keer per week';

  @override
  String get titleMustBeAtLeast1CharacterLong =>
      'Titel moet minimaal 1 teken lang zijn.';

  @override
  String get toDo => 'Te doen';

  @override
  String get today => 'vandaag';

  @override
  String get tryAgain => 'Probeer opnieuw';

  @override
  String get tue => 'di';

  @override
  String get tuesday => 'dinsdag';

  @override
  String get unableToAcceptPleaseTryAgainLater =>
      'Accepteren niet mogelijk, probeer het later opnieuw.';

  @override
  String get unableToLogYouOut => 'Kan je niet uitloggen';

  @override
  String get unableToLogYouOutPleaseTryAgainLater =>
      'Kan je niet uitloggen, probeer het later opnieuw.';

  @override
  String get unassign => 'Loskoppelen';

  @override
  String get unassignTask => 'Taak loskoppelen';

  @override
  String get unassigned => 'Niet toegewezen';

  @override
  String get unavailable => 'Niet beschikbaar';

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get undoAllItems => 'Alle items ongedaan maken';

  @override
  String get unknown => 'Onbekend';

  @override
  String get unknownError => 'Onbekende fout';

  @override
  String get unknownProfileWeWereUnableToFetchTheProfile =>
      'Onbekend profiel. We konden het profiel niet ophalen.';

  @override
  String get unnamedTask => 'Naamloze taak';

  @override
  String get updateTimeSlots => 'Tijdsloten bijwerken';

  @override
  String get useAnInviteCodeToJoinAnExistingHousehold =>
      'Gebruik een uitnodigingscode om lid te worden van een bestaand huishouden.';

  @override
  String get userIdNotFound => 'Gebruikers-ID niet gevonden';

  @override
  String get userIsAlreadyAMember => 'Gebruiker is al lid';

  @override
  String userIsAlreadyAMemberMessage(String username) {
    return '$username is al lid van dit huishouden. Wil je iemand anders toevoegen?';
  }

  @override
  String get userIsAlreadyInvited => 'Gebruiker is al uitgenodigd';

  @override
  String userIsAlreadyInvitedMessage(String username) {
    return '$username is al uitgenodigd voor dit huishouden. Wil je iemand anders uitnodigen?';
  }

  @override
  String get userNotFound => 'Gebruiker niet gevonden';

  @override
  String userNotFoundForUsername(String username) {
    return 'We konden geen gebruiker vinden met de gebruikersnaam $username. Controleer de gebruikersnaam en probeer opnieuw.';
  }

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get usernameCopied => 'Gebruikersnaam gekopieerd';

  @override
  String get usernameFieldHint => '@gebruikersnaam';

  @override
  String get usernameFieldLabel => 'Gebruikersnaam';

  @override
  String get usernameInvalid => 'Ongeldige gebruikersnaam';

  @override
  String get usernameInvalidFormat =>
      'Gebruikersnaam mag alleen alfanumerieke tekens, underscores en punten bevatten.';

  @override
  String get usernameIsAlreadyInUsePleaseChooseADifferentOne =>
      'Gebruikersnaam is al in gebruik, kies een andere.';

  @override
  String get usernameIsAlreadyTaken => 'Gebruikersnaam is al bezet.';

  @override
  String get usernameMaxLength =>
      'Gebruikersnaam mag maximaal 30 tekens lang zijn.';

  @override
  String get usernameMinLength =>
      'Gebruikersnaam moet minimaal 3 tekens lang zijn.';

  @override
  String get usernameRequired => 'Dit veld is verplicht';

  @override
  String usernamesHousehold(Object username) {
    return '$username\'s huishouden';
  }

  @override
  String get verificationEmailHasBeenResent =>
      'Verificatie e-mail is opnieuw verzonden.';

  @override
  String get verificationEmailSent => 'Verificatie e-mail verzonden';

  @override
  String verificationEmailSentCheckingAgainInSeconds(Object seconds) {
    return 'Verificatie e-mail verzonden,\nover $seconds seconden opnieuw controleren';
  }

  @override
  String get verifyEmail => 'E-mail verifiëren';

  @override
  String get verifyYourEmail => 'Verifieer je e-mail';

  @override
  String get view => 'Bekijken';

  @override
  String get viewAllTasks => 'Alle taken bekijken';

  @override
  String get viewCaps => 'BEKIJKEN';

  @override
  String get waitingForApproval => 'Wachtend op goedkeuring';

  @override
  String get waitingForInviteCode => 'Wachten op uitnodigingscode...';

  @override
  String get weEncounteredAnUnexpectedErrorPleaseTryAgainOrContact =>
      'We zijn een onverwachte fout tegengekomen. Probeer het opnieuw of neem contact op met support als het probleem aanhoudt.';

  @override
  String get weHaveResentTheVerificationEmailPleaseCheckYourInbox =>
      'We hebben de verificatie e-mail opnieuw verzonden. Controleer je inbox en probeer opnieuw.';

  @override
  String get weNoticedYouHaveNotVerifiedYourEmailAddressYet =>
      'We merkten op dat je je e-mailadres nog niet hebt geverifieerd, controleer je inbox en volg de instructies om je e-mailadres te verifiëren.';

  @override
  String get weTakeYourPrivacynverySerious =>
      'We nemen je privacy\nzeer serieus';

  @override
  String get weWereUnableToCheckTheTimeSlotPleaseReload =>
      'We konden het tijdslot niet controleren. Herlaad de app en probeer opnieuw.';

  @override
  String get wed => 'wo';

  @override
  String get wednesday => 'woensdag';

  @override
  String get week => 'week';

  @override
  String get weekDaysRequired =>
      'Minimaal één weekdag moet worden geselecteerd voor wekelijkse frequentie';

  @override
  String get weeks => 'weken';

  @override
  String weeksAgo(Object inWeeks) {
    return '$inWeeks weken geleden';
  }

  @override
  String get welcome => 'Welkom 🎉';

  @override
  String get welcomeBack => 'Welkom terug';

  @override
  String get welcomeSubtitle =>
      'We zijn enthousiast om je te helpen je huishouden te organiseren! Via de onderstaande knop kun je lezen hoe je eenvoudig feedback kunt versturen.';

  @override
  String get welcomeToShoppingLists => 'Welkom bij Boodschappenlijsten 🛒';

  @override
  String get welcomeToShoppingListsSubtitle =>
      'Maak gedeelde boodschappenlijsten met je huishoudenleden. Voeg items toe, markeer ze als voltooid en houd iedereen georganiseerd!';

  @override
  String get whatNameSuitsYouBest => 'Welke naam past het beste bij je?';

  @override
  String get whatsNew => 'Wat is nieuw?';

  @override
  String get wouldYouLikeToResendTheVerificationEmail =>
      'Wil je de verificatie e-mail opnieuw verzenden?';

  @override
  String get yes => 'Ja';

  @override
  String get youCanOnlySkipEmailVerificationOnce =>
      'Je kunt e-mailverificatie maar één keer overslaan. Verifieer je e-mail om door te gaan.';

  @override
  String get youCannotDeleteTheMainShoppingList =>
      'Je kunt de hoofd boodschappenlijst niet verwijderen';

  @override
  String get youHaveBeenInvited => 'Je bent uitgenodigd!';

  @override
  String youHaveBeenInvitedToJoinName(Object name) {
    return 'Je bent uitgenodigd om lid te worden van $name!';
  }

  @override
  String get youHaveLeftTheHousehold => 'Je hebt het huishouden verlaten';

  @override
  String get youWillNoLongerHaveAccessToThisHouseholdYou =>
      'Je bent automatisch weer lid geworden van je oude huishouden als je er een had.';

  @override
  String get yourCurrentHousehold => 'je huidige huishouden';

  @override
  String get yourPasswordMustBeAtLeast8CharactersLong =>
      'Je wachtwoord moet minimaal 8 tekens lang zijn.';

  @override
  String get yourRequestToJoinTheHouseholdHasBeenSent =>
      'Je verzoek om lid te worden van het huishouden is verzonden. Een beheerder zal het binnenkort beoordelen.';

  @override
  String get welcomeToRoomy => 'Welkom!';

  @override
  String get welcomeHome => 'Welkom thuis';

  @override
  String get chooseAnOptionToGetStarted => 'Kies een optie om te beginnen';

  @override
  String get createHousehold => 'Huishouden aanmaken';

  @override
  String get startAFreshHouseholdForYouAndYourRoomies =>
      'Start een nieuw huishouden voor jou en je huisgenoten';

  @override
  String get useInviteCode => 'Uitnodigingscode gebruiken';

  @override
  String get useYourInviteCodeToJoinAnExistingHousehold =>
      'Gebruik je uitnodigingscode om lid te worden van een bestaand huishouden';

  @override
  String get joinHouseholdScan => 'Scannen om te joinen';

  @override
  String get scanAQrCodeToJoinAnExistingHousehold =>
      'Scan een QR-code om lid te worden van een bestaand huishouden';

  @override
  String get selectCaps => 'SELECTEREN';

  @override
  String get scanToJoin => 'Scan om te joinen';

  @override
  String get noPaymentsYet => 'Nog geen betalingen!';

  @override
  String get createYourFirstPaymentToGetStarted =>
      'Maak je eerste betaling aan om te beginnen.';

  @override
  String get history => 'Geschiedenis';

  @override
  String get amount => 'Bedrag';

  @override
  String get amountPlaceholder => '0,-';

  @override
  String get paymentSavedSuccessfully => 'Betaling succesvol opgeslagen';

  @override
  String get subject => 'Onderwerp';

  @override
  String get subjectHint => 'bijv. Boodschappen, Nutsvoorzieningen, etc.';

  @override
  String get deletePayment => 'Betaling verwijderen';

  @override
  String get deletePaymentConfirmation =>
      'Weet je zeker dat je deze betaling wilt verwijderen? Dit kan niet ongedaan worden gemaakt.';

  @override
  String get paymentDeletedSuccessfully => 'Betaling succesvol verwijderd';

  @override
  String get allPayments => 'Alle betalingen';

  @override
  String get paymentGeneral => 'Algemeen';

  @override
  String get paymentGeneralDescription =>
      'Betalingsonderwerp en algemene details.';

  @override
  String get paymentSection => 'Betaling';

  @override
  String get paymentSectionDescription =>
      'Betalingsbedrag en financiële details.';

  @override
  String get receipt => 'Bon';

  @override
  String get receiptDescription =>
      'Voeg een bonafbeelding toe voor documentatie.';

  @override
  String get deleteReceipt => 'Bon verwijderen';

  @override
  String get deleteReceiptConfirmation =>
      'Weet je zeker dat je deze bon wilt verwijderen?';

  @override
  String get addReceipt => 'Bon toevoegen';

  @override
  String get receiptDeleted => 'Bon verwijderd';

  @override
  String get receiptUploaded => 'Bon geüpload';

  @override
  String get saveToGallery => 'Opslaan in galerij';

  @override
  String get imageSavedToGallery => 'Afbeelding opgeslagen in galerij';

  @override
  String get failedToDownloadImage => 'Afbeelding downloaden mislukt';

  @override
  String get seeAll => 'Alles bekijken';

  @override
  String get me => 'Ik';

  @override
  String get paymentsOverview => 'Betalingsoverzicht';

  @override
  String get paymentsOverviewDescription =>
      'Je betaalt wat, je bent wat schuldig.';

  @override
  String get paymentPeriodDay => 'Dag';

  @override
  String get paymentPeriodWeek => 'Week';

  @override
  String get paymentPeriodMonth => 'Maand';

  @override
  String get paymentPeriodYear => 'Jaar';

  @override
  String get paymentPeriodAllTime => 'Alles';

  @override
  String get yourExpenses => 'Mijn uitgaven';

  @override
  String get paymentCount => 'Betalingen';

  @override
  String get paymentTotal => 'Totaal';

  @override
  String get noPaymentsInPeriod => 'Geen betalingen in deze periode';

  @override
  String get unableToEdit => 'Bewerken niet mogelijk';

  @override
  String get cannotEditPaymentsCreatedByOtherUsers =>
      'Je kunt betalingen die door andere gebruikers zijn aangemaakt niet bewerken';

  @override
  String get viewOnlyMode =>
      'Alleen bekijken - Deze betaling is aangemaakt door een andere gebruiker';

  @override
  String get download => 'Downloaden';

  @override
  String get close => 'Sluiten';

  @override
  String get paid => 'ontvangt';

  @override
  String get owes => 'is schuldig';

  @override
  String get youPaid => 'Jij betaalde';

  @override
  String get youOwe => 'Jij bent schuldig';

  @override
  String get viewPayments => 'Betalingen bekijken';

  @override
  String get chartDescriptionSparklineNet =>
      'Je netto balans over tijd. Positieve waarden betekenen dat anderen jou geld schuldig zijn, negatief betekent dat jij anderen geld schuldig bent.';

  @override
  String get chartDescriptionPayerSharePie =>
      'Wie betaalde voor uitgaven in deze periode. Toont de procentuele verdeling per betaler.';

  @override
  String get chartDescriptionRoommateNetBars =>
      'Balans voor elke huisgenoot. Groene balken tonen wat ze tegoed hebben, rode balken wat ze schuldig zijn.';

  @override
  String get chartDescriptionHouseholdOverTime =>
      'Totale huishouduitgaven per tijdsperiode. Toont uitgavetrends over de geselecteerde periode.';

  @override
  String get participantValidationAtLeastOne =>
      'Minimaal één deelnemer moet worden geselecteerd.';

  @override
  String get participantValidationSplitMustMatch =>
      'Verdeeltotaal moet overeenkomen met betalingsbedrag.';

  @override
  String get participantValidationSplitCannotExceed =>
      'Verdeeltotaal mag betalingsbedrag niet overschrijden.';

  @override
  String get participantValidationShareGreaterThanZero =>
      'Elke deelnemer moet een aandeel groter dan 0 hebben.';

  @override
  String get participantValidationPercentagesMustTotal =>
      'Verdeelpercentages moeten optellen tot 100%.';

  @override
  String get participantValidationPercentagesCannotExceed =>
      'Percentagetotaal mag 100% niet overschrijden.';

  @override
  String get noDataAvailable => 'Geen gegevens beschikbaar';

  @override
  String get noDataAvailableForTimeframe =>
      'Nog geen gegevens beschikbaar voor dit tijdsbestek.';

  @override
  String get participantValidationNoSplitWithoutParticipants =>
      'Kan geen verdeelmethode hebben zonder deelnemers';

  @override
  String get participantValidationCreatorMustParticipate =>
      'Betalingsmaker moet deelnemer zijn';

  @override
  String get participantValidationManualMustSumToTotal =>
      'Handmatige bedragen moeten optellen tot totaal';

  @override
  String get participantValidationPercentagesMustSumTo100 =>
      'Percentages moeten optellen tot 100%';

  @override
  String get chooseHouseholdMemberToAssignTask =>
      'Kies een huishoudenlid om deze taak aan toe te wijzen.';

  @override
  String get paymentParticipants => 'Deelnemers';

  @override
  String get paymentSplitMethod => 'Verdeelmethode';

  @override
  String get paymentSplit => 'Verdeling';

  @override
  String get payment => 'Betaling';

  @override
  String get whoSharesThisExpense => 'Wie deelt deze uitgave?';

  @override
  String get howToSplitPayment => 'Hoe de betaling te verdelen';

  @override
  String get setAmountForSplitMethod =>
      'Stel bedrag in voor de verdeelmethode.';

  @override
  String get reset => 'Resetten';

  @override
  String get emergencyContact => 'Noodcontact';

  @override
  String get created => 'Aangemaakt';

  @override
  String get updated => 'Bijgewerkt';

  @override
  String get validationError => 'Validatiefout';

  @override
  String get setTotalAmountDescription => 'Stel het totaalbedrag in';

  @override
  String get youCreator => 'Jij';

  @override
  String get you => 'jij';

  @override
  String get profile => 'Profiel';

  @override
  String get userProfileInformation => 'Gebruikersprofielinformatie';

  @override
  String get noItems => 'Geen items';

  @override
  String get shoppedAndLoaded => 'Gewinkeld en geladen.';

  @override
  String get allTasksCompleted => 'Alle taken voltooid';

  @override
  String get showThisToYourRoomy => 'Deel dit met een lid.';

  @override
  String get invalidCredentialsMessage =>
      'De opgegeven inloggegevens zijn ongeldig, probeer het opnieuw.';

  @override
  String get invalidCredentialsTitle => 'Ongeldige inloggegevens';

  @override
  String get networkErrorTitle => 'Netwerkfout';

  @override
  String get accountAlreadyInUseMessage =>
      'Het account is al in gebruik, probeer het opnieuw.';

  @override
  String get accountAlreadyInUseTitle => 'Account al in gebruik';

  @override
  String get invalidCredentialMessage =>
      'Er is iets misgegaan bij het verifiëren van de inloggegevens, probeer het opnieuw.';

  @override
  String get invalidCredentialTitle => 'Ongeldige inloggegevens';

  @override
  String get operationNotAllowedTitle => 'Bewerking niet toegestaan';

  @override
  String get accountDisabledMessage =>
      'Het account dat bij de inloggegevens hoort is uitgeschakeld, probeer het opnieuw.';

  @override
  String get accountDisabledTitle => 'Account uitgeschakeld';

  @override
  String get accountNotFoundMessage =>
      'Het account dat bij de inloggegevens hoort is niet gevonden, probeer het opnieuw.';

  @override
  String get accountNotFoundTitle => 'Account niet gevonden';

  @override
  String get wrongPasswordMessage =>
      'Het wachtwoord is ongeldig, probeer het opnieuw.';

  @override
  String get wrongPasswordTitle => 'Verkeerd wachtwoord';

  @override
  String get invalidVerificationCodeMessage =>
      'De verificatiecode van de inloggegevens is ongeldig, probeer het opnieuw.';

  @override
  String get invalidVerificationCodeTitle => 'Ongeldige verificatiecode';

  @override
  String get invalidVerificationIdMessage =>
      'De verificatie-ID van de inloggegevens is ongeldig, probeer het opnieuw.';

  @override
  String get invalidVerificationIdTitle => 'Ongeldige verificatie-ID';

  @override
  String get invalidEmailMessage =>
      'Het opgegeven e-mailadres is ongeldig, probeer het opnieuw.';

  @override
  String get invalidEmailTitle => 'Ongeldig e-mailadres';

  @override
  String get emailAlreadyInUseMessage =>
      'Het gebruikte e-mailadres bestaat al, gebruik een ander e-mailadres of probeer in te loggen.';

  @override
  String get emailAlreadyInUseTitle => 'E-mail al in gebruik';

  @override
  String get weakPasswordMessage =>
      'Het opgegeven wachtwoord is te zwak, probeer het opnieuw.';

  @override
  String get weakPasswordTitle => 'Zwak wachtwoord';

  @override
  String get invalidPhoneNumberMessage =>
      'Het telefoonnummer heeft een ongeldig formaat. Voer een geldig telefoonnummer in.';

  @override
  String get invalidPhoneNumberTitle => 'Ongeldig telefoonnummer';

  @override
  String get captchaCheckFailedTitle => 'Captcha controle mislukt';

  @override
  String get quotaExceededTitle => 'Quotum overschreden';

  @override
  String get providerAlreadyLinkedTitle => 'Provider al gekoppeld';

  @override
  String get credentialAlreadyInUseTitle => 'Inloggegevens al in gebruik';

  @override
  String get unknownErrorMessage =>
      'Er is een onbekende fout opgetreden, probeer het opnieuw.';

  @override
  String get unknownErrorTitle => 'Onbekende fout';

  @override
  String get accountDeletedMessage => 'Je account is succesvol verwijderd.';

  @override
  String get accountDeletedTitle => 'Account verwijderd';

  @override
  String get failedToDeleteAccountMessage =>
      'Er is een onbekende fout opgetreden bij het verwijderen van je account.';

  @override
  String get failedToDeleteAccountTitle => 'Account verwijderen mislukt';

  @override
  String get accountLinkedMessage => 'Je account is succesvol gekoppeld.';

  @override
  String get accountLinkedTitle => 'Account gekoppeld';

  @override
  String get logoutSuccessfulMessage => 'Je bent niet langer ingelogd.';

  @override
  String get logoutSuccessfulTitle => 'Uitloggen gelukt';

  @override
  String get loginFailedTitle => 'Inloggen mislukt';

  @override
  String get accountCreatedTitle => 'Account aangemaakt';

  @override
  String get registerFailedTitle => 'Registratie mislukt';

  @override
  String get logoutFailedTitle => 'Uitloggen mislukt';

  @override
  String get verifyEmailSentMessage =>
      'Controleer je e-mail om je account te verifiëren.';

  @override
  String get verifyEmailSentTitle => 'Verificatie e-mail verzonden';

  @override
  String get emailNotVerifiedMessage =>
      'Je e-mail kon op dit moment niet worden geverifieerd. Probeer het later opnieuw.';

  @override
  String get emailNotVerifiedTitle => 'E-mail niet geverifieerd';

  @override
  String get emailVerifiedTitle => 'E-mail geverifieerd';

  @override
  String get welcomeBackTitle => 'Welkom terug!';

  @override
  String get failedToLogInTitle => 'Inloggen mislukt';

  @override
  String get accountCreationFailedTitle => 'Account aanmaken mislukt';

  @override
  String get userIdIsNull => 'Gebruikers-ID is null';

  @override
  String get taskNotFoundMessage =>
      'Kan de taak niet vinden om subtaak bij te werken';

  @override
  String get taskNotFoundTitle => 'Taak niet gevonden';

  @override
  String get failedToUpdateSubtaskMessage =>
      'Subtaak bijwerken mislukt. Probeer het opnieuw.';

  @override
  String get conversionFailedMessage => 'Screenshot converteren mislukt';

  @override
  String get conversionFailedTitle => 'Conversie mislukt';

  @override
  String get unexpectedErrorMessage => 'Er is een onverwachte fout opgetreden';

  @override
  String get errorTitle => 'Fout';

  @override
  String get failedToDeleteItemMessage =>
      'Er is een fout opgetreden bij het verwijderen van het item. Probeer het opnieuw.';

  @override
  String get failedToDeleteItemTitle => 'Item verwijderen mislukt';

  @override
  String get subtaskNameRequiredValidation => 'Subtaaknaam is verplicht';

  @override
  String get subtaskNameInvalidCharactersValidation =>
      'Subtaaknaam bevat ongeldige tekens';

  @override
  String get subtaskNameMaxLengthValidation =>
      'Subtaaknaam mag niet meer dan 100 tekens bevatten';

  @override
  String get descriptionMaxLengthValidation =>
      'Beschrijving mag niet meer dan 500 tekens bevatten';

  @override
  String get descriptionInvalidCharactersValidation =>
      'Beschrijving bevat ongeldige tekens';

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
  String get contactTypeEmail => 'E-mail';

  @override
  String get contactTypePhoneNumber => 'Telefoonnummer';

  @override
  String get contactTypeLink => 'Link';

  @override
  String get contactTypeUnknown => 'Onbekend';

  @override
  String get welcomeToRoomyDescription => 'Welkom in de app';

  @override
  String get emailInputFieldLabel => 'E-mail invoerveld';

  @override
  String get passwordInputFieldLabel => 'Wachtwoord invoerveld';

  @override
  String get loginButtonLabel => 'Inloggen knop';

  @override
  String get registerButtonLabel => 'Registreren knop';

  @override
  String get switchToLoginLabel => 'Wisselen naar inloggen';

  @override
  String get loggedInTitle => 'Ingelogd';

  @override
  String get logoutButtonLabel => 'Uitloggen knop';

  @override
  String get acceptInviteLabel => 'Uitnodiging accepteren';

  @override
  String get declineInviteLabel => 'Uitnodiging weigeren';

  @override
  String get cancelInviteLabel => 'Uitnodiging annuleren';

  @override
  String get homeScreenLabel => 'Homescherm';

  @override
  String get settingsButtonLabel => 'Instellingen knop';

  @override
  String get invitesEmoji => '📨  ';

  @override
  String get requestsEmoji => '🤝  ';

  @override
  String get cancelInviteLabelAction => 'Uitnodiging annuleren';

  @override
  String get acceptRequestLabel => 'Verzoek accepteren';

  @override
  String get sentInvitesEmoji => '📤  ';

  @override
  String get myInvitesEmoji => '📨  ';

  @override
  String get declineInviteLabelAction => 'Uitnodiging weigeren';

  @override
  String get shoppingItemDescription => 'Boodschappen item';

  @override
  String get memberStatisticsDescription => 'Ledenstatistieken';

  @override
  String get itemImageDescription => 'Item afbeelding';

  @override
  String get colorLabelWhite => 'Wit';

  @override
  String get colorLabelRed => 'Rood';

  @override
  String get colorLabelGreen => 'Groen';

  @override
  String get colorLabelBlue => 'Blauw';

  @override
  String get colorLabelYellow => 'Geel';

  @override
  String get colorLabelPurple => 'Paars';

  @override
  String get colorLabelOrange => 'Oranje';

  @override
  String get colorLabelPink => 'Roze';

  @override
  String get colorLabelCyan => 'Cyaan';

  @override
  String get colorLabelTeal => 'Blauwgroen';

  @override
  String get userProfileCardDescription => 'Gebruikersprofiel kaart';

  @override
  String get errorAlreadyMember => 'Je bent al lid van dit huishouden';

  @override
  String get errorInvalidInviteCode =>
      'De uitnodigingscode is ongeldig. Controleer en probeer opnieuw.';

  @override
  String get errorHouseholdFull =>
      'Dit huishouden heeft het maximale aantal leden bereikt';

  @override
  String get errorPendingInvite =>
      'Je hebt al een openstaande uitnodiging voor dit huishouden';

  @override
  String get errorRateLimited => 'Te veel pogingen. Probeer het later opnieuw.';

  @override
  String get errorUserNotFound =>
      'Gebruikersprofiel niet gevonden. Voltooi je profiel setup.';

  @override
  String get errorInvalidCodeFormat =>
      'Ongeldig uitnodigingscode formaat. De code moet 4 letters/cijfers zijn.';

  @override
  String get errorUnauthenticated => 'Log in om door te gaan';

  @override
  String get errorNotFound => 'Het gevraagde item is niet gevonden';

  @override
  String get errorPermissionDenied =>
      'Je hebt geen toestemming om deze actie uit te voeren';

  @override
  String get unableToCompleteRequest => 'Kan verzoek niet voltooien';

  @override
  String get notifications => 'Meldingen';

  @override
  String get notificationSettings => 'Meldingsinstellingen';

  @override
  String get notificationSettingsDescription =>
      'Bepaal welke meldingen je ontvangt.';

  @override
  String get enableNotifications => 'Meldingen inschakelen';

  @override
  String get enableNotificationsDescription =>
      'Ontvang pushmeldingen voor updates.';

  @override
  String get shoppingNotifications => 'Boodschappenmeldingen';

  @override
  String get shoppingNotificationsDescription =>
      'Ontvang meldingen over boodschappenlijst updates.';

  @override
  String get cleaningNotifications => 'Schoonmaakmeldingen';

  @override
  String get cleaningNotificationsDescription =>
      'Ontvang meldingen over schoonmaaktaak updates.';

  @override
  String get notificationsEnabled => 'Meldingen ingeschakeld';

  @override
  String get notificationsDisabled => 'Meldingen uitgeschakeld';

  @override
  String get shoppingNotificationsEnabled =>
      'Boodschappenmeldingen ingeschakeld';

  @override
  String get shoppingNotificationsDisabled =>
      'Boodschappenmeldingen uitgeschakeld';

  @override
  String get cleaningNotificationsEnabled => 'Schoonmaakmeldingen ingeschakeld';

  @override
  String get cleaningNotificationsDisabled =>
      'Schoonmaakmeldingen uitgeschakeld';

  @override
  String get markAllAsRead => 'Alles als gelezen markeren';

  @override
  String get addedToShoppingList => 'Toegevoegd aan boodschappenlijst';

  @override
  String get completedShoppingItems => 'Boodschappen items voltooid';

  @override
  String get notificationMarkedAsRead => 'Als gelezen gemarkeerd';

  @override
  String get justNow => 'Zojuist';

  @override
  String minutesAgo(int count) {
    return '$count minuten geleden';
  }

  @override
  String hoursAgo(int count) {
    return '$count uur geleden';
  }

  @override
  String daysAgo(int count) {
    return '$count dagen geleden';
  }

  @override
  String get yesterday => 'Gisteren';

  @override
  String get notificationConsentBannerText =>
      'Schakel meldingen in om te weten wanneer je huisgenoten gaan winkelen';

  @override
  String get notificationConsentSheetTitle => 'Blijf op de hoogte';

  @override
  String get notificationConsentSheetBody =>
      'Ontvang meldingen wanneer je huisgenoten items aan boodschappenlijsten toevoegen of taken voltooien. Mis nooit een update van je huishouden.';

  @override
  String get notificationConsentCancelButton => 'Nu niet';

  @override
  String get notificationConsentAcceptButton => 'Meldingen inschakelen';

  @override
  String get notificationPermissionGrantedToast =>
      'Meldingen ingeschakeld! Je ontvangt nu updates van je huishouden.';

  @override
  String get notificationPermissionDeniedToast =>
      'Meldingen uitgeschakeld. Je kunt ze later inschakelen in Instellingen.';

  @override
  String get notificationPermissionDeniedInfo =>
      'Meldingstoestemming is uitgeschakeld. Schakel het in via je apparaatinstellingen om updates te ontvangen.';

  @override
  String get openSettings => 'Open instellingen';

  @override
  String get appName => 'Turbo Template';

  @override
  String welcomeToApp(String appName) {
    return 'Welkom bij $appName';
  }
}

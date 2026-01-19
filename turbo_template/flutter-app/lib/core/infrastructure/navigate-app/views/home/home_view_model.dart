import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:informers/informers.dart';
import 'package:loglytics/loglytics.dart';
import 'package:roomy_mobile/auth/dtos/user_profile_dto.dart';
import 'package:roomy_mobile/auth/services/user_profiles_service.dart';
import 'package:roomy_mobile/badges/services/badge_service.dart';
import 'package:roomy_mobile/cleaning/dtos/cleaning_task_dto.dart';
import 'package:roomy_mobile/cleaning/dtos/cleaning_time_slot_dto.dart';
import 'package:roomy_mobile/cleaning/models/my_cleaning_tasks.dart';
import 'package:roomy_mobile/cleaning/routing/cleaning_router.dart';
import 'package:roomy_mobile/cleaning/services/cleaning_tasks_service.dart';
import 'package:roomy_mobile/core/dtos/icon_label_dto.dart';
import 'package:roomy_mobile/core/enums/icon_collection.dart';
import 'package:turbo_flutter_template/core/ui/show-animations/constants/t_durations.dart';
import 'package:roomy_mobile/data/extensions/duration_extension.dart';
import 'package:roomy_mobile/data/globals/g_user_id.dart';
import 'package:roomy_mobile/feedback/globals/g_feedback.dart';
import 'package:roomy_mobile/feedback/services/dialog_service.dart';
import 'package:roomy_mobile/feedback/services/sheet_service.dart';
import 'package:roomy_mobile/feedback/services/toast_service.dart';
import 'package:roomy_mobile/forms/config/t_form_field_config.dart';
import 'package:roomy_mobile/households/dtos/household_dto.dart';
import 'package:roomy_mobile/households/enums/home_view_item_type.dart';
import 'package:roomy_mobile/households/enums/invite_user_failure.dart';
import 'package:roomy_mobile/households/forms/invite_user_form.dart';
import 'package:roomy_mobile/households/forms/shopping_list_item_form.dart';
import 'package:roomy_mobile/households/forms/update_household_name_form.dart';
import 'package:roomy_mobile/households/models/household_invite_model.dart';
import 'package:roomy_mobile/households/models/household_member.dart';
import 'package:roomy_mobile/households/routing/home_router.dart';
import 'package:roomy_mobile/households/services/home_view_items_preview_service.dart';
import 'package:roomy_mobile/households/services/household_invites_service.dart';
import 'package:roomy_mobile/households/services/household_service.dart';
import 'package:roomy_mobile/l10n/globals/g_strings.dart';
import 'package:roomy_mobile/notifications/analytics/notification_permission_analytics.dart';
import 'package:roomy_mobile/notifications/services/notification_permission_service.dart';
import 'package:roomy_mobile/notifications/services/notification_preferences_service.dart';
import 'package:roomy_mobile/notifications/widgets/notification_consent_sheet.dart';
import 'package:roomy_mobile/payments/dtos/payment_dto.dart';
import 'package:roomy_mobile/payments/enums/payment_period_filter.dart';
import 'package:roomy_mobile/payments/routing/payments_router.dart';
import 'package:roomy_mobile/payments/services/payment_summary_service.dart';
import 'package:roomy_mobile/payments/services/payments_service.dart';
import 'package:roomy_mobile/routing/routers/core_router.dart';
import 'package:roomy_mobile/shopping/forms/shopping_list_form.dart';
import 'package:roomy_mobile/shopping/models/shopping_list.dart';
import 'package:roomy_mobile/shopping/routing/shopping_router.dart';
import 'package:roomy_mobile/shopping/services/shopping_list_dtos_service.dart';
import 'package:roomy_mobile/shopping/services/shopping_list_item_dtos_service.dart';
import 'package:roomy_mobile/shopping/services/shopping_list_service.dart';
import 'package:roomy_mobile/state/exceptions/unexpected_null_exception.dart';
import 'package:roomy_mobile/state/extensions/context_extension.dart';
import 'package:roomy_mobile/state/globals/g_busy.dart';
import 'package:roomy_mobile/state/typedefs/lazy_locator_def.dart';
import 'package:roomy_mobile/ui/abstracts/slidable_management.dart';
import 'package:roomy_mobile/ui/config/t_icon_vars.dart';
import 'package:roomy_mobile/ui/services/random_service.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:veto/data/models/base_view_model.dart';

class HomeViewModel extends BaseViewModel with Loglytics, SlidableManagement {
  HomeViewModel({
    required HouseholdService householdService,
    required HouseholdInvitesService householdInvitesService,
    required UserProfilesService userProfilesService,
    required BadgeService badgeService,
    required CleaningTasksService cleaningTasksService,
    required PaymentsService paymentsService,
    required PaymentSummaryService paymentSummaryService,
    required HomeViewItemsPreviewService homeViewItemsPreviewService,
    required NotificationPermissionService notificationPermissionService,
    required NotificationPreferencesService notificationPreferencesService,
    required LazyLocatorDef<ShoppingListDtosService> slDtoService,
    required LazyLocatorDef<ShoppingListItemDtosService> slItemsService,
    required LazyLocatorDef<ShoppingListService> shoppingListService,
    required LazyLocatorDef<ShoppingRouter> shoppingListRouter,
    required LazyLocatorDef<HomeRouter> homeRouter,
    required LazyLocatorDef<CoreRouter> coreRouter,
    required LazyLocatorDef<CleaningRouter> cleaningRouter,
    required LazyLocatorDef<DialogService> dialogService,
    required LazyLocatorDef<ShoppingListItemForm> shoppingListItemForm,
    required LazyLocatorDef<PaymentsRouter> paymentsRouter,
    required LazyLocatorDef<SheetService> sheetService,
    required LazyLocatorDef<ToastService> toastService,
  }) : _householdService = householdService,
        _householdInvitesService = householdInvitesService,
        _userProfilesService = userProfilesService,
        _badgeService = badgeService,
        _cleaningTasksService = cleaningTasksService,
        _paymentsService = paymentsService,
        _paymentSummaryService = paymentSummaryService,
        _homeViewItemsPreviewService = homeViewItemsPreviewService,
        _notificationPermissionService = notificationPermissionService,
        _notificationPreferencesService = notificationPreferencesService,
        _slDtoService = slDtoService,
        _slItemsService = slItemsService,
        _shoppingListService = shoppingListService,
        _shoppingListRouter = shoppingListRouter,
        _homeRouter = homeRouter,
        _coreRouter = coreRouter,
        _cleaningRouter = cleaningRouter,
        _dialogService = dialogService,
        _paymentsRouter = paymentsRouter,
        _sheetService = sheetService,
        _toastService = toastService,
        _shoppingListItemForm = shoppingListItemForm;

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static HomeViewModel get locate => GetIt.I.get();
  static void registerFactory() => GetIt.I.registerFactory(
        () => HomeViewModel(
      paymentsRouter: () => PaymentsRouter.locate,
      householdService: HouseholdService.locate,
      householdInvitesService: HouseholdInvitesService.locate,
      userProfilesService: UserProfilesService.locate,
      badgeService: BadgeService.locate,
      cleaningTasksService: CleaningTasksService.locate,
      paymentsService: PaymentsService.locate,
      paymentSummaryService: PaymentSummaryService.locate,
      homeViewItemsPreviewService: HomeViewItemsPreviewService.locate,
      notificationPermissionService: NotificationPermissionService.locate,
      notificationPreferencesService: NotificationPreferencesService.locate,
      slDtoService: () => ShoppingListDtosService.locate,
      slItemsService: () => ShoppingListItemDtosService.locate,
      shoppingListService: () => ShoppingListService.locate,
      shoppingListRouter: () => ShoppingRouter.locate,
      homeRouter: () => HomeRouter.locate,
      coreRouter: () => CoreRouter.locate,
      cleaningRouter: () => CleaningRouter.locate,
      dialogService: () => DialogService.locate,
      shoppingListItemForm: () => ShoppingListItemForm.locate,
      sheetService: () => SheetService.locate,
      toastService: () => ToastService.locate,
    ),
  );

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\

  final HouseholdService _householdService;
  final HouseholdInvitesService _householdInvitesService;
  final UserProfilesService _userProfilesService;
  final BadgeService _badgeService;
  final CleaningTasksService _cleaningTasksService;
  final PaymentsService _paymentsService;
  final PaymentSummaryService _paymentSummaryService;
  final HomeViewItemsPreviewService _homeViewItemsPreviewService;
  final NotificationPermissionService _notificationPermissionService;
  final NotificationPreferencesService _notificationPreferencesService;

  final LazyLocatorDef<ShoppingListDtosService> _slDtoService;
  final LazyLocatorDef<ShoppingListItemDtosService> _slItemsService;
  final LazyLocatorDef<ShoppingListService> _shoppingListService;
  final LazyLocatorDef<ShoppingRouter> _shoppingListRouter;
  final LazyLocatorDef<HomeRouter> _homeRouter;
  final LazyLocatorDef<PaymentsRouter> _paymentsRouter;
  final LazyLocatorDef<CoreRouter> _coreRouter;
  final LazyLocatorDef<CleaningRouter> _cleaningRouter;
  final LazyLocatorDef<DialogService> _dialogService;
  final LazyLocatorDef<ShoppingListItemForm> _shoppingListItemForm;
  final LazyLocatorDef<SheetService> _sheetService;
  final LazyLocatorDef<ToastService> _toastService;

  late final _notificationAnalytics = NotificationPermissionAnalytics.locate(
    location: 'HomeViewModel',
  );

  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @override
  Future<void> initialise() async {
    await _cleaningTasksService.isReady;
    await _checkNotificationBannerVisibility();
    super.initialise();
  }

  Future<void> _checkNotificationBannerVisibility() async {
    await _notificationPermissionService.checkStatus();
    final shouldShow = _notificationPreferencesService.shouldShowConsentBanner(
      canRequestPermission: _notificationPermissionService.canRequestPermission,
    );
    _shouldShowNotificationBanner.value = shouldShow;

    if (shouldShow) {
      _notificationAnalytics.bannerShown();
    }
  }

  @override
  Future<void> dispose() async {
    expensePopoverController.dispose();
    _shouldShowNotificationBanner.dispose();
    super.dispose();
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  final _shouldShowNotificationBanner = Informer<bool>(false);

  late final _inviteUserForm = InviteUserForm.locate;
  late final _updateHouseholdNameForm = UpdateHouseholdNameForm.locate;
  late final _shoppingListForm = ShoppingListForm.locate;

  final _selectedPeriod = Informer<PaymentPeriodFilter>(PaymentPeriodFilter.month);
  final _customDateRange = Informer<DateTimeRange?>(null);

  final expensePopoverController = ShadPopoverController();

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  ValueListenable<HouseholdDto?> get householdDto => _householdService.doc;
  ValueListenable<List<HouseholdInviteModel>> get outstandingInvites =>
      _householdInvitesService.householdInvites;
  ValueListenable<List<HouseholdMember>> get householdMembers =>
      _userProfilesService.householdMembers;
  ValueListenable<List<ShoppingList>> get openShoppingLists => _shoppingListService().shoppingLists;
  MyCleaningTasks get myCleaningTasks => _cleaningTasksService.myCleaningTasks;
  ValueListenable<bool> get showInboxBadge => _badgeService.showInboxBadge;
  ValueListenable<List<PaymentDto>> get paymentsListenable =>
      _paymentsService.allPaymentsListenable;

  List<CleaningTaskDto> get myCleaningTasksPreview => _homeViewItemsPreviewService.getPreviewItems(
    items: myCleaningTasks.all,
    itemType: HomeViewItemType.cleaningTask,
  );

  ValueListenable<PaymentPeriodFilter> get selectedPeriodListenable => _selectedPeriod;

  DateTimeRange? get customDateRange => _customDateRange.value;

  ValueListenable<DateTimeRange?> get customDateRangeListenable => _customDateRange;

  List<PaymentDto> get filteredUserPayments =>
      _paymentsService.getFilteredPaymentsByPeriod(_selectedPeriod.value, _customDateRange.value);

  double get userPaidTotal => _paymentSummaryService.userPaidTotal(
    selectedPeriod: _selectedPeriod.value,
    customDateRange: _customDateRange.value,
  );

  double get userOwesTotal => _paymentSummaryService.userOwesTotal(
    selectedPeriod: _selectedPeriod.value,
    customDateRange: _customDateRange.value,
  );

  String periodDisplayLabel({required BuildContext context}) =>
      _paymentSummaryService.periodDisplayLabel(
        selectedPeriod: _selectedPeriod.value,
        customDateRange: _customDateRange.value,
        context: context,
      );

  ValueListenable<bool> get shouldShowNotificationBanner => _shouldShowNotificationBanner;

  // 🏗 HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  void onPresetSelected(PaymentPeriodFilter period) {
    _selectedPeriod.value = period;
    _customDateRange.value = null;
  }

  void onCustomRangeSelected(DateTimeRange? range) {
    _customDateRange.value = range;
  }

  RandomService get _randomService => RandomService.locateFactory;

  Future<void> onCreateHouseholdPressed({required BuildContext context}) async {
    final response = await _householdService.createHousehold(
      householdDto: (vars) => HouseholdDto.create(
        userId: vars.userId,
        id: vars.id,
        name: _randomService.randomHouseholdName,
      ),
    );
    response.when(
      success: (response) {
        final nHouseholdDto = response.result;
        gShowNotification(
          context: context,
          title: context.strings.householdCreated(nHouseholdDto.name),
          subtitle: context.strings.clickToView,
          action: TTextButtonVars(
            text: context.strings.viewCaps,
            onPressed: () => _homeRouter().goManageHouseholdView(id: nHouseholdDto.id),
          ),
        );
      },
      fail: (response) {
        gShowOkDialog(
          context: context,
          title: context.strings.somethingWentWrong,
          message: response.message ?? context.strings.somethingWentWrongPleaseTryAgainLater,
        );
      },
    );
  }

  void onSettingsPressed() => _coreRouter().pushSettingsView();

  void onViewPaymentsPressed() => _paymentsRouter().goPaymentsView();

  void onManageHouseholdPressed() {
    final householdId = _householdService.doc.value?.id;
    final strings = context?.strings ?? gStrings;
    if (householdId == null) {
      gShowOkDialog(
        context: context,
        title: strings.notFound,
        message: strings.somethingWentWrongWhileTryingToLoadYourHouseholdPlease,
      );
    }
    _homeRouter().goManageHouseholdView(id: householdId!);
  }

  void onInboxPressed() => _homeRouter().pushInboxView();

  Future<void> onAddMemberPressed({required BuildContext context}) async {
    final field = _inviteUserForm.username;
    WidgetsBinding.instance.addPostFrameCallback((_) => field.requestFocus());
    await _dialogService().showTextInputDialog(
      title: context.strings.invite,
      message: context.strings.inviteHouseholdMessage,
      formFieldConfig: field,
      iconLabelDto: IconLabelDto(
        icon: IconCollection.household,
        label: context.strings.usernameFieldLabel,
      ),
      okButtonText: context.strings.invite,
      formFieldHint: context.strings.usernameFieldHint,
      onOkButtonPressed: (value) => onInviteConfirmed(context: context),
      context: context,
      leadingIcon: Icons.person_add_rounded,
      onClosePressed: (context) => _silentResetFormField(formFieldConfig: field),
    );
  }

  Future<void> _silentResetFormField({required TFormFieldConfig<String> formFieldConfig}) async {
    await TDurations.animation.asFuture;
    WidgetsBinding.instance.addPostFrameCallback((_) => formFieldConfig.silentReset());
  }

  Future<void> onInviteConfirmed({required BuildContext context}) async {
    if (gIsBusy) return;
    try {
      log.debug('Confirming invite with form validity: ${_inviteUserForm.isValid}');
      if (_inviteUserForm.isValid) {
        gSetBusy();
        final username = _inviteUserForm.username.cValue!;
        log.debug('Sending invite to username: $username');
        final householdId = _householdService.id;
        if (householdId == null) {
          throw const UnexpectedNullException(
            reason: 'householdId should not be null when inviting a user',
          );
        }

        final response = await _householdInvitesService.inviteUser(
          householdId: householdId,
          username: username,
        );

        response.when(
          success: (response) {
            log.debug(context.strings.inviteSentSuccessfully);
            gShowNotification(
              context: context,
              title: context.strings.inviteSent,
              subtitle: context.strings.clickToView,
              action: TTextButtonVars(
                text: context.strings.viewCaps,
                onPressed: () {
                  _homeRouter().goManageHouseholdView(id: householdId);
                },
              ),
            );
            context.pop();
            unawaited(_silentResetFormField(formFieldConfig: _inviteUserForm.username));
          },
          fail: (response) {
            log.debug('Invite failed with response: $response');

            if (response.error is InviteUserFailure) {
              gShowOkDialog(
                context: context,
                title: response.title ?? context.strings.failedToSendInvite,
                message: response.message ?? context.strings.failedToSendInvite,
              );
            } else {
              gShowOkDialog(
                context: context,
                title: context.strings.failedToSendInvite,
                message: response.message ?? context.strings.somethingWentWrong,
              );
            }
          },
        );
      } else {
        _inviteUserForm.username.requestFocus();
      }
    } catch (error, stackTrace) {
      log.error('$error caught while sending invite', error: error, stackTrace: stackTrace);
    } finally {
      gSetIdle();
    }
  }

  void onHouseholdNameTapped({required BuildContext context}) {
    final strings = context.strings;
    _dialogService().showTextAreaInputDialog(
      leadingIcon: Icons.edit_rounded,
      okButtonText: strings.save,
      message: strings.enterTheNewNameForTheHouseholdThisWillBe,
      title: strings.changeName,
      formFieldHint: strings.household,
      iconLabelDto: IconLabelDto(icon: IconCollection.household, label: strings.name),
      formFieldConfig: _updateHouseholdNameForm.householdNameField
        ..updateValue(householdDto.value?.name),
      onOkButtonPressed: (context) => _onSaveHouseholdNamePressed(context: context),
      onClosePressed: (context) =>
          _silentResetFormField(formFieldConfig: _updateHouseholdNameForm.householdNameField),
      context: context,
    );
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => _updateHouseholdNameForm.householdNameField.requestFocus(),
    );
  }

  Future<void> _onSaveHouseholdNamePressed({required BuildContext context}) async {
    try {
      log.debug(
        'Confirming household name change with form validity: ${_updateHouseholdNameForm.isValid}',
      );
      if (_updateHouseholdNameForm.isValid) {
        final name = _updateHouseholdNameForm.householdNameField.cValue!;
        log.debug('Name from form: $name');
        log.debug('Updating household name to: $name');
        final response = await _householdService.updateName(name: name);
        response.when(
          success: (response) {
            log.debug('Name updated successfully');
            gShowNotification(context: context, title: context.strings.nameChangedSuccessfully);
            context.pop();
          },
          fail: (response) {
            log.debug('Name update failed with response: $response');
            gShowNotification(context: context, title: context.strings.failedToUpdateName);
          },
        );
      }
    } catch (error, stackTrace) {
      log.error('$error caught while saving household name', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> onCancelPressed({
    required BuildContext context,
    required HouseholdInviteModel householdInvite,
  }) async {
    if (gIsBusy) return;

    final shouldCancel = await gShowOkCancelDialog(
      context: context,
      title: context.strings.removeMember,
      message: context.strings.areYouSureYouWantToRemoveThisMember,
    );

    if (shouldCancel != true) return;

    try {
      gSetBusy();
      final response = await _householdInvitesService.cancelInvite(
        id: householdInvite.id,
        isMyInvite: householdInvite.recipientId == gUserId,
      );
      response.when(
        success: (response) {
          gShowNotification(context: context, title: context.strings.inviteCanceled);
        },
        fail: (response) {
          gShowOkDialog(
            title: context.strings.somethingWentWrong,
            message: context.strings.failedToDeclineInviteRightNowPleaseTryAgainLater,
            context: context,
          );
        },
      );
      await closeSlidable(householdInvite.id);
    } catch (error, stackTrace) {
      log.error(
        '$error caught while accepting household invite',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      gSetIdle();
    }
  }

  Future<void> onToggleEditPressed({required String householdId}) async {
    try {
      await toggleSlidable(householdId);
    } catch (error, stackTrace) {
      log.error('$error caught while opening slidable', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> onRemovePressed({
    required UserProfileDto householdMember,
    required BuildContext context,
  }) async {
    if (gIsBusy) return;
    try {
      final isSelf = householdMember.id == _userProfilesService.self.value?.id;

      final didConfirm = await gShowOkCancelDialog(
        context: context,
        title: switch (isSelf) {
          true => context.strings.leaveHousehold,
          false => context.strings.removeMember,
        },
        message: switch (isSelf) {
          true => context.strings.areYouSureYouWantToLeaveThisHousehold,
          false => context.strings.areYouSureYouWantToRemoveThisMember,
        },
      );

      if (didConfirm != true) return;

      gSetBusy();

      final response = await _householdService.removeMember(householdMember: householdMember);
      response.when(
        success: (response) {
          if (isSelf) {
            gShowOkDialog(
              context: context,
              title: context.strings.youHaveLeftTheHousehold,
              message: context.strings.youWillNoLongerHaveAccessToThisHouseholdYou,
            );
          } else {
            gShowNotification(context: context, title: context.strings.memberRemoved);
          }
          closeSlidable(householdMember.id);
          final householdId = _householdService.id;
          if (householdId == null) {
            throw const UnexpectedNullException(
              reason: 'householdId should not be null when removing a user',
            );
          }
          _homeRouter().goManageHouseholdView(id: householdId);
        },
        fail: (response) {
          gShowOkDialog(
            context: context,
            title: context.strings.somethingWentWrong,
            message: context.strings.failedToRemoveMemberRightNowPleaseTryAgainLater,
          );
        },
      );
    } catch (error, stackTrace) {
      log.error(
        '$error caught while removing household member',
        error: error,
        stackTrace: stackTrace,
      );
      unawaited(gShowSomethingWentWrongDialog(context: context));
    } finally {
      gSetIdle();
    }
  }

  void onUserPressed({required HouseholdMember householdMember, required BuildContext context}) {
    // TODO: Implement member details navigation
  }

  void onAddShoppingListPressed() {
    if (context == null) return;
    final strings = context?.strings ?? gStrings;

    _dialogService().showTextInputDialog(
      leadingIcon: Icons.shopping_cart_rounded,
      formFieldConfig: _shoppingListForm.nameField,
      context: context!,
      onOkButtonPressed: (context) => _onCreateShoppingListPressed(context: context),
      onClosePressed: (context) {
        _silentResetFormField(formFieldConfig: _shoppingListForm.nameField);
      },
      title: strings.createShoppingList,
      message: strings.enterTheNameForTheNewShoppingList,
      okButtonText: strings.create,
      iconLabelDto: IconLabelDto(icon: IconCollection.shoppingList, label: strings.name),
      formFieldHint: strings.shoppingLists,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _shoppingListForm.nameField.requestFocus());
  }

  Future<void> _onCreateShoppingListPressed({required BuildContext context}) async {
    try {
      if (_shoppingListForm.isValid) {
        final name = _shoppingListForm.nameField.cValue!;
        final response = await _slDtoService().createShoppingList(title: name);
        response.when(
          success: (result) {
            gShowNotification(context: context, title: context.strings.createShoppingList);
            context.pop();
            _shoppingListRouter().goShoppingListView(shoppingListId: result.result.id);
          },
          fail: (failure) {
            unawaited(gShowSomethingWentWrongDialog(context: context));
          },
        );
      }
    } catch (error, stackTrace) {
      log.error('$error caught while creating shopping list', error: error, stackTrace: stackTrace);
    }
  }

  void onShoppingListPressed(ShoppingList item) =>
      _shoppingListRouter().goShoppingListView(shoppingListId: item.id);

  void onViewAllShoppingListsPressed() => _shoppingListRouter().goShoppingView();

  void onViewAllCleaningTasksPressed() => _cleaningRouter().goCleaningView();

  void onMyTaskPressed(CleaningTaskDto task) => _cleaningRouter().goCleaningView();

  Future<void> onCompleteCleaningTaskPressed({
    required CleaningTaskDto task,
    required bool isCompleted,
    required BuildContext context,
  }) async {
    if (isCompleted) {
      await _onCompleteTaskPressed(task, context: context);
    } else {
      await _onUncompleteTaskPressed(task, context: context);
    }
  }

  Future<void> _onCompleteTaskPressed(CleaningTaskDto task, {required BuildContext context}) async {
    try {
      final now = DateTime.now();
      final newTimeSlot = CleaningTimeSlotDto(
        id: _cleaningTasksService.api.genId,
        createdAt: now,
        updatedAt: now,
        householdId: task.householdId,
        cleaningTaskId: task.id,
        completedAt: now,
        completedBy: gUserId!,
      );

      final updatedHistory = [newTimeSlot, ...task.completedTimeSlotsHistory];

      final response = await _cleaningTasksService.updateCleaningTask(
        id: task.id,
        doc: (current, vars) => current.copyWith(
          completedTimeSlotsHistory: (prev) => updatedHistory,
          assignedToUserId: gUserId,
        ),
      );

      response.when(
        success: (_) {
          gShowNotification(
            context: context,
            title: context.strings.taskCompleted,
            subtitle: task.name,
          );
        },
        fail: (error) {
          gShowOkDialog(
            context: context,
            title: context.strings.somethingWentWrong,
            message: error.message ?? context.strings.failedToCompleteTask,
          );
        },
      );
    } catch (error, stackTrace) {
      log.error('Error completing cleaning task', error: error, stackTrace: stackTrace);
      unawaited(gShowSomethingWentWrongDialog(context: context));
    }
  }

  Future<void> _onUncompleteTaskPressed(
      CleaningTaskDto task, {
        required BuildContext context,
      }) async {
    try {
      final updatedHistory = task.completedTimeSlotsHistory.skip(1).toList();

      final response = await _cleaningTasksService.updateCleaningTask(
        id: task.id,
        doc: (current, vars) => current.copyWith(
          completedTimeSlotsHistory: (prev) => updatedHistory,
          assignedToUserId: gUserId,
        ),
      );

      response.when(
        success: (_) {
          gShowNotification(
            context: context,
            title: context.strings.taskUncompleted,
            subtitle: task.name,
          );
        },
        fail: (error) {
          gShowOkDialog(
            context: context,
            title: context.strings.somethingWentWrong,
            message: error.message ?? context.strings.failedToUncompleteTask,
          );
        },
      );
    } catch (error, stackTrace) {
      log.error('Error un completing cleaning task', error: error, stackTrace: stackTrace);
      unawaited(gShowSomethingWentWrongDialog(context: context));
    }
  }

  void onAddShoppingListItemPressed({required BuildContext context}) {
    final shoppingListItemForm = _shoppingListItemForm();
    final availableLists = _shoppingListService().shoppingLists;

    final pAvailableLists = availableLists.value;
    if (pAvailableLists.isEmpty) {
      gShowOkDialog(
        context: context,
        title: context.strings.shoppingList,
        message: context.strings.enterTheNameForTheNewShoppingList,
      );
      return;
    }

    shoppingListItemForm.initializeShoppingListItems(pAvailableLists);

    _dialogService().showTextInputAndDropdownDialog<ShoppingList>(
      textInputConfig: shoppingListItemForm.nameField,
      formFieldConfig: shoppingListItemForm.shoppingListField,
      context: context,
      title: context.strings.addItem,
      message: context.strings.enterTheNameForTheNewShoppingList,
      okButtonText: context.strings.add,
      iconLabelDto: IconLabelDto(icon: IconCollection.name, label: context.strings.shoppingList),
      formFieldHint: context.strings.enterTheNameForTheNewShoppingList,
      dropdownLabel: context.strings.shoppingList,
      dropdownPlaceholder: context.strings.shoppingList,
      leadingIcon: Icons.shopping_cart_outlined,
      itemLabelBuilder: (list) => list.title,
      onOkButtonPressed: (context) async {
        if (shoppingListItemForm.isValid) {
          final itemName = shoppingListItemForm.nameField.cValue!;
          final selectedList = shoppingListItemForm.shoppingListField.cValue!;

          try {
            final nextOrder =
                _shoppingListService().findShoppingListById(selectedList.id)?.nextOrder ?? 0;

            final response = await _slItemsService().createShoppingListItem(
              shoppingListId: selectedList.id,
              order: nextOrder,
            );

            unawaited(
              response.when(
                success: (result) async {
                  await _slItemsService().updateName(id: result.result.id, name: itemName);

                  context.tryPop();

                  gShowNotification(
                    context: context,
                    title: context.strings.itemAdded,
                    subtitle: selectedList.title,
                    action: TTextButtonVars(
                      text: context.strings.viewCaps,
                      onPressed: () =>
                          _shoppingListRouter().goShoppingListView(shoppingListId: selectedList.id),
                    ),
                  );
                },
                fail: (error) {
                  gShowOkDialog(
                    context: context,
                    title: error.title ?? context.strings.somethingWentWrong,
                    message: error.message ?? context.strings.somethingWentWrongPleaseTryAgainLater,
                  );
                  return null;
                },
              ),
            );
          } catch (error, stackTrace) {
            log.error('Error adding shopping list item', error: error, stackTrace: stackTrace);
            unawaited(
              gShowOkDialog(
                context: context,
                title: context.strings.somethingWentWrong,
                message: context.strings.anUnknownErrorOccurredPleaseTryAgainLater,
              ),
            );
          }
        }
      },
      onClosePressed: (context) {
        _silentResetFormField(formFieldConfig: _shoppingListItemForm().nameField);
        context.tryPop();
      },
    );
  }

  Future<void> onNotificationBannerTapped({required BuildContext context}) async {
    _notificationAnalytics.bannerTapped();
    _notificationAnalytics.consentSheetShown();

    await _sheetService().showBottomSheet(
      context: context,
      shadSheet: NotificationConsentSheet(
        onAccept: () => _onConsentAccepted(context: context),
        onCancel: () => _onConsentCancelled(context: context),
      ),
    );
  }

  Future<void> _onConsentAccepted({required BuildContext context}) async {
    _notificationAnalytics.consentAccepted();

    final granted = await _notificationPermissionService.requestPermission();

    if (granted) {
      _notificationAnalytics.permissionGranted();
      await _notificationPreferencesService.updateOsPermissionGranted(granted: true);
      _shouldShowNotificationBanner.value = false;

      _toastService().showToast(
        context: context,
        title: context.strings.notificationPermissionGrantedToast,
      );
    } else {
      _notificationAnalytics.permissionDenied();
      await _notificationPreferencesService.updateOsPermissionGranted(granted: false);
      _shouldShowNotificationBanner.value = false;

      _toastService().showToast(
        context: context,
        title: context.strings.notificationPermissionDeniedToast,
      );
    }

    if (context.mounted) {
      context.pop();
    }
  }

  void _onConsentCancelled({required BuildContext context}) {
    _notificationAnalytics.consentCancelled();
    if (context.mounted) {
      context.pop();
    }
  }
}

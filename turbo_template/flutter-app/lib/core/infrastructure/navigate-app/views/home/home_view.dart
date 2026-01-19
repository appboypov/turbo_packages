import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_flutter_template/core/infrastructure/navigate-app/views/home/home_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/constants/t_widget.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_scaffold.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/widgets/t_sliver_body.dart';
import 'package:veto/data/models/base_view_model.dart';
import 'package:veto/widgets/view_model_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String path = 'household';

  @override
  Widget build(BuildContext context) => ViewModelBuilder<HomeViewModel>(
    builder: (context, model, isInitialised, child) {
      if (!isInitialised) return TWidgets.nothing;

      return ValueListenableBuilder<bool>(
        valueListenable: model.showInboxBadge,
        builder: (context, hasUnreadChangelog, _) => Semantics(
          identifier: 'home_screen',
          label: context.strings.homeScreenLabel,
          child: TScaffold(
            child: TSliverBody(
              emptyPlaceholder: (context) => Center(
                child: TEmptyPlaceholder.households(
                  onCreateHouseholdPressed: () =>
                      model.onCreateHouseholdPressed(context: context),
                ),
              ),
              isEmpty: householdDto == null,
              appBar: TSliverAppBar(
                title: context.strings.home,
                emoji: Emoji.house,
                onBackPressed: null,
                actions: [
                  if (householdDto != null)
                    Semantics(
                      container: true,
                      identifier: 'inbox_button',
                      label: context.strings.inbox,
                      button: true,
                      child: Builder(
                        builder: (context) {
                          final button = ShadIconButton.ghost(
                            onPressed: model.onInboxPressed,
                            icon: const Icon(Icons.email),
                          );
                          return hasUnreadChangelog ? TBadge(child: button) : button;
                        },
                      ),
                    ),
                  Semantics(
                    container: true,
                    identifier: 'settings_button',
                    label: context.strings.settingsButtonLabel,
                    button: true,
                    child: ShadIconButton.ghost(
                      onPressed: model.onSettingsPressed,
                      icon: const Icon(Icons.settings_rounded),
                    ),
                  ),
                ],
              ),
              children: [
                TMargin.horizontal(
                  child: ListenableBuilder(
                    listenable: Listenable.merge([
                      model.paymentsListenable,
                      model.selectedPeriodListenable,
                      model.customDateRangeListenable,
                    ]),
                    builder: (context, _) => TUserExpenseSummaryCard(
                      popoverController: model.expensePopoverController,
                      paidAmount: model.userPaidTotal,
                      owesAmount: model.userOwesTotal,
                      periodDisplayLabel: model.periodDisplayLabel(context: context),
                      selectedPeriodListenable: model.selectedPeriodListenable,
                      userPaymentsTotal: null,
                      filteredPayments: model.filteredUserPayments,
                      onviewPaymentsPressed: () => model.onViewPaymentsPressed(),
                      customDateRangeListenable: model.customDateRangeListenable,
                      onTodayPressed: () => model.onPresetSelected(PaymentPeriodFilter.day),
                      onWeekPressed: () => model.onPresetSelected(PaymentPeriodFilter.week),
                      onMonthPressed: () => model.onPresetSelected(PaymentPeriodFilter.month),
                      onYearPressed: () => model.onPresetSelected(PaymentPeriodFilter.year),
                      onCustomRangeSelected: model.onCustomRangeSelected,
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: model.shouldShowNotificationBanner,
                  builder: (context, shouldShow, _) => SlideShrink(
                    show: shouldShow,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TMargin.horizontal(
                        child: NotificationConsentBanner(
                          onTap: () => model.onNotificationBannerTapped(context: context),
                        ),
                      ),
                    ),
                  ),
                ),
                const TGap(16),
                const TMargin.horizontal(child: _MyCleaningSchedule()),
                const TGap(16),
                const TMargin.horizontal(child: _MyShoppingLists()),
                const TGap(16),
                const TMargin.horizontal(child: _MyRoomies()),
                const TGap.bottomFade(),
              ],
            ),
          ),
        ),
      );
    },
    viewModelBuilder: () => HomeViewModel.locate,
  );
}

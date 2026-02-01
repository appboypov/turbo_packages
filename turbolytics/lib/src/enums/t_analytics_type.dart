import 'package:turbolytics/turbolytics.dart';

/// Every action or state that's applicable to data from your [TAnalytics] implementations.
enum TAnalyticsType {
  event,
  tapped,
  clicked,
  focussed,
  selected,
  connected,
  disconnected,
  viewed,
  hidden,
  opened,
  closed,
  failed,
  succeeded,
  sent,
  received,
  validated,
  invalidated,
  searched,
  liked,
  shared,
  commented,
  input,
  incremented,
  decremented,
  accepted,
  declined,
  alert,
  scrolled,
  started,
  stopped,
  initialised,
  disposed,
  fetched,
  set,
  get,
  foreground,
  background,
  purchased,
  dismissed,
  upgraded,
  downgraded,
  interaction,
  query,
  confirmed,
  canceled,
  created,
  read,
  updated,
  deleted,
  added,
  removed,
  subscribed,
  unsubscribed,
  changed,
  denied,
  skipped,
  checked,
  unchecked,
  attempted,
  reset,
  enabled,
  disabled,
  began,
  ended,
  refreshed,
  generated,
  unsupported,
  invalid,
  valid,
  shown,
  loaded,
  saved,
  found,
  completed,
  error,
  given,
  notFound,
  taken,
  snoozed,
  verified,
  swiped,
  used,
  filled,
  cleared,
  unverified,
  paused,
  resumed,
  linked,
  unlinked,
  requested,
  pressed,
  none,
}

/// Used to generate the proper String format when sending analytics to the analytics provider.
extension AnalyticsTypesHelpers on TAnalyticsType {
  String get value {
    switch (this) {
      case TAnalyticsType.event:
      case TAnalyticsType.tapped:
      case TAnalyticsType.clicked:
      case TAnalyticsType.focussed:
      case TAnalyticsType.selected:
      case TAnalyticsType.connected:
      case TAnalyticsType.disconnected:
      case TAnalyticsType.viewed:
      case TAnalyticsType.hidden:
      case TAnalyticsType.opened:
      case TAnalyticsType.closed:
      case TAnalyticsType.failed:
      case TAnalyticsType.succeeded:
      case TAnalyticsType.sent:
      case TAnalyticsType.received:
      case TAnalyticsType.validated:
      case TAnalyticsType.invalidated:
      case TAnalyticsType.searched:
      case TAnalyticsType.liked:
      case TAnalyticsType.shared:
      case TAnalyticsType.commented:
      case TAnalyticsType.input:
      case TAnalyticsType.incremented:
      case TAnalyticsType.decremented:
      case TAnalyticsType.accepted:
      case TAnalyticsType.declined:
      case TAnalyticsType.alert:
      case TAnalyticsType.scrolled:
      case TAnalyticsType.started:
      case TAnalyticsType.stopped:
      case TAnalyticsType.initialised:
      case TAnalyticsType.disposed:
      case TAnalyticsType.fetched:
      case TAnalyticsType.set:
      case TAnalyticsType.get:
      case TAnalyticsType.foreground:
      case TAnalyticsType.background:
      case TAnalyticsType.purchased:
      case TAnalyticsType.dismissed:
      case TAnalyticsType.upgraded:
      case TAnalyticsType.downgraded:
      case TAnalyticsType.interaction:
      case TAnalyticsType.query:
      case TAnalyticsType.confirmed:
      case TAnalyticsType.canceled:
      case TAnalyticsType.created:
      case TAnalyticsType.read:
      case TAnalyticsType.updated:
      case TAnalyticsType.deleted:
      case TAnalyticsType.added:
      case TAnalyticsType.removed:
      case TAnalyticsType.subscribed:
      case TAnalyticsType.unsubscribed:
      case TAnalyticsType.changed:
      case TAnalyticsType.denied:
      case TAnalyticsType.skipped:
      case TAnalyticsType.checked:
      case TAnalyticsType.unchecked:
      case TAnalyticsType.attempted:
      case TAnalyticsType.reset:
      case TAnalyticsType.enabled:
      case TAnalyticsType.disabled:
      case TAnalyticsType.began:
      case TAnalyticsType.ended:
      case TAnalyticsType.refreshed:
      case TAnalyticsType.generated:
      case TAnalyticsType.unsupported:
      case TAnalyticsType.invalid:
      case TAnalyticsType.valid:
      case TAnalyticsType.shown:
      case TAnalyticsType.loaded:
      case TAnalyticsType.saved:
      case TAnalyticsType.found:
      case TAnalyticsType.completed:
      case TAnalyticsType.error:
      case TAnalyticsType.taken:
      case TAnalyticsType.given:
      case TAnalyticsType.snoozed:
      case TAnalyticsType.verified:
      case TAnalyticsType.swiped:
      case TAnalyticsType.used:
      case TAnalyticsType.filled:
      case TAnalyticsType.cleared:
      case TAnalyticsType.unverified:
      case TAnalyticsType.paused:
      case TAnalyticsType.resumed:
      case TAnalyticsType.linked:
      case TAnalyticsType.unlinked:
      case TAnalyticsType.requested:
      case TAnalyticsType.pressed:
        return name;
      case TAnalyticsType.notFound:
        return 'not_found';
      case TAnalyticsType.none:
        return '';
    }
  }

  /// Used to generate [CustomAnalytic] objects based on [TAnalyticsType].
  CustomAnalytic toCustomAnalytic({
    required String subject,
    Map<String, Object>? parameters,
  }) => TAnalytic(
    subject: subject,
    type: this,
    parameters: parameters,
  ).toCustomAnalytic;
}

import '../enums/t_analytics_type.dart';

/// Core class that's used to structure and provide analytics in the [AnalyticsService].
class TAnalytic {
  const TAnalytic({
    required String subject,
    required TAnalyticsType type,
    this.parameters,
  })  : _subject = subject,
        _type = type;

  final String _subject;
  final TAnalyticsType _type;
  final Map<String, Object>? parameters;

  String get name => '${_subject}_${_type.value}';

  bool equals(TAnalytic? other) =>
      other != null &&
      (identical(this, other) ||
          runtimeType == other.runtimeType &&
              _subject == other._subject &&
              _type == other._type &&
              parameters == other.parameters);

  CustomAnalytic get toCustomAnalytic => CustomAnalytic(name: name);
}

/// Custom variation on the [TAnalytic] that allows for more flexibility when sending analytics.
class CustomAnalytic extends TAnalytic {
  CustomAnalytic({
    required String name,
    super.parameters,
  }) : super(
          subject: name,
          type: TAnalyticsType.none,
        );

  @override
  String get name => _subject;
}

extension TurboFormNumExtension on num {
  bool get tHasDecimals => this % 1 != 0;
}

extension TurboFormStringExtension on String {
  double? get tTryAsDouble => double.tryParse(this);
  int? get tTryAsInt => int.tryParse(this);
  String get tNaked => replaceAll(' ', '').toLowerCase().trim();
  bool get tTrimIsEmpty => trim().isEmpty;
}

extension TurboFormObjectExtension on Object {
  E tAsType<E extends Object>() => this as E;
}

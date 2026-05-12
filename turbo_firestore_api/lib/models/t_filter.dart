import 'package:turbo_firestore_api/abstracts/i_filter.dart';

class TFilter<MODEL> {
  IFilter<MODEL> value;
  final dynamic input;

  TFilter({
    required this.value,
    required this.input,
  });
}

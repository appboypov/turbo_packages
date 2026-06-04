import 'package:turbo_firestore_api/abstracts/t_filter_option.dart';

class TFilterInput<MODEL, OPTION extends TFilterOption<MODEL>, INPUT> {
  final OPTION option;
  final INPUT? input;

  bool isMatch(MODEL model) => option.predicate(model, input);

  const TFilterInput.fromOption({
    required this.option,
  }) : input = null;

  const TFilterInput.fromOptionWithInput({
    required this.option,
    required this.input,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TFilterInput && other.option == option && other.input == input;

  @override
  int get hashCode => Object.hash(option, input);
}

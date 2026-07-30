import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_firestore_api/abstracts/t_filter_option.dart';
import 'package:turbo_firestore_api/abstracts/t_model.dart';
import 'package:turbo_firestore_api/models/t_filter_input.dart';
import 'package:turbo_firestore_api/typedefs/t_filter_predicate.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

class _Dto extends TWriteableId {
  const _Dto(this.estimate);

  final int estimate;

  @override
  String get id => 'id';

  @override
  Map<String, dynamic> toJson() => {'estimate': estimate};
}

class _Model extends TModel<_Dto> {
  const _Model(_Dto dto) : super(dto: dto);

  int get estimate => dto.estimate;
}

class _LowEstimateOption extends TFilterOption<_Model> {
  @override
  TFilterPredicate<_Model> get predicate =>
      (model, input) => input is int && model.estimate <= input;
}

void main() {
  group('TFilterInput.isMatch', () {
    // Filters are stored in a raw `Set<TFilterInput>`, erasing MODEL to dynamic
    // (exactly how TList holds them). The typed predicate must still run.
    final Set<TFilterInput> filters = {
      TFilterInput.fromOptionWithInput(option: _LowEstimateOption(), input: 5),
    };
    final filter = filters.first;

    test(
      'Given a typed predicate behind a raw filter set, when a matching model is tested, then it matches without a type error',
      () {
        expect(filter.isMatch(const _Model(_Dto(3))), isTrue);
      },
    );

    test(
      'Given a typed predicate behind a raw filter set, when a non-matching model is tested, then it does not match',
      () {
        expect(filter.isMatch(const _Model(_Dto(8))), isFalse);
      },
    );
  });
}

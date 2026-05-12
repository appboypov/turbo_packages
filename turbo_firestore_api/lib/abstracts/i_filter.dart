import 'package:turbo_firestore_api/abstracts/t_model.dart';
import 'package:turbo_firestore_api/models/t_filter.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

abstract interface class IFilter<MODEL> {
  bool filter<INPUT>({required MODEL model, INPUT? input});
}

extension IFilterExtension<DTO extends TWriteableId, MODEL extends TModel<DTO>> on IFilter<MODEL> {
  TFilter<MODEL> asFilter<INPUT>([INPUT? input]) => TFilter(value: this, input: input);

  TFilter<MODEL> withSet<INPUT>(Set<INPUT> input) => TFilter(value: this, input: input);
  TFilter<MODEL> withList<INPUT>(List<INPUT> input) => TFilter(value: this, input: input);

  TFilter<MODEL> withInt(int input) => TFilter(value: this, input: input);
  TFilter<MODEL> withDouble(double input) => TFilter(value: this, input: input);
  TFilter<MODEL> withString(String input) => TFilter(value: this, input: input);
}

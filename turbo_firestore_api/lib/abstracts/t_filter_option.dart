import 'package:turbo_firestore_api/typedefs/t_filter_predicate.dart';

abstract class TFilterOption<MODEL> {
  TFilterPredicate<MODEL> get predicate;
}

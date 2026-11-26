import 'package:turbo_collections/typedefs/t_filter_predicate.dart';

abstract class TFilterOption<MODEL> {
  TFilterPredicate<MODEL> get predicate;
}

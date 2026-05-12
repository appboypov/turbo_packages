import 'package:turbo_firestore_api/abstracts/t_model.dart';
import 'package:turbo_firestore_api/models/t_list.dart';
import 'package:turbo_serializable/abstracts/t_writeable_id.dart';

typedef TFilterPredicate<VALUE> = bool Function(VALUE value);
typedef TSortPredicate<VALUE> = int Function(VALUE a, VALUE b);

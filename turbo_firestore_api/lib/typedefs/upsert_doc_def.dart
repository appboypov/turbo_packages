import 'package:turbo_firestore_api/models/t_auth_vars.dart';

typedef UpsertDocDef<T> = T Function(T? current, TurboAuthVars vars);

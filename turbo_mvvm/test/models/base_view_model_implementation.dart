import 'package:turbo_mvvm/data/models/turbo_view_model.dart';
import 'package:turbo_mvvm/data/mixins/busy_management.dart';
import 'package:turbo_mvvm/data/mixins/error_management.dart';

class BaseViewModelImplementation<T> extends TurboViewModel<T>
    with ErrorManagement, BusyManagement {
  BaseViewModelImplementation({
    required bool isMock,
  }) : _isMock = isMock;

  final bool _isMock;
  late double stubbedTextScaleFactor;
  late double stubbedCurrentWidth;
  late double stubbedCurrentHeight;

  @override
  void rebuild() {
    if (!_isMock) {
      super.rebuild();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/utils/slidable_controller_box.dart';
import 'package:turbo_widgets/turbo_widgets.dart';
import 'package:veto/data/models/base_view_model.dart';

mixin SlidableManagement<T> on BaseViewModel<T> {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @override
  void dispose() {
    _slidableControllerBox.dispose();
    super.dispose();
  }

  // 👂 LISTENERS ----------------------------------------------------------------------------- \\
  // ⚡️ OVERRIDES ----------------------------------------------------------------------------- \\
  // 🎩 STATE --------------------------------------------------------------------------------- \\

  final _slidableControllerBox = SlidableControllerBox();

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\

  SlidableController slidableController(Object id) =>
      _slidableControllerBox.get(id, vsync: context!.vsync);

  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<void> toggleSlidable(Object id) async {
    final controller = slidableController(id);
    if (controller.ratio == 0) {
      await openSlidable(id);
    } else {
      await closeSlidable(id);
    }
  }

  Future<void> openSlidable(Object id) async => await slidableController(
    id,
  ).openEndActionPane(duration: TDurations.animation, curve: Curves.decelerate);

  Future<void> closeSlidable(Object id) async => await slidableController(id).close();
}

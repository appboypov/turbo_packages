import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:turbo_flutter_template/core/state/manage-state/abstracts/t_view_model.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/constants/t_durations.dart';
import 'package:turbo_flutter_template/core/ui/utils/slidable_controller_box.dart';

mixin SlidableManagement<T> on TViewModel<T> {
  // 📍 LOCATOR ------------------------------------------------------------------------------- \\
  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  @override
  Future<void> dispose() async {
    _slidableControllerBox.dispose();
    await super.dispose();
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

  Future<void> closeSlidable(Object id) async =>
      await slidableController(id).close();
}

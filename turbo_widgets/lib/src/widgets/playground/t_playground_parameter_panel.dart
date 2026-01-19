import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/models/playground/t_playground_parameters.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_parameter_field.dart';

/// Displays a panel containing form controls for all playground parameters.
///
/// Renders as a [ShadCard] with a title and vertical list of parameter fields.
class TPlaygroundParameterPanel extends StatelessWidget {
  const TPlaygroundParameterPanel({
    required this.parameters,
    super.key,
    this.title = 'Parameters',
  });

  /// The parameters to display.
  final TPlaygroundParameters parameters;

  /// The panel title.
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    if (parameters.isEmpty) {
      return const SizedBox.shrink();
    }

    return ShadCard(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.large.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ...parameters.parameters.map(
              (param) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TPlaygroundParameterField(parameter: param),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

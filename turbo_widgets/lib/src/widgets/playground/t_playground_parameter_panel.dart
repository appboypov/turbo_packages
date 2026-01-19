import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/models/playground/t_playground_parameter_model.dart';
import 'package:turbo_widgets/src/widgets/playground/t_playground_parameter_field.dart';

/// Displays a panel containing form controls for all playground parameters.
///
/// Auto-generates form fields based on the parameter model's type-specific maps.
/// Renders as a [ShadCard] with a title and vertical list of parameter fields.
class TPlaygroundParameterPanel extends StatelessWidget {
  const TPlaygroundParameterPanel({
    required this.model,
    this.onModelChanged,
    super.key,
    this.title = 'Parameters',
  });

  /// The parameter model containing all parameters organized by type.
  final TPlaygroundParameterModel model;

  /// Callback invoked when any parameter value changes.
  final ValueChanged<TPlaygroundParameterModel>? onModelChanged;

  /// The panel title.
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    if (model.isEmpty) {
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
            ..._buildFields(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFields() {
    final fields = <Widget>[];

    for (final entry in model.strings.entries) {
      fields.add(
        Padding(
          key: ValueKey('string_${entry.key}'),
          padding: const EdgeInsets.only(bottom: 12),
          child: TPlaygroundStringField(
            label: _formatLabel(entry.key),
            value: entry.value,
            onChanged: (value) => onModelChanged?.call(
              model.updateString(entry.key, value),
            ),
          ),
        ),
      );
    }

    for (final entry in model.textAreas.entries) {
      fields.add(
        Padding(
          key: ValueKey('textArea_${entry.key}'),
          padding: const EdgeInsets.only(bottom: 12),
          child: TPlaygroundTextAreaField(
            label: _formatLabel(entry.key),
            value: entry.value,
            onChanged: (value) => onModelChanged?.call(
              model.updateTextArea(entry.key, value),
            ),
          ),
        ),
      );
    }

    for (final entry in model.ints.entries) {
      fields.add(
        Padding(
          key: ValueKey('int_${entry.key}'),
          padding: const EdgeInsets.only(bottom: 12),
          child: TPlaygroundIntField(
            label: _formatLabel(entry.key),
            value: entry.value,
            onChanged: (value) => onModelChanged?.call(
              model.updateInt(entry.key, value),
            ),
          ),
        ),
      );
    }

    for (final entry in model.doubles.entries) {
      fields.add(
        Padding(
          key: ValueKey('double_${entry.key}'),
          padding: const EdgeInsets.only(bottom: 12),
          child: TPlaygroundDoubleField(
            label: _formatLabel(entry.key),
            value: entry.value,
            onChanged: (value) => onModelChanged?.call(
              model.updateDouble(entry.key, value),
            ),
          ),
        ),
      );
    }

    for (final entry in model.bools.entries) {
      fields.add(
        Padding(
          key: ValueKey('bool_${entry.key}'),
          padding: const EdgeInsets.only(bottom: 12),
          child: TPlaygroundBoolField(
            label: _formatLabel(entry.key),
            value: entry.value,
            onChanged: (value) => onModelChanged?.call(
              model.updateBool(entry.key, value),
            ),
          ),
        ),
      );
    }

    for (final entry in model.dateTimes.entries) {
      fields.add(
        Padding(
          key: ValueKey('dateTime_${entry.key}'),
          padding: const EdgeInsets.only(bottom: 12),
          child: TPlaygroundDateTimeField(
            label: _formatLabel(entry.key),
            value: entry.value,
            onChanged: (value) => onModelChanged?.call(
              model.updateDateTime(entry.key, value),
            ),
          ),
        ),
      );
    }

    for (final entry in model.dateRanges.entries) {
      fields.add(
        Padding(
          key: ValueKey('dateRange_${entry.key}'),
          padding: const EdgeInsets.only(bottom: 12),
          child: TPlaygroundDateRangeField(
            label: _formatLabel(entry.key),
            value: entry.value,
            onChanged: (value) => onModelChanged?.call(
              model.updateDateRange(entry.key, value),
            ),
          ),
        ),
      );
    }

    for (final entry in model.times.entries) {
      fields.add(
        Padding(
          key: ValueKey('time_${entry.key}'),
          padding: const EdgeInsets.only(bottom: 12),
          child: TPlaygroundTimeField(
            label: _formatLabel(entry.key),
            value: entry.value,
            onChanged: (value) => onModelChanged?.call(
              model.updateTime(entry.key, value),
            ),
          ),
        ),
      );
    }

    for (final entry in model.selects.entries) {
      fields.add(
        Padding(
          key: ValueKey('select_${entry.key}'),
          padding: const EdgeInsets.only(bottom: 12),
          child: TPlaygroundSelectField(
            label: _formatLabel(entry.key),
            selectOption: entry.value,
            onChanged: (value) => onModelChanged?.call(
              model.updateSelect(entry.key, value),
            ),
          ),
        ),
      );
    }

    return fields;
  }

  String _formatLabel(String key) {
    final words = key.split(RegExp(r'(?=[A-Z])|_'));
    return words
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ')
        .trim();
  }
}

import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/models/playground/t_playground_parameter.dart';

/// Renders a single parameter as a labeled form control.
///
/// Automatically selects the appropriate control based on the parameter type:
/// - If [TPlaygroundParameter.options] is non-null → [ShadSelect]
/// - If value is [bool] → [ShadSwitch]
/// - Otherwise → [ShadInput] (text field)
class TPlaygroundParameterField extends StatelessWidget {
  const TPlaygroundParameterField({
    required this.parameter,
    super.key,
  });

  final TPlaygroundParameter<dynamic> parameter;

  String _getOptionLabel(dynamic value) {
    if (parameter.optionLabel != null) {
      return parameter.optionLabel!(value);
    }
    if (value is Enum) {
      return value.name;
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ValueListenableBuilder<dynamic>(
      valueListenable: parameter.valueListenable,
      builder: (context, value, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              parameter.label,
              style: theme.textTheme.small.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildControl(context, value),
            if (parameter.description != null) ...[
              const SizedBox(height: 4),
              Text(
                parameter.description!,
                style: theme.textTheme.muted,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildControl(BuildContext context, dynamic value) {
    if (parameter.options != null) {
      return _buildSelectControl(value);
    }
    if (value is bool) {
      return _buildSwitchControl(value);
    }
    return _buildInputControl(value);
  }

  Widget _buildSelectControl(dynamic value) {
    final options = parameter.options!;
    return ShadSelect<dynamic>(
      initialValue: value,
      enabled: parameter.enabled,
      options: options
          .map(
            (option) => ShadOption(
              value: option,
              child: Text(_getOptionLabel(option)),
            ),
          )
          .toList(),
      selectedOptionBuilder: (context, selectedValue) {
        return Text(_getOptionLabel(selectedValue));
      },
      onChanged: parameter.enabled ? parameter.onChanged : null,
    );
  }

  Widget _buildSwitchControl(bool value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ShadSwitch(
        value: value,
        enabled: parameter.enabled,
        onChanged: parameter.enabled
            ? (newValue) => parameter.onChanged(newValue)
            : null,
      ),
    );
  }

  Widget _buildInputControl(dynamic value) {
    return ShadInput(
      key: ValueKey('${parameter.id}_input'),
      initialValue: value?.toString() ?? '',
      enabled: parameter.enabled,
      onChanged: parameter.enabled
          ? (newValue) => parameter.onChanged(newValue)
          : null,
    );
  }
}

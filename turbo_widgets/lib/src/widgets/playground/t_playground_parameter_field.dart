import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:turbo_widgets/src/models/playground/t_select_option.dart';

/// Base wrapper for playground parameter fields with consistent styling.
class _TPlaygroundFieldWrapper extends StatelessWidget {
  const _TPlaygroundFieldWrapper({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.small.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

/// Single-line text input field.
class TPlaygroundStringField extends StatelessWidget {
  const TPlaygroundStringField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _TPlaygroundFieldWrapper(
      label: label,
      child: ShadInput(
        initialValue: value,
        onChanged: onChanged,
      ),
    );
  }
}

/// Multi-line text area field.
class TPlaygroundTextAreaField extends StatelessWidget {
  const TPlaygroundTextAreaField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _TPlaygroundFieldWrapper(
      label: label,
      child: ShadTextarea(
        initialValue: value,
        onChanged: onChanged,
      ),
    );
  }
}

/// Integer input field.
class TPlaygroundIntField extends StatelessWidget {
  const TPlaygroundIntField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return _TPlaygroundFieldWrapper(
      label: label,
      child: ShadInput(
        initialValue: value.toString(),
        keyboardType: TextInputType.number,
        onChanged: (text) {
          final parsed = int.tryParse(text);
          if (parsed != null) {
            onChanged(parsed);
          }
        },
      ),
    );
  }
}

/// Double/slider field.
class TPlaygroundDoubleField extends StatelessWidget {
  const TPlaygroundDoubleField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    super.key,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return _TPlaygroundFieldWrapper(
      label: label,
      child: Row(
        children: [
          Expanded(
            child: ShadSlider(
              initialValue: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 48,
            child: Text(
              value.toStringAsFixed(1),
              style: theme.textTheme.muted,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

/// Boolean switch field.
class TPlaygroundBoolField extends StatelessWidget {
  const TPlaygroundBoolField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _TPlaygroundFieldWrapper(
      label: label,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ShadSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// DateTime picker field.
class TPlaygroundDateTimeField extends StatelessWidget {
  const TPlaygroundDateTimeField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return _TPlaygroundFieldWrapper(
      label: label,
      child: ShadDatePicker(
        selected: value,
        onChanged: (date) {
          if (date != null) {
            onChanged(date);
          }
        },
      ),
    );
  }
}

/// Date range picker field.
class TPlaygroundDateRangeField extends StatelessWidget {
  const TPlaygroundDateRangeField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final ShadDateTimeRange value;
  final ValueChanged<ShadDateTimeRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return _TPlaygroundFieldWrapper(
      label: label,
      child: ShadDatePicker.range(
        selected: value,
        onRangeChanged: (range) {
          if (range != null) {
            onChanged(range);
          }
        },
      ),
    );
  }
}

/// Time picker field.
class TPlaygroundTimeField extends StatelessWidget {
  const TPlaygroundTimeField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final ShadTimeOfDay value;
  final ValueChanged<ShadTimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    return _TPlaygroundFieldWrapper(
      label: label,
      child: ShadTimePicker(
        initialValue: value,
        onChanged: onChanged,
      ),
    );
  }
}

/// Select/dropdown field for enums and other options.
class TPlaygroundSelectField<T> extends StatelessWidget {
  const TPlaygroundSelectField({
    required this.label,
    required this.selectOption,
    required this.onChanged,
    super.key,
  });

  final String label;
  final TSelectOption<T> selectOption;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return _TPlaygroundFieldWrapper(
      label: label,
      child: ShadSelect<T>(
        initialValue: selectOption.value,
        options: selectOption.options
            .map(
              (option) => ShadOption(
                value: option,
                child: Text(selectOption.getLabel(option)),
              ),
            )
            .toList(),
        selectedOptionBuilder: (context, value) => Text(
          selectOption.getLabel(value),
        ),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

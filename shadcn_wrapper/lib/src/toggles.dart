import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({super.key, required this.checked, required this.onChanged, this.label, this.enabled = true});
  final bool checked;
  final ValueChanged<bool> onChanged;
  final String? label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): CheckboxState tri-state API.
    return shad.Checkbox(
      state: checked ? shad.CheckboxState.checked : shad.CheckboxState.unchecked,
      onChanged: enabled ? (s) => onChanged(s == shad.CheckboxState.checked) : null,
      trailing: label == null ? null : Text(label!),
    );
  }
}

class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, required this.onChanged, this.label, this.enabled = true});
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final bool enabled;

  @override
  Widget build(BuildContext context) => shad.Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        trailing: label == null ? null : Text(label!),
      );
}

class AppRadioOption<T> {
  const AppRadioOption({required this.value, required this.label});
  final T value;
  final String label;
}

class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({super.key, required this.options, required this.value, required this.onChanged, this.direction = Axis.vertical});
  final List<AppRadioOption<T>> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.RadioGroup<T>(
      value: value,
      onChanged: onChanged,
      child: Flex(
        direction: direction,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final o in options)
            Padding(
              padding: const EdgeInsets.all(4),
              child: shad.RadioItem<T>(value: o.value, trailing: Text(o.label)),
            ),
        ],
      ),
    );
  }
}

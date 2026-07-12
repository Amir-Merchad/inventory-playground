import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

class AppSelectItem<T> {
  const AppSelectItem({required this.value, required this.label, this.enabled = true});
  final T value;
  final String label;
  final bool enabled;
}

/// Dropdown select. For >20 items prefer AppSearchField + list (POS speed).
class AppSelect<T> extends StatelessWidget {
  const AppSelect({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.enabled = true,
  });

  final List<AppSelectItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? placeholder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): Select API is the most churn-prone in shadcn;
    // keep ALL usage behind this one class.
    return shad.Select<T>(
      value: value,
      onChanged: enabled ? onChanged : null,
      placeholder: placeholder == null ? null : Text(placeholder!),
      itemBuilder: (context, item) {
        final it = items.firstWhere((e) => e.value == item);
        return Text(it.label);
      },
      children: [
        for (final it in items)
          shad.SelectItemButton<T>(value: it.value, child: Text(it.label)),
      ],
    );
  }
}

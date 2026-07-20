import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

class AppSelectItem<T> {
  const AppSelectItem({
    required this.value,
    required this.label,
    this.enabled = true,
    this.leading,
  });

  final T value;
  final String label;
  final bool enabled;
  final Widget? leading;
}

AppSelectItem<T>? _find<T>(List<AppSelectItem<T>> items, T? value) {
  for (final i in items) {
    if (i.value == value) return i;
  }
  return null;
}

/// Single-value dropdown. Set [searchable] for long lists (categories,
/// warehouses, customers) — adds a type-to-filter box in the popup.
class AppSelect<T> extends StatelessWidget {
  const AppSelect({
    required this.items,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.enabled = true,
    this.searchable = false,
    this.searchPlaceholder,
    this.constraints,
    this.popupConstraints,
    super.key,
  });

  final List<AppSelectItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? placeholder;
  final bool enabled;
  final bool searchable;
  final String? searchPlaceholder;
  final BoxConstraints? constraints;
  final BoxConstraints? popupConstraints;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): Select + SelectPopup(items: SelectItemList).
    // SelectPopup is callable, so it satisfies SelectPopupBuilder directly.
    return shad.Select<T>(
      value: value,
      enabled: enabled,
      constraints: constraints,
      popupConstraints: popupConstraints ?? const BoxConstraints(maxHeight: 320),
      placeholder: placeholder == null ? null : Text(placeholder!),
      onChanged: enabled ? onChanged : null,
      itemBuilder: (context, selectedValue) =>
          Text(_find(items, selectedValue)?.label ?? ''),
      popup: shad.SelectPopup<T>(
        searchPlaceholder: searchable
            ? Text(searchPlaceholder ?? '')
            : null,
        items: shad.SelectItemList(
          children: [
            for (final item in items)
              shad.SelectItemButton<T>(
                value: item.value,
                enabled: item.enabled,
                child: item.leading == null
                    ? Text(item.label)
                    : Row(mainAxisSize: MainAxisSize.min, children: [
                        item.leading!,
                        const SizedBox(width: 8),
                        Text(item.label),
                      ]),
              ),
          ],
        ),
      ),
    );
  }
}

/// Multi-value dropdown; selected values render as removable chips inside
/// the field (tag filters, multi-branch reports, user roles).
class AppMultiSelect<T> extends StatelessWidget {
  const AppMultiSelect({
    required this.items,
    required this.values,
    required this.onChanged,
    this.placeholder,
    this.enabled = true,
    this.constraints,
    super.key,
  });

  final List<AppSelectItem<T>> items;
  final List<T> values;
  final ValueChanged<List<T>> onChanged;
  final String? placeholder;
  final bool enabled;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): MultiSelect + MultiSelectChip.
    return shad.MultiSelect<T>(
      value: values,
      enabled: enabled,
      constraints: constraints,
      placeholder: placeholder == null ? null : Text(placeholder!),
      onChanged: (v) => onChanged(v == null ? const [] : List<T>.of(v)),
      itemBuilder: (context, item) => shad.MultiSelectChip(
        value: item,
        child: Text(_find(items, item)?.label ?? '$item'),
      ),
      popup: shad.SelectPopup<T>(
        items: shad.SelectItemList(
          children: [
            for (final item in items)
              shad.SelectItemButton<T>(
                value: item.value,
                enabled: item.enabled,
                child: Text(item.label),
              ),
          ],
        ),
      ),
    );
  }
}

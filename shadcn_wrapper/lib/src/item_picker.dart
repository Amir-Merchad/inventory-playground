import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Grid/list picker in a dialog — pick a product variant, a table in the
/// floor plan, an icon or color for a category. Desktop gets a dialog;
/// same API works on tablets.
abstract final class AppItemPicker {
  /// Returns the picked item, or null when dismissed.
  /// ADAPTER (shadcn ^0.0.52): showItemPickerDialog + ItemList.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required Widget Function(BuildContext context, T item) itemBuilder,
    T? initialValue,
    bool grid = true,
  }) {
    return shad.showItemPickerDialog<T>(
      context,
      title: Text(title),
      items: shad.ItemList(items),
      initialValue: initialValue,
      layout: grid ? shad.ItemPickerLayout.grid : shad.ItemPickerLayout.list,
      builder: (context, item) => shad.ItemPickerOption<T>(
        value: item,
        child: itemBuilder(context, item),
      ),
    );
  }
}

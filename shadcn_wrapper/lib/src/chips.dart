import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Compact labeled token — active filters ("Category: Drinks ✕"), tags,
/// applied discounts on a cart line.
class AppChip extends StatelessWidget {
  const AppChip({super.key, required this.label, this.leading, this.onPressed, this.onDeleted});
  final String label;
  final Widget? leading;
  final VoidCallback? onPressed;

  /// Shows a trailing ✕.
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): Chip; delete = trailing ChipButton-like tap.
    return shad.Chip(
      leading: leading,
      trailing: onDeleted == null
          ? null
          : GestureDetector(
              onTap: onDeleted,
              child: const Icon(shad.LucideIcons.x, size: 12),
            ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

/// Single-select chip row (quick filters above lists: All / Low stock /
/// Expiring / Inactive). Fat targets, horizontal scroll on overflow.
class AppChoiceChips<T> extends StatelessWidget {
  const AppChoiceChips({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.labelBuilder,
  });
  final List<T> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final String Function(T)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final o in options) ...[
            shad.Chip(
              style: o == value ? const shad.ButtonStyle.primary() : const shad.ButtonStyle.outline(),
              onPressed: () => onChanged(o),
              child: Text(labelBuilder?.call(o) ?? '$o'),
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

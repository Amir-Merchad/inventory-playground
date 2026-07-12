import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'buttons.dart';

class AppBreadcrumb extends StatelessWidget {
  const AppBreadcrumb({super.key, required this.items, this.onTap});
  final List<String> items;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.Breadcrumb(
      separator: shad.Breadcrumb.arrowSeparator, // flips in RTL
      children: [
        for (var i = 0; i < items.length; i++)
          if (i == items.length - 1)
            Text(items[i])
          else
            AppButton(variant: AppButtonVariant.link, onPressed: onTap == null ? null : () => onTap!(i), child: Text(items[i])),
      ],
    );
  }
}

/// Simple pager for lists (20k items = always paged).
class AppPagination extends StatelessWidget {
  const AppPagination({super.key, required this.page, required this.totalPages, required this.onPage});
  final int page;          // 1-based
  final int totalPages;
  final ValueChanged<int> onPage;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.Pagination(
      page: page,
      totalPages: totalPages,
      onPageChanged: onPage,
      maxPages: 5,
    );
  }
}

/// Keyboard shortcut chip for the POS shortcut bar (F2 search, F10 pay...).
class AppKbd extends StatelessWidget {
  const AppKbd({super.key, required this.keyLabel, required this.action});
  final String keyLabel;
  final String action;

  @override
  Widget build(BuildContext context) {
    final theme = shad.Theme.of(context);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.border),
          borderRadius: BorderRadius.circular(4),
          color: theme.colorScheme.muted,
        ),
        child: Text(keyLabel).mono().xSmall(),
      ),
      const SizedBox(width: 6),
      Text(action).muted().xSmall(),
    ]);
  }
}

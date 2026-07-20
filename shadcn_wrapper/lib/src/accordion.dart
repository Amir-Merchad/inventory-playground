import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

class AppAccordionItem {
  const AppAccordionItem({required this.title, required this.content});
  final String title;
  final Widget content;
}

class AppAccordion extends StatelessWidget {
  const AppAccordion({super.key, required this.items});
  final List<AppAccordionItem> items;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.Accordion(
      items: [
        for (final i in items)
          shad.AccordionItem(trigger: shad.AccordionTrigger(child: Text(i.title)), content: i.content),
      ],
    );
  }
}

/// Single expand/collapse section ("Advanced options" on item editor,
/// per-order detail rows). Controlled: state lives in the caller.
class AppCollapsible extends StatelessWidget {
  const AppCollapsible({
    super.key,
    required this.header,
    required this.child,
    required this.expanded,
    required this.onChanged,
  });
  final Widget header;
  final Widget child;
  final bool expanded;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): Collapsible + trigger/content children.
    return shad.Collapsible(
      isExpanded: expanded,
      onExpansionChanged: onChanged,
      children: [
        shad.CollapsibleTrigger(child: header),
        shad.CollapsibleContent(child: child),
      ],
    );
  }
}

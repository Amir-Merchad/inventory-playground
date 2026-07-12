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

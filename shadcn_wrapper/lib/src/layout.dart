import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'tokens.dart';

/// Vertical/horizontal gaps from the token scale — never magic numbers.
class AppGap extends StatelessWidget {
  const AppGap.v(this.size, {super.key}) : horizontal = false;
  const AppGap.h(this.size, {super.key}) : horizontal = true;
  final double size;
  final bool horizontal;

  @override
  Widget build(BuildContext context) => SizedBox(width: horizontal ? size : 0, height: horizontal ? 0 : size);
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.vertical = false});
  final bool vertical;

  @override
  Widget build(BuildContext context) =>
      // ADAPTER (shadcn ^0.0.52).
      vertical ? const shad.VerticalDivider() : const shad.Divider();
}

/// Page scaffold: title row + actions + body, standard paddings.
/// (App-level navigation shell stays in the app; this is per-screen chrome.)
class AppPage extends StatelessWidget {
  const AppPage({super.key, required this.title, required this.body, this.actions = const [], this.breadcrumbOrSubtitle});
  final String title;
  final Widget body;
  final List<Widget> actions;
  final Widget? breadcrumbOrSubtitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: AppTokens.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title).h3(),
                  if (breadcrumbOrSubtitle != null) breadcrumbOrSubtitle!,
                ]),
              ),
              ...actions,
            ]),
            const AppGap.v(AppTokens.s4),
            Expanded(child: body),
          ],
        ),
      );
}

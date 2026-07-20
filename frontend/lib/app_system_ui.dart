import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

class AppSystemUi extends StatelessWidget {
  const AppSystemUi({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = shad.Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: const Color(0x00000000),
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,

        // Mainly affects iOS.
        statusBarBrightness: dark ? Brightness.dark : Brightness.light,

        systemNavigationBarColor: theme.colorScheme.background,

        systemNavigationBarIconBrightness: dark ? Brightness.light : Brightness.dark,

        systemNavigationBarDividerColor: theme.colorScheme.border,
      ),
      child: child,
    );
  }
}

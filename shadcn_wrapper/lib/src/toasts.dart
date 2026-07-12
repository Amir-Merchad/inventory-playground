import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'app_theme.dart';

enum AppToastKind { info, success, warning, error }

/// Non-blocking feedback. NEVER use a toast for money mistakes the cashier
/// must acknowledge — use AppDialog.confirm for those.
abstract final class AppToast {
  /// ADAPTER (shadcn ^0.0.52): showToast + SurfaceCard-based body.
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    AppToastKind kind = AppToastKind.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = AppTheme.semanticOf(context);
    final accent = switch (kind) {
      AppToastKind.success => colors.success,
      AppToastKind.warning => colors.warning,
      AppToastKind.error => colors.danger,
      AppToastKind.info => colors.info,
    };
    shad.showToast(
      context: context,
      showDuration: duration,
      builder: (context, overlay) => shad.SurfaceCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 4, height: 36, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) Text(title).semiBold(),
                  Text(message),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void success(BuildContext c, String m, {String? title}) => show(c, message: m, title: title, kind: AppToastKind.success);
  static void error(BuildContext c, String m, {String? title}) => show(c, message: m, title: title, kind: AppToastKind.error);
}

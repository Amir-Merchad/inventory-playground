import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'app_theme.dart';

enum AppToastKind { info, success, warning, error }

/// Where toasts appear. Desktop POS default: bottom-right (out of the way of
/// the cart); mobile: bottom-center above the thumb zone.
enum AppToastPosition { topStart, topCenter, topEnd, bottomStart, bottomCenter, bottomEnd }

/// Non-blocking feedback. NEVER use a toast for money mistakes the cashier
/// must acknowledge — use AppDialog.confirm for those.
abstract final class AppToast {
  /// ADAPTER (shadcn ^0.0.52): showToast + SurfaceCard-based body.
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    AppToastKind kind = AppToastKind.info,
    AppToastPosition position = AppToastPosition.bottomEnd,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
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
      location: switch (position) {
        AppToastPosition.topStart => shad.ToastLocation.topLeft,
        AppToastPosition.topCenter => shad.ToastLocation.topCenter,
        AppToastPosition.topEnd => shad.ToastLocation.topRight,
        AppToastPosition.bottomStart => shad.ToastLocation.bottomLeft,
        AppToastPosition.bottomCenter => shad.ToastLocation.bottomCenter,
        AppToastPosition.bottomEnd => shad.ToastLocation.bottomRight,
      },
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
              if (actionLabel != null) ...[
                const SizedBox(width: 16),
                shad.GhostButton(
                  onPressed: () {
                    overlay.close();
                    onAction?.call();
                  },
                  child: Text(actionLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static void success(BuildContext c, String m, {String? title}) => show(c, message: m, title: title, kind: AppToastKind.success);
  static void error(BuildContext c, String m, {String? title}) => show(c, message: m, title: title, kind: AppToastKind.error);
  static void warning(BuildContext c, String m, {String? title}) => show(c, message: m, title: title, kind: AppToastKind.warning);
  static void info(BuildContext c, String m, {String? title}) => show(c, message: m, title: title, kind: AppToastKind.info);
}

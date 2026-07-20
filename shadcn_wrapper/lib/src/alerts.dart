import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'app_theme.dart';

enum AppAlertKind { info, success, warning, danger }

/// Inline banner that stays until the condition clears — offline mode,
/// "prices need sync", "shift not closed yesterday", low-stock warnings.
/// Toasts vanish; alerts persist. Choose accordingly.
class AppAlert extends StatelessWidget {
  const AppAlert({
    super.key,
    required this.title,
    this.message,
    this.kind = AppAlertKind.info,
    this.icon,
    this.trailing,
  });
  final String title;
  final String? message;
  final AppAlertKind kind;

  /// Defaults to a semantic icon per [kind].
  final Widget? icon;

  /// Slot for an action (AppButton.ghost "Retry" / "Fix now").
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.semanticOf(context);
    // ADAPTER (shadcn ^0.0.52): Alert + LucideIcons defaults.
    final (accent, fallbackIcon) = switch (kind) {
      AppAlertKind.info => (colors.info, shad.LucideIcons.info),
      AppAlertKind.success => (colors.success, shad.LucideIcons.circleCheck),
      AppAlertKind.warning => (colors.warning, shad.LucideIcons.triangleAlert),
      AppAlertKind.danger => (colors.danger, shad.LucideIcons.circleAlert),
    };
    if (kind == AppAlertKind.danger) {
      return shad.Alert.destructive(
        leading: icon ?? Icon(fallbackIcon, size: 18),
        title: Text(title),
        content: message == null ? null : Text(message!),
        trailing: trailing,
      );
    }
    return shad.Alert(
      leading: icon ?? Icon(fallbackIcon, size: 18, color: accent),
      title: Text(title),
      content: message == null ? null : Text(message!),
      trailing: trailing,
    );
  }
}

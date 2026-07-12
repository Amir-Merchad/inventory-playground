import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'buttons.dart';

/// Modal dialogs. Keyboard-first: Enter=confirm, Esc=cancel (shadcn default).
abstract final class AppDialog {
  /// ADAPTER (shadcn ^0.0.52): showDialog + AlertDialog.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    Widget? content,
    List<Widget> actions = const [],
    bool dismissible = true,
  }) {
    return shad.showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => shad.AlertDialog(
        title: Text(title),
        content: content,
        actions: actions,
      ),
    );
  }

  /// Confirm pattern used for void/delete/close-shift. Returns true on confirm.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    required String confirmLabel,
    required String cancelLabel,
    bool destructive = false,
  }) async {
    final r = await show<bool>(
      context,
      title: title,
      content: message == null ? null : Text(message),
      actions: [
        AppButton.outline(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        AppButton(
          variant: destructive ? AppButtonVariant.destructive : AppButtonVariant.primary,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
    return r ?? false;
  }
}

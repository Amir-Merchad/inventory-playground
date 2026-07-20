import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

import 'buttons.dart';

/// Shared modal-dialog adapter.
///
/// Handles:
/// - Keyboard insets
/// - Small mobile screens
/// - Status-bar and navigation safe areas
/// - Scrollable content
abstract final class AppDialog {
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
      builder: (dialogContext) {
        final keyboardHeight = MediaQuery.viewInsetsOf(dialogContext).bottom;

        return SafeArea(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: shad.AlertDialog(
                  title: Text(title),
                  content: content,
                  actions: actions,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Fully custom dialog body (receipt preview, cash-drawer count grid).
  /// You own the surface; prefer [show] for standard title+actions dialogs.
  static Future<T?> custom<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool dismissible = true,
  }) {
    return shad.showDialog<T>(
      context: context,
      barrierDismissible: dismissible,
      builder: builder,
    );
  }

  /// Confirmation pattern for destructive or important actions.
  ///
  /// Returns `true` only when the user explicitly confirms.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    String? message,
    required String confirmLabel,
    required String cancelLabel,
    bool destructive = false,
  }) async {
    final result = await show<bool>(
      context,
      title: title,
      content: message == null ? null : Text(message),
      actions: [
        AppButton.outline(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
          child: Text(cancelLabel),
        ),
        AppButton(
          variant: destructive
              ? AppButtonVariant.destructive
              : AppButtonVariant.primary,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(true);
          },
          child: Text(confirmLabel),
        ),
      ],
    );

    return result ?? false;
  }
}

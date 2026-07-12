import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'buttons.dart';
import 'tokens.dart';
import 'layout.dart';

/// Friendly empty state with a next action — required by our design rules
/// (see docs/design/Claude_Design_Prompt.md output rule 4).
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });
  final String title;
  final String? message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[icon!, const AppGap.v(AppTokens.s3)],
        Text(title).semiBold(),
        if (message != null) ...[
          const AppGap.v(AppTokens.s1),
          Text(message!).muted().small(),
        ],
        if (actionLabel != null) ...[
          const AppGap.v(AppTokens.s4),
          AppButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ],
    ),
  );
}

/// Inline error state with retry (network hiccup on LAN).
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.title,
    this.message,
    this.retryLabel,
    this.onRetry,
  });
  final String title;
  final String? message;
  final String? retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = shad.Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(color: theme.colorScheme.destructive),
          ).semiBold(),
          if (message != null) ...[
            const AppGap.v(AppTokens.s1),
            Text(message!).muted().small(),
          ],
          if (retryLabel != null) ...[
            const AppGap.v(AppTokens.s4),
            AppButton.outline(onPressed: onRetry, child: Text(retryLabel!)),
          ],
        ],
      ),
    );
  }
}

/// Locked state for license/permission-gated features: subtle, never broken.
/// Use as FeatureGate.lockedChild. (Spec: lock hint + upgrade, no dead UI.)
class AppLockedState extends StatelessWidget {
  const AppLockedState({
    super.key,
    required this.featureName,
    required this.upgradeHint,
    this.onUpgradePressed,
    this.compact = false,
  });
  final String featureName;
  final String upgradeHint;
  final VoidCallback? onUpgradePressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = shad.Theme.of(context);
    final lock = Text('🔒');
    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          lock,
          const AppGap.h(AppTokens.s1),
          Text(featureName).muted().small(),
        ],
      );
    }
    return Center(
      child: shad.Card(
        padding: const EdgeInsets.all(AppTokens.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            lock,
            const AppGap.v(AppTokens.s2),
            Text(featureName).semiBold(),
            const AppGap.v(AppTokens.s1),
            Text(
              upgradeHint,
              style: TextStyle(color: theme.colorScheme.mutedForeground),
            ).small(),
            if (onUpgradePressed != null) ...[
              const AppGap.v(AppTokens.s4),
              AppButton.outline(
                onPressed: onUpgradePressed,
                child: Text(upgradeHint),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

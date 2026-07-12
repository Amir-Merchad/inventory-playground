import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'tokens.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, destructive, link }
enum AppButtonSize { normal, large, icon }

/// The only button feature code uses. Cashier-facing screens pass
/// [size]=large (56px) — see AppTokens.hitTargetLarge.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.normal,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.tooltip,
  });

  const AppButton.destructive({super.key, required this.child, this.onPressed, this.leading, this.trailing, this.enabled = true, this.tooltip, this.size = AppButtonSize.normal})
      : variant = AppButtonVariant.destructive;
  const AppButton.outline({super.key, required this.child, this.onPressed, this.leading, this.trailing, this.enabled = true, this.tooltip, this.size = AppButtonSize.normal})
      : variant = AppButtonVariant.outline;
  const AppButton.ghost({super.key, required this.child, this.onPressed, this.leading, this.trailing, this.enabled = true, this.tooltip, this.size = AppButtonSize.normal})
      : variant = AppButtonVariant.ghost;

  final Widget child;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final press = enabled ? onPressed : null;
    // ADAPTER (shadcn ^0.0.52): variant widgets. Fix here on upgrade.
    Widget button = switch (variant) {
      AppButtonVariant.primary => shad.PrimaryButton(onPressed: press, leading: leading, trailing: trailing, child: child),
      AppButtonVariant.secondary => shad.SecondaryButton(onPressed: press, leading: leading, trailing: trailing, child: child),
      AppButtonVariant.outline => shad.OutlineButton(onPressed: press, leading: leading, trailing: trailing, child: child),
      AppButtonVariant.ghost => shad.GhostButton(onPressed: press, leading: leading, trailing: trailing, child: child),
      AppButtonVariant.destructive => shad.DestructiveButton(onPressed: press, leading: leading, trailing: trailing, child: child),
      AppButtonVariant.link => shad.LinkButton(onPressed: press, leading: leading, trailing: trailing, child: child),
    };
    final minSide = switch (size) {
      AppButtonSize.large => AppTokens.hitTargetLarge,
      _ => AppTokens.hitTarget,
    };
    button = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minSide, minWidth: size == AppButtonSize.icon ? minSide : 0),
      child: button,
    );
    if (tooltip != null) {
      button = shad.Tooltip(tooltip: shad.TooltipContainer(child: Text(tooltip!)), child: button);
    }
    return button;
  }
}

/// Icon-only button with guaranteed hit target.
class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key, required this.icon, this.onPressed, this.variant = AppButtonVariant.ghost, this.tooltip});
  final Widget icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final String? tooltip;

  @override
  Widget build(BuildContext context) =>
      AppButton(variant: variant, size: AppButtonSize.icon, onPressed: onPressed, tooltip: tooltip, child: icon);
}

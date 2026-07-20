import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'tokens.dart';

/// Standard surface. Subtle border, soft radius — shadcn card language.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding = AppTokens.cardPadding, this.onPressed});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    final card = shad.Card(padding: padding, child: child);
    if (onPressed == null) return card;
    return shad.Clickable(onPressed: onPressed, child: card);
  }
}

/// Image-first card (product grid on POS sell screen, catalog browser).
/// Desktop: hover scale feedback; touch: plain press.
class AppImageCard extends StatelessWidget {
  const AppImageCard({
    super.key,
    required this.image,
    this.title,
    this.subtitle,
    this.trailing,
    this.onPressed,
    this.enabled = true,
  });
  final Widget image;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): CardImage.
    return shad.CardImage(
      image: image,
      title: title == null ? null : Text(title!),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing,
      onPressed: onPressed,
      enabled: enabled,
    );
  }
}

/// Titled section used on settings/report pages.
class AppSection extends StatelessWidget {
  const AppSection({super.key, required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [Expanded(child: Text(title).semiBold()), if (trailing != null) trailing!]),
            const SizedBox(height: AppTokens.s3),
            child,
          ],
        ),
      );
}

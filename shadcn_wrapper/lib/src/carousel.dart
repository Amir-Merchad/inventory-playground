import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Swipeable/auto-playing carousel — product image gallery in the item
/// editor, promo banners on a customer-facing display.
/// Give it a bounded size (SizedBox/AspectRatio) — it fills its parent.
class AppCarousel extends StatefulWidget {
  const AppCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.autoplay,
    this.fade = false,
    this.showDots = true,
    this.onIndexChanged,
  });
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Interval between auto-advances; null = manual only.
  final Duration? autoplay;

  /// Fade between items instead of sliding (nice for promo screens).
  final bool fade;
  final bool showDots;
  final ValueChanged<int>? onIndexChanged;

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): Carousel + CarouselTransition + DotIndicator.
    return Column(
      children: [
        Expanded(
          child: shad.Carousel(
            itemCount: widget.itemCount,
            autoplaySpeed: widget.autoplay,
            transition: widget.fade
                ? shad.CarouselTransition.fading()
                : shad.CarouselTransition.sliding(gap: 12),
            onIndexChanged: (i) {
              final n = widget.itemCount == 0 ? 0 : i % widget.itemCount;
              if (n != _index) {
                setState(() => _index = n);
                widget.onIndexChanged?.call(n);
              }
            },
            itemBuilder: (context, i) => widget.itemBuilder(context, i),
          ),
        ),
        if (widget.showDots && widget.itemCount > 1) ...[
          const SizedBox(height: 8),
          shad.DotIndicator(index: _index, length: widget.itemCount),
        ],
      ],
    );
  }
}

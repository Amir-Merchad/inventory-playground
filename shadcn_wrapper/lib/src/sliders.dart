import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Single-value slider (discount %, brightness of customer display).
/// For precise money values prefer AppNumberField — sliders are for feel.
class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.enabled = true,
    this.onChangeEnd,
  });
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final bool enabled;
  final ValueChanged<double>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): SliderValue.single.
    return shad.Slider(
      value: shad.SliderValue.single(value.clamp(min, max)),
      min: min,
      max: max,
      divisions: divisions,
      enabled: enabled,
      onChanged: (v) => onChanged(v.value),
      onChangeEnd: onChangeEnd == null ? null : (v) => onChangeEnd!(v.value),
    );
  }
}

/// Range slider (price range filter in the product browser).
class AppRangeSlider extends StatelessWidget {
  const AppRangeSlider({
    super.key,
    required this.start,
    required this.end,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.enabled = true,
  });
  final double start;
  final double end;
  final void Function(double start, double end) onChanged;
  final double min;
  final double max;
  final int? divisions;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): SliderValue.ranged.
    return shad.Slider(
      value: shad.SliderValue.ranged(start.clamp(min, max), end.clamp(min, max)),
      min: min,
      max: max,
      divisions: divisions,
      enabled: enabled,
      onChanged: (v) => onChanged(v.start, v.end),
    );
  }
}

/// Star rating — supplier score, product review display. [readOnly] renders
/// a static display (reports); otherwise half-star steps by default.
class AppStarRating extends StatelessWidget {
  const AppStarRating({
    super.key,
    required this.value,
    this.onChanged,
    this.max = 5,
    this.step = 0.5,
    this.size,
    this.readOnly = false,
  });
  final double value;
  final ValueChanged<double>? onChanged;
  final double max;
  final double step;
  final double? size;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.StarRating(
      value: value,
      max: max,
      step: step,
      starSize: size,
      enabled: !readOnly && onChanged != null,
      onChanged: readOnly ? null : onChanged,
    );
  }
}

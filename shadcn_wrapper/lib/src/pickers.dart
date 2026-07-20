import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Date picker field (reports range, expiry dates). Calendar output is a
/// DateTime — formatting/locale is the APP's job (intl), not the wrapper's.
class AppDatePickerField extends StatelessWidget {
  const AppDatePickerField({super.key, required this.value, required this.onChanged, this.placeholder, this.enabled = true});
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? placeholder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.DatePicker(
      value: value,
      onChanged: onChanged,
      enabled: enabled,
      placeholder: placeholder == null ? null : Text(placeholder!),
    );
  }
}

/// Date-range picker for reports (from–to).
class AppDateRangePickerField extends StatelessWidget {
  const AppDateRangePickerField({super.key, required this.start, required this.end, required this.onChanged, this.placeholder});
  final DateTime? start;
  final DateTime? end;
  final void Function(DateTime? start, DateTime? end) onChanged;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): DateRangePicker uses a DateTimeRange-like value.
    return shad.DateRangePicker(
      value: (start != null && end != null) ? shad.DateTimeRange(start!, end!) : null,
      onChanged: (r) => onChanged(r?.start, r?.end),
      placeholder: placeholder == null ? null : Text(placeholder!),
    );
  }
}

/// Time value without pulling in Material's TimeOfDay (shadcn has its own —
/// the wrapper exposes neither, so the seam stays clean).
typedef AppTime = ({int hour, int minute});

/// Time picker field (shift start, delivery slots, happy-hour pricing).
class AppTimePickerField extends StatelessWidget {
  const AppTimePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.use24HourFormat,
    this.enabled = true,
  });
  final AppTime? value;
  final ValueChanged<AppTime?> onChanged;
  final String? placeholder;
  final bool? use24HourFormat;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): shadcn defines its own TimeOfDay.
    return shad.TimePicker(
      value: value == null ? null : shad.TimeOfDay(hour: value!.hour, minute: value!.minute),
      onChanged: (t) => onChanged(t == null ? null : (hour: t.hour, minute: t.minute)),
      enabled: enabled,
      use24HourFormat: use24HourFormat,
      placeholder: placeholder == null ? null : Text(placeholder!),
    );
  }
}

/// Inline month calendar — dashboards ("sales by day"), delivery planning.
/// Single date or range via [rangeStart]/[rangeEnd] + [onRangeChanged].
class AppCalendar extends StatelessWidget {
  const AppCalendar.single({
    super.key,
    required DateTime? this.value,
    required ValueChanged<DateTime?> this.onChanged,
    this.month,
  })  : rangeStart = null,
        rangeEnd = null,
        onRangeChanged = null;

  const AppCalendar.range({
    super.key,
    required this.rangeStart,
    required this.rangeEnd,
    required void Function(DateTime? start, DateTime? end) this.onRangeChanged,
    this.month,
  })  : value = null,
        onChanged = null;

  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final void Function(DateTime? start, DateTime? end)? onRangeChanged;

  /// Which month to show; defaults to now (or the selected value's month).
  final DateTime? month;

  @override
  Widget build(BuildContext context) {
    final isRange = onRangeChanged != null;
    final anchor = month ?? value ?? rangeStart ?? DateTime.now();
    // ADAPTER (shadcn ^0.0.52): Calendar + CalendarValue static factories.
    return shad.Calendar(
      view: shad.CalendarView.fromDateTime(anchor),
      selectionMode: isRange ? shad.CalendarSelectionMode.range : shad.CalendarSelectionMode.single,
      value: isRange
          ? ((rangeStart != null && rangeEnd != null) ? shad.CalendarValue.range(rangeStart!, rangeEnd!) : (rangeStart != null ? shad.CalendarValue.single(rangeStart!) : null))
          : (value == null ? null : shad.CalendarValue.single(value!)),
      onChanged: (v) {
        if (isRange) {
          final r = v?.toRange();
          onRangeChanged!(r?.start, r?.end);
        } else {
          onChanged!(v?.toSingle().date);
        }
      },
    );
  }
}

/// Inline color picker panel (label colors, category colors, receipt accents).
class AppColorPicker extends StatelessWidget {
  const AppColorPicker({super.key, required this.value, required this.onChanged, this.showAlpha = false});
  final Color value;
  final ValueChanged<Color> onChanged;
  final bool showAlpha;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): ColorPicker speaks ColorDerivative.
    return shad.ColorPicker(
      value: shad.ColorDerivative.fromColor(value),
      showAlpha: showAlpha,
      onChanged: (c) => onChanged(c.toColor()),
    );
  }
}

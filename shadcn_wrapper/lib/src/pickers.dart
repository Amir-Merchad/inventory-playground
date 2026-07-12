import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Date picker field (reports range, expiry dates). Calendar output is a
/// DateTime — formatting/locale is the APP's job (intl), not the wrapper's.
class AppDatePickerField extends StatelessWidget {
  const AppDatePickerField({super.key, required this.value, required this.onChanged, this.placeholder});
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.DatePicker(
      value: value,
      onChanged: onChanged,
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

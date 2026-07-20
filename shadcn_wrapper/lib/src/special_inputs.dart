import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// PIN / OTP boxes — manager-override PIN, register unlock, 2FA codes.
/// [groupSize] draws a separator every N boxes (e.g. 3 for 123-456).
class AppOtpField extends StatelessWidget {
  const AppOtpField({
    super.key,
    required this.length,
    this.onChanged,
    this.onCompleted,
    this.obscured = false,
    this.digitsOnly = true,
    this.groupSize,
  });
  final int length;
  final ValueChanged<String>? onChanged;

  /// Fires on submit with the full code.
  final ValueChanged<String>? onCompleted;
  final bool obscured;
  final bool digitsOnly;
  final int? groupSize;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): InputOTP + character children + otpToString.
    return shad.InputOTP(
      onChanged: onChanged == null ? null : (v) => onChanged!(v.otpToString()),
      onSubmitted: onCompleted == null ? null : (v) => onCompleted!(v.otpToString()),
      children: [
        for (var i = 0; i < length; i++) ...[
          if (groupSize != null && i > 0 && i % groupSize! == 0) shad.InputOTPChild.separator,
          shad.InputOTPChild.character(
            allowDigit: true,
            allowLowercaseAlphabet: !digitsOnly,
            allowUppercaseAlphabet: !digitsOnly,
            obscured: obscured,
          ),
        ],
      ],
    );
  }
}

/// International phone field with country picker (customer profiles,
/// delivery contacts). Emits the full +XXX number, or null while invalid.
class AppPhoneField extends StatelessWidget {
  const AppPhoneField({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): PhoneNumber.value = validated full number.
    return shad.PhoneInput(
      onChanged: (p) => onChanged(p?.value),
    );
  }
}

/// Free-form tags editor (product tags, customer labels). Type, press Enter,
/// get a chip; backspace deletes. Pass [suggestions] for autocomplete.
class AppTagsInput extends StatefulWidget {
  const AppTagsInput({
    super.key,
    required this.tags,
    required this.onChanged,
    this.placeholder,
    this.suggestions = const [],
  });
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  final String? placeholder;
  final List<String> suggestions;

  @override
  State<AppTagsInput> createState() => _AppTagsInputState();
}

class _AppTagsInputState extends State<AppTagsInput> {
  late final shad.ChipEditingController<String> _controller;
  List<String> _currentSuggestions = [];

  @override
  void initState() {
    super.initState();
    // ADAPTER (shadcn ^0.0.52): seed chips via the controller (docs pattern).
    _controller = shad.ChipEditingController(initialChips: widget.tags);
    _controller.addListener(_recompute);
  }

  void _recompute() {
    final q = _controller.textAtCursor;
    setState(() {
      _currentSuggestions = q.isEmpty
          ? []
          : widget.suggestions.where((s) => s.toLowerCase().startsWith(q.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): ChipInput + AutoComplete, per docs example.
    return shad.AutoComplete(
      suggestions: _currentSuggestions,
      child: shad.ChipInput<String>(
        controller: _controller,
        placeholder: widget.placeholder == null ? null : Text(widget.placeholder!),
        onChipsChanged: widget.onChanged,
        onChipSubmitted: (text) => text.trim(),
        chipBuilder: (context, chip) => shad.Chip(child: Text(chip)),
      ),
    );
  }
}

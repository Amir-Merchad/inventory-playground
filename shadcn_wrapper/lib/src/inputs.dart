import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Text input. RTL-safe (direction from ambient Directionality).
/// Multi-line text area.
class AppTextArea extends StatelessWidget {
  const AppTextArea({
    super.key,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.minLines = 3,
    this.maxLines = 6,
    this.enabled = true,
  });
  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final int minLines;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) => AppTextField(
    controller: controller,
    placeholder: placeholder,
    onChanged: onChanged,
    enabled: enabled,
    maxLines: maxLines,
  );
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.obscure = false,
    this.autofocus = false,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.leading,
    this.trailing,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool obscure;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? leading;
  final Widget? trailing;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return shad.TextField(
      controller: controller,
      placeholder: placeholder == null ? null : Text(placeholder!),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      obscureText: obscure,
      autofocus: autofocus,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      features: [
        if (leading != null) shad.InputFeature.leading(leading!),
        if (trailing != null) shad.InputFeature.trailing(trailing!),
      ],
    );
  }
}

/// Numeric field for qty/price (locale-agnostic Latin digits, POS convention).
class AppNumberField extends StatelessWidget {
  const AppNumberField({
    super.key,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.decimal = true,
    this.enabled = true,
    this.autofocus = false,
  });
  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final bool decimal;
  final bool enabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => AppTextField(
    controller: controller,
    placeholder: placeholder,
    onChanged: onChanged,
    enabled: enabled,
    autofocus: autofocus,
    keyboardType: TextInputType.numberWithOptions(decimal: decimal),
    inputFormatters: [
      FilteringTextInputFormatter.allow(
        RegExp(decimal ? r'[0-9.,]' : r'[0-9]'),
      ),
    ],
  );
}

/// Search-as-you-type field (item lookup, customers). Keep focus behavior
/// consistent app-wide (barcode scanner steals focus elsewhere).
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.leading,
    this.trailing,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final Widget? leading;
  final Widget? trailing;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      placeholder: placeholder,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      focusNode: focusNode,
      leading: leading,
      trailing: trailing,
    );
  }
}

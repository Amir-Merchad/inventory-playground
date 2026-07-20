import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Single-line text input. RTL-safe (direction from ambient Directionality).
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.enabled = true,
    this.readOnly = false,
    this.obscure = false,
    this.autofocus = false,
    this.clearable = false,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.leading,
    this.trailing,
    this.maxLines = 1,
    this.maxLength,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final bool enabled;
  final bool readOnly;
  final bool obscure;
  final bool autofocus;

  /// Shows an inline ✕ that clears the field (filters, search boxes).
  final bool clearable;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? leading;
  final Widget? trailing;
  final int maxLines;
  final int? maxLength;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): TextField + InputFeature list.
    return shad.TextField(
      controller: controller,
      initialValue: initialValue,
      placeholder: placeholder == null ? null : Text(placeholder!),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscure,
      autofocus: autofocus,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      textAlign: textAlign,
      features: [
        if (leading != null) shad.InputFeature.leading(leading!),
        if (trailing != null) shad.InputFeature.trailing(trailing!),
        if (clearable) shad.InputFeature.clear(),
      ],
    );
  }
}

/// Multi-line text area (notes on invoices, product descriptions).
/// Desktop nicety: user can drag the bottom edge when [expandable].
class AppTextArea extends StatelessWidget {
  const AppTextArea({
    super.key,
    this.controller,
    this.initialValue,
    this.placeholder,
    this.onChanged,
    this.height = 96,
    this.expandable = true,
    this.enabled = true,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final double height;
  final bool expandable;
  final bool enabled;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): TextArea with drag-to-resize height.
    return shad.TextArea(
      controller: controller,
      initialValue: initialValue,
      placeholder: placeholder == null ? null : Text(placeholder!),
      onChanged: onChanged,
      enabled: enabled,
      focusNode: focusNode,
      initialHeight: height,
      expandableHeight: expandable,
    );
  }
}

/// Numeric field for qty/price (locale-agnostic Latin digits, POS convention).
/// [stepButtons] adds +/- increment buttons and mouse-wheel stepping —
/// good for quantity cells on desktop.
class AppNumberField extends StatelessWidget {
  const AppNumberField({
    super.key,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.decimal = true,
    this.enabled = true,
    this.autofocus = false,
    this.stepButtons = false,
    this.step = 1,
    this.min,
    this.max,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool decimal;
  final bool enabled;
  final bool autofocus;
  final bool stepButtons;
  final double step;
  final double? min;
  final double? max;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): numeric affordances are InputFeatures.
    return shad.TextField(
      controller: controller,
      placeholder: placeholder == null ? null : Text(placeholder!),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(decimal ? r'[0-9.,\-]' : r'[0-9\-]'),
        ),
      ],
      features: [
        if (stepButtons) ...[
          shad.InputFeature.decrementButton(step: step, min: min, max: max),
          shad.InputFeature.incrementButton(step: step, min: min, max: max),
          shad.InputFeature.spinner(step: step, min: min, max: max),
        ],
      ],
    );
  }
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
    this.showSearchIcon = true,
    this.clearable = true,
    this.leading,
    this.trailing,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final bool showSearchIcon;
  final bool clearable;
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
      clearable: clearable,
      // ADAPTER (shadcn ^0.0.52): LucideIcons ships with shadcn_flutter.
      leading:
          leading ??
          (showSearchIcon
              ? const Icon(shad.LucideIcons.search, size: 16)
              : null),
      trailing: trailing,
    );
  }
}

/// Inline autocomplete on top of any text field — SKU / customer / brand
/// lookups. Pass current [suggestions] (recompute in onChanged upstream).
class AppAutoCompleteField extends StatelessWidget {
  const AppAutoCompleteField({
    super.key,
    required this.suggestions,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  final List<String> suggestions;
  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): AutoComplete wraps the editable child.
    return shad.AutoComplete(
      suggestions: suggestions,
      child: AppTextField(
        controller: controller,
        placeholder: placeholder,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        focusNode: focusNode,
        autofocus: autofocus,
      ),
    );
  }
}

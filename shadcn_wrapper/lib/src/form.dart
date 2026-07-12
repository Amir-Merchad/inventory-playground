import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'tokens.dart';

/// Label + control + error line. Keeps every form in every project identical.
/// Works in RTL out of the box (start-aligned label).
class AppFormField extends StatelessWidget {
  const AppFormField({super.key, required this.label, required this.child, this.error, this.hint, this.required = false});
  final String label;
  final Widget child;
  final String? error;
  final String? hint;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = shad.Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label).small().semiBold(),
          if (required) Text(' *', style: TextStyle(color: theme.colorScheme.destructive)).small(),
        ]),
        const SizedBox(height: AppTokens.s1),
        child,
        if (hint != null && error == null) ...[
          const SizedBox(height: AppTokens.s1),
          Text(hint!).muted().xSmall(),
        ],
        if (error != null) ...[
          const SizedBox(height: AppTokens.s1),
          Text(error!, style: TextStyle(color: theme.colorScheme.destructive)).xSmall(),
        ],
      ],
    );
  }
}

/// Two-language name editor row (name + name_i18n languages) — the standard
/// pattern for this product family; generic enough to reuse.
class AppI18nNameFields extends StatelessWidget {
  const AppI18nNameFields({
    super.key,
    required this.languages,     // e.g. ['en','ar'] from app settings
    required this.values,        // langCode -> current value
    required this.onChanged,     // (langCode, value)
    required this.labelBuilder,  // localized label per language code
  });
  final List<String> languages;
  final Map<String, String> values;
  final void Function(String lang, String value) onChanged;
  final String Function(String lang) labelBuilder;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final lang in languages)
            Padding(
              padding: const EdgeInsets.only(bottom: AppTokens.s3),
              child: AppFormField(
                label: labelBuilder(lang),
                child: Directionality(
                  // Arabic value field edits RTL even inside an LTR app shell
                  textDirection: (lang == 'ar' || lang == 'fa' || lang == 'ur') ? TextDirection.rtl : TextDirection.ltr,
                  child: shad.TextField(
                    initialValue: values[lang] ?? '',
                    onChanged: (v) => onChanged(lang, v),
                  ),
                ),
              ),
            ),
        ],
      );
}

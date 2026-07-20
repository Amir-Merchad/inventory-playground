import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Icon set for feature code — keeps the "never import shadcn_flutter"
/// rule while using its bundled Lucide set.
///
/// Usage: `Icon(AppIcons.search, size: 16)`.
///
/// ADAPTER (shadcn ^0.0.52): alias of LucideIcons. If shadcn is ever
/// replaced, point this at any IconData set with the same names or migrate
/// call sites mechanically.
typedef AppIcons = shad.LucideIcons;

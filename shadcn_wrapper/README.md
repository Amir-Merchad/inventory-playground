# shadcn_wrapper

The **only** place this codebase (and your future projects) touches
`shadcn_flutter`. Copy this folder into any project, `flutter pub add` nothing —
just a path dependency — and build UIs against the stable `App*` API.

## Why
`shadcn_flutter` is pre-1.0 (0.0.x): the look is right, the API churns.
Every widget here is a thin adapter: **public API = ours (stable)**,
**implementation = theirs (swappable)**. If an upgrade breaks a constructor,
you fix one `src/*.dart` file. If shadcn dies, you rebuild adapters on
Material 3 / forui without touching feature code.

## Rules
1. Feature code NEVER imports `package:shadcn_flutter/...` — only
   `package:shadcn_wrapper/shadcn_wrapper.dart`. (Lint idea: add a custom
   `import_lint` rule or grep in CI.)
2. New shadcn widget needed? Add an adapter here first, then use it.
3. Keep adapters thin — no business logic, no app-specific strings.
4. Theming flows from `AppTheme` (tokens in `AppTokens`) so every project
   restyles by editing one file. Dark mode + RTL supported by construction.

## Contents
- `app_theme.dart` / `tokens.dart` — ShadcnApp theme builder + design tokens
  (spacing, radius, 44px POS hit targets, durations, semantic colors).
- Adapters by family: buttons, inputs, selects, toggles, dialogs, sheets,
  toasts, cards, tabs, data table, badges, avatars, accordion,
  popover/tooltip, progress/skeleton, date-time pickers, form scaffolding,
  navigation bits (breadcrumb/pagination), layout helpers, empty/locked states.

## Version note
Adapters target `shadcn_flutter ^0.0.52`. On upgrade: `flutter analyze` this
package first; fix signatures HERE. The app compiles against `App*` only.

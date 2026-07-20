# shadcn_wrapper

The **only** place this codebase (and your future projects) touches
`shadcn_flutter`. Copy this folder into any project as a path dependency and
build UIs against the stable `App*` API.

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
5. State-out widgets: controlled components (tabs, tree, stepper, sort)
   emit new state; owning it is the caller's job (bloc/cubit).

## Catalog (desktop-first POS/ERP)

### Foundation
- `tokens.dart` — spacing/radius scale, 44/56px hit targets, motion, layout.
- `app_theme.dart` — ShadcnApp ThemeData builder + `AppSemanticColors`
  (success/warning/danger/info/money±).

### Actions & inputs
- `buttons.dart` — `AppButton` (primary/secondary/outline/ghost/destructive/
  link, normal/large/icon sizes, tooltip), `AppIconButton`.
- `inputs.dart` — `AppTextField` (clearable, leading/trailing, readOnly),
  `AppTextArea` (drag-resize), `AppNumberField` (qty/price, ± step buttons),
  `AppSearchField`, `AppAutoCompleteField` (SKU/customer lookup).
- `special_inputs.dart` — `AppOtpField` (manager PIN), `AppPhoneField`,
  `AppTagsInput` (chips + autocomplete).
- `selects.dart` — `AppSelect` (searchable popup for long lists),
  `AppMultiSelect` (chips-in-field).
- `toggles.dart` — `AppCheckbox`, `AppSwitch`, `AppToggle` (pressed button),
  `AppRadioGroup`, `AppRadioCards` (payment method / order type cards).
- `sliders.dart` — `AppSlider`, `AppRangeSlider` (price filter),
  `AppStarRating`.
- `pickers.dart` — `AppDatePickerField`, `AppDateRangePickerField`,
  `AppTimePickerField`, `AppCalendar` (inline), `AppColorPicker`.
- `form.dart` — `AppFormField` (label+error+hint), `AppLabeledRow`
  (desktop settings rows), `AppI18nNameFields`.
- `chips.dart` — `AppChip` (deletable filter token), `AppChoiceChips`.

### Overlays & feedback
- `dialogs.dart` — `AppDialog.show/confirm/custom` (keyboard-safe, scrollable).
- `sheets.dart` — `AppSheet.open/openEnd` (RTL-aware), `AppDrawer.open/close`
  (mobile drag-handle drawers).
- `toasts.dart` — `AppToast.show/success/error/warning/info` + position +
  action button. Never for money mistakes — use dialogs.
- `alerts.dart` — `AppAlert` persistent banners (offline, sync pending).
- `popover.dart` — `AppTooltip` (with shortcut hint), `AppPopover`,
  `AppHoverCard` (hover preview, desktop).
- `progress.dart` — `AppProgressBar` (0..1), `AppSpinner`, `AppSkeleton`.
- `command.dart` — `AppCommandPalette.show` (Ctrl+K palette).
- `menus.dart` — one `AppMenuEntry` model → `AppContextMenuRegion`
  (right-click rows), `AppDropdownMenuButton` (⋯ actions), `AppMenubar`
  (File/Edit/View).
- `item_picker.dart` — `AppItemPicker.show` grid/list picker dialog
  (variants, floor tables, icons).

### Data display
- `cards.dart` — `AppCard`, `AppImageCard` (product grid), `AppSection`.
- `badges.dart` — `AppBadge` (+success/warning), `AppCountBadge` (cart n),
  `AppStatusDot`.
- `avatars.dart` — `AppAvatar`; `display.dart` has `AppAvatarGroup`.
- `data_table.dart` — `AppDataTable`: light list-table + sort headers +
  right-click hook + dense mode. First choice for POS lists.
- `tables.dart` — `AppTable`: bordered grid (fixed/flex columns, footer
  totals row) for GRNs, price lists, stock counts.
- `tree.dart` — `AppTreeView` + `AppTreeNode` (categories, chart of
  accounts), `AppTree.expandAll/collapseAll`.
- `steps.dart` — `AppTimeline` (audit trail), `AppSteps` (SOPs),
  `AppStepper` (checkout / stock-take wizard).
- `display.dart` — `AppNumberTicker` (animated totals), `AppMarquee`,
  `AppTracker` (device/sync health strip), `AppAvatarGroup`, `AppKeyCaps`,
  `AppCodeBlock`, `AppMoneyDelta`.
- `carousel.dart` — `AppCarousel` (+dots): product images, promo screens.

### Navigation & structure
- `tabs.dart` — `AppTabs` (header+body), `AppTabBar` (header-only).
- `navigation.dart` — `AppBreadcrumb`, `AppPagination`, `AppKbd`.
- `shell.dart` — `AppScaffold` (headers/footers/loading bar), `AppTopBar`,
  `AppSideNav` (rail⇄sidebar), `AppBottomNav` (mobile), `AppRefreshable`.
- `layout.dart` — `AppGap`, `AppDivider`, `AppPage`.
- `resizable.dart` — `AppSplitView` + `AppSplitPane`: drag-resize
  master-detail (the ERP workhorse).
- `accordion.dart` — `AppAccordion`, `AppCollapsible`.
- `sortable.dart` — `AppReorderableList`, `AppDragHandle`.
- `states.dart` — `AppEmptyState`, `AppErrorState`, `AppLockedState`.

## Version note
Adapters target `shadcn_flutter ^0.0.52`. Every direct shadcn touchpoint is
marked `ADAPTER (shadcn ^0.0.52)`. On upgrade: `flutter analyze` this package
first; fix signatures HERE. The app compiles against `App*` only.

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/product/ui/inventory_screen.dart';
import 'package:frontend/features/product/ui/inventory_table_screen.dart';
import 'package:frontend/features/product/ui/widgets/product_form_dialog.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'package:shadcn_wrapper/shadcn_wrapper.dart';

import '../product/bloc/product_bloc.dart';

enum ProductView { list, table }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductView _view = ProductView.list;

  void _toggleView() {
    setState(() {
      _view = _view == ProductView.list ? ProductView.table : ProductView.list;
    });
  }

  Future<void> _openDrawer(BuildContext drawerContext) async {
    await shad.openDrawer<void>(
      context: drawerContext,
      position: shad.OverlayPosition.start,
      expands: false,
      draggable: true,
      barrierDismissible: true,
      useSafeArea: true,
      transformBackdrop: false,
      showDragHandle: false,
      borderRadius: BorderRadius.all(
        Radius.circular(AppTokens.radius),
      ),
      constraints: const BoxConstraints(maxWidth: 300),
      builder: (overlayContext) {
        return SizedBox(
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppTokens.s4),
                child: Row(
                  children: [
                    const Expanded(child: Text('Inventory Playground')),
                    AppIconButton(
                      icon: const shad.Icon(shad.LucideIcons.x),
                      tooltip: 'Close menu',
                      onPressed: () => shad.closeOverlay(overlayContext),
                    ),
                  ],
                ),
              ),
              const AppDivider(),
              const AppGap.v(AppTokens.s2),
              _DrawerItem(
                icon: shad.LucideIcons.package,
                label: 'Products',
                selected: true,
                onPressed: () => shad.closeOverlay(overlayContext),
              ),
              _DrawerItem(
                icon: shad.LucideIcons.chartNoAxesColumn,
                label: 'Reports',
                onPressed: () => shad.closeOverlay(overlayContext),
              ),
              _DrawerItem(
                icon: shad.LucideIcons.settings,
                label: 'Settings',
                onPressed: () => shad.closeOverlay(overlayContext),
              ),
              const Spacer(),
              const AppDivider(),
              Padding(
                padding: const EdgeInsets.all(AppTokens.s4),
                child: Text('Inventory Playground v1.0').muted(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return shad.DrawerOverlay(
      child: Builder(
        builder: (drawerContext) {
          return AppScaffold(
            headers: [
              shad.Container(
                margin: const EdgeInsets.all(AppTokens.s2),
                child: shad.OutlinedContainer(
                  child: AppTopBar(
                    leading: [
                      AppIconButton(
                        icon: const shad.Icon(shad.LucideIcons.menu),
                        tooltip: 'Open menu',
                        onPressed: () => _openDrawer(drawerContext),
                      ),
                    ],
                    trailing: [
                      BlocBuilder<ProductBloc, ProductState>(
                        buildWhen: (previous, current) =>
                            previous.status != current.status,
                        builder: (context, state) {
                          final loading =
                              state.status == ProductStatus.loading;

                          return AppIconButton(
                            icon: shad.Icon(
                              loading
                                  ? shad.LucideIcons.loaderCircle
                                  : shad.LucideIcons.refreshCw,
                            ),
                            variant: AppButtonVariant.secondary,
                            onPressed: loading
                                ? null
                                : () => context
                                    .read<ProductBloc>()
                                    .add(const ProductsRequested()),
                          );
                        },
                      ),
                      const AppGap.h(AppTokens.s1),
                      AppIconButton(
                        icon: shad.Icon(
                          _view == ProductView.list
                              ? shad.LucideIcons.table
                              : shad.LucideIcons.list,
                        ),
                        variant: AppButtonVariant.secondary,
                        tooltip: _view == ProductView.list
                            ? 'Table view'
                            : 'List view',
                        onPressed: _toggleView,
                      ),
                      const AppGap.h(AppTokens.s1),
                      AppIconButton(
                        icon: const shad.Icon(shad.LucideIcons.plus),
                        variant: AppButtonVariant.primary,
                        // New product -> the shared dialog with proper error handling.
                        onPressed: () => ProductFormDialog.show(drawerContext),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            body: _view == ProductView.list
                ? const InventoryScreen()
                : const InventoryTableScreen(),
          );
        },
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.s2,
        vertical: AppTokens.s1,
      ),
      child: AppButton(
        variant: selected ? AppButtonVariant.secondary : AppButtonVariant.ghost,
        leading: shad.Icon(icon),
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          child: Text(label),
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/product/bloc/product_bloc.dart';
import 'package:frontend/product/product_api.dart';
import 'package:frontend/product/ui/inventory_screen.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'package:shadcn_wrapper/shadcn_wrapper.dart';

class InventoryPlaygroundApp extends StatelessWidget {
  InventoryPlaygroundApp({super.key});

  final ProductApi _productApi = ProductApi(
    createDioClient(),
  );

  @override
  Widget build(BuildContext context) {
    return shad.ShadcnApp(
      title: 'Inventory Playground',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: BlocProvider(
        create: (_) => ProductBloc(
          productApi: _productApi,
        )..add(const ProductsRequested()),
        child: const InventoryScreen(),
      ),
    );
  }
}

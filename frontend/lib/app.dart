import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/features/home/home_screen.dart';
import 'package:frontend/features/product/bloc/product_bloc.dart';
import 'package:frontend/features/product/product_api.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

class InventoryPlaygroundApp extends StatelessWidget {
  InventoryPlaygroundApp({super.key});

  final ProductApi _productApi = ProductApi(
    createDioClient(),
  );

  @override
  Widget build(BuildContext context) {
    return shad.ShadcnApp(
      title: 'Inventory Playground',
      theme: shad.ThemeData(
        colorScheme: shad.ColorSchemes.lightNeutral.indigo,
        radius: 0.75,
        surfaceOpacity: 0.7,
        surfaceBlur: 4.0,
      ),
      darkTheme: shad.ThemeData(
        colorScheme: shad.ColorSchemes.darkZinc.indigo,
        radius: 0.75,
        surfaceOpacity: 0.7,
        surfaceBlur: 4.0,
      ),
      pixelSnap: true,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => ProductBloc(
          productApi: _productApi,
        )..add(const ProductsRequested()),
        child: SafeArea(
          child: HomeScreen(),
          // child: InventoryScreen(),
        ),
      ),
    );
  }
}

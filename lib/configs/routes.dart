import 'package:flutter/material.dart';
import 'package:anyvas_api_testing/screens/authentication/auth_screen.dart';
import 'package:anyvas_api_testing/screens/product/product_details.dart';
import 'package:anyvas_api_testing/screens/products_overview_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    AuthScreen.routeName: (context) => AuthScreen(),
    ProductsOverviewScreen.routeName: (context) => ProductsOverviewScreen(),
    ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
  };
}

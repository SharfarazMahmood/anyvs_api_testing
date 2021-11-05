import 'package:anyvas_api_testing/screens/auth_screen.dart';
import 'package:anyvas_api_testing/screens/product_details.dart';
import 'package:anyvas_api_testing/widgets/products_overview_screen.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    AuthScreen.routeName: (context) => AuthScreen(),
    ProductsOverviewScreen.routeName: (context) => ProductsOverviewScreen(),
    ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
  };
}

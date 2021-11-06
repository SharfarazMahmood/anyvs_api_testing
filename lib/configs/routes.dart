import 'package:anyvas_api_testing/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:anyvas_api_testing/screens/login/login_screen.dart';
import 'package:anyvas_api_testing/screens/product/product_details.dart';
import 'package:anyvas_api_testing/screens/products_overview_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    LoginScreen.routeName: (context) => LoginScreen(),
    SignupScreen.routeName: (context) => SignupScreen(),
    ProductsOverviewScreen.routeName: (context) => ProductsOverviewScreen(),
    ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
  };
}

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:anyvas_api_testing/models/product_model.dart';
import 'package:anyvas_api_testing/screens/product_details.dart';
import 'package:anyvas_api_testing/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/product_list_provider.dart';
import './providers/categories_provider.dart';
import './theme.dart';
import './widgets/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: CategoriesProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ProductListProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ProductMdl(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        title: "Anyvas",
        home:  AnimatedSplashScreen(
          duration: 2000,
          splash: Splash(),
          splashTransition: SplashTransition.fadeTransition,
          nextScreen: ProductsOverviewScreen(),
          backgroundColor:const Color(0xff001a41),

        ),
        routes: {
          ProductsOverviewScreen.routeName: (context) =>
              ProductsOverviewScreen(),
          ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
        },
      ),
    );
  }
}

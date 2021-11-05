import 'package:anyvas_api_testing/models/product_model.dart';
import 'package:anyvas_api_testing/providers/auth_provider.dart';
import 'package:anyvas_api_testing/providers/categories_provider.dart';
import 'package:anyvas_api_testing/providers/product_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProvidersList {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider.value(
      value: AuthProvider(),
    ),
    ChangeNotifierProvider.value(
      value: CategoriesProvider(),
    ),
    ChangeNotifierProvider.value(
      value: ProductListProvider(),
    ),
    ChangeNotifierProvider.value(
      value: ProductMdl(),
    )
  ];
}

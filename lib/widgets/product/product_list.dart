import 'package:anyvas_api_testing/providers/product_list_provider.dart';
import 'package:anyvas_api_testing/widgets/product/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  final int? catId;
  ProductList({Key? key, this.catId = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData =
        Provider.of<ProductListProvider>(context, listen: false);

    // print('product list widget');

    final products = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 5,
      ),
    );
  }
}

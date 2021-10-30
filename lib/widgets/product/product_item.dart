import 'package:anyvas_api_testing/models/product_model.dart';
import 'package:anyvas_api_testing/models/screen_arguments.dart';
import 'package:anyvas_api_testing/screens/product_details.dart';
import 'package:anyvas_api_testing/widgets/add_to_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductMdl>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: ScreenArguments(
              id: product.id,
              title: product.name,
            ),
          );
        },
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.defaultPictureModel!.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            // leading: Consumer<ProductMdl>(
            //   builder: (ctx, product, _) => IconButton(
            //     onPressed: () {
            //       // product.toggleFavoriteStatus(
            //       //   authData.token,
            //       //   authData.userId,
            //       // );
            //     },
            //     icon: Icon(productisFavorite
            //         ? Icons.favorite
            //         : Icons.favorite_border),
            //     color: Theme.of(context).accentColor,
            //   ),
            // ),
            title: Text(
              product.name,
              textAlign: TextAlign.center,
            ),
            trailing: const AddToCartButton(
                // cart: cart,
                // loadedProduct: product,
                ),
          ),
        ),
      ),
    );
  }
}

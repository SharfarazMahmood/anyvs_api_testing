import 'package:flutter/material.dart';
//////// import of other screens, widgets ////////
// import '../providers/cart_provider.dart';
// import '../providers/product.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    Key? key,
    // @required this.cart,
    // @required this.loadedProduct,
  }) : super(key: key);

  // final CartProvider cart;
  // final Product loadedProduct;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // cart.addItem(
        //   productId: loadedProduct.id,
        //   title: loadedProduct.title,
        //   price: loadedProduct.price,
        // );
        // ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Added to Cart'),
        //     duration: Duration(seconds: 3),
        //     action: SnackBarAction(
        //         label: 'UNDO',
        //         onPressed: () {
        //           cart.removeSingleQuantity(productId: loadedProduct.id);
        //         }),
        //   ),
        // );
      },
      icon: Icon(Icons.shopping_cart),
      color: Color(0xff0aa22a),
    );
  }
}

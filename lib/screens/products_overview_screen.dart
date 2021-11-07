import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//////// import of other screens, widgets ////////
import '../models/screen_arguments.dart';
import '../screens/product/product_list.dart';
import '../providers/product_list_provider.dart';
import '../widgets/dropdown.dart';
import '../widgets/app_drawer.dart';

class ProductsOverviewScreen extends StatefulWidget {
  static String routeName = '/productOverview';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isLoading = false;
  var _isInit = true;

  int? catId;
  String catName = "Anyvas";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductListProvider>(context, listen: false)
        .getProducts(catId: catId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      if (ModalRoute.of(context)!.settings.arguments == null) {
        catId = 1;
      } else {
        var args =
            ModalRoute.of(context)!.settings.arguments as ScreenArguments;
        catId = args.id;
        catName = args.title.toString();
      }
      var productsList = Provider.of<ProductListProvider>(
        context,
      );
      productsList.getProducts(catId: catId).then((value) {
        setState(() {
          _isLoading = false;
        });
      });

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(catName),
        actions: <Widget>[
          DropDownMenu(),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xffe99800),
              ),
            )
          : RefreshIndicator(
              color: const Color(0xffe99800),
              onRefresh: () => _refreshProducts(context),
              child: ProductList(catId: catId),
            ),
    );
  }
}

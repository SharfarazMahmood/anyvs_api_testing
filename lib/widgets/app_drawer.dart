import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/categories_provider.dart';
import './category/categories_list.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var _isLoading = false;
  var _isInit = true;

  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<CategoriesProvider>(context, listen: false)
        .getCategoriesFromAPI();
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
      Provider.of<CategoriesProvider>(context).getCategories().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: const Color(0xff001a41),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<CategoriesProvider>(
                  builder: (ctx, categories, _) => RefreshIndicator(
                    onRefresh: () => _refreshPage(context),
                    child: CategoriesList(),
                  ),
                ),
        ),
      ),
    );
  }
}

//   {
//     "Name": "Candles",
//     "SeName": "candles",
//     "NumberOfProducts": null,
//     "IncludeInTopMenu": true,
//     "SubCategories": [],
//     "HaveSubCategories": false,
//     "Route": null,
//     "IconUrl": null,
//     "Id": 100
// }

import 'package:flutter/cupertino.dart';

class Category with ChangeNotifier {
  String? Name = '';
  String? SeName = '';
  int? NumberOfProducts = null;
  bool? IncludeInTopMenu = null;
  List<Category>? SubCategories = [];
  bool? HaveSubCategories = false;
  String? Route = null;
  String? IconUrl = null;
  int? Id = null;

  Category({
    this.Name,
    this.SeName,
    this.NumberOfProducts,
    this.IncludeInTopMenu,
    this.SubCategories,
    this.HaveSubCategories,
    this.Route,
    this.IconUrl,
    this.Id,
  });
}

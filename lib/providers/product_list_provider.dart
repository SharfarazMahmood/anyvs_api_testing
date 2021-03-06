import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//////// import of config files ////////
import '../helpers/http_helper.dart';
import '../models/product_model.dart';

class ProductListProvider with ChangeNotifier {
  List<ProductMdl> _items = [];

  ProductListProvider();

  List<ProductMdl> get items {
    return [..._items];
  }

  Future<void> getProducts({int? catId = 1}) async {
    String responseData = await compute<int?, String>(fetchFromApi, catId);
    if (responseData == "-1") {
    } else {
      _items = await createProductObject(responseData);
    }
    notifyListeners();
  }
}

/////////// using http request to get products data from API
Future<String> fetchFromApi(int? id) async {
  var request = http.Request(
      'GET', Uri.parse('http://incap.bssoln.com/api/category/$id'));
  request.body = json.encode({"Id": id});
  request.headers.addAll(HttpHelper.headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    return responseData;
  } else {
    print("${response.statusCode}  ${response.reasonPhrase}");
  }

  return "-1";
}

////////// converting API resopnseData string to a product list
Future<List<ProductMdl>> createProductObject(String responseData) async {
  List<ProductMdl> list = [];
  final extractedData = json.decode(responseData) as Map<String, dynamic>;
  final productsData =
      extractedData['Data']['CatalogProductsModel']['Products'] as List;

  for (var i = 0; i < productsData.length; i++) {
    var dpmData = productsData[i]['DefaultPictureModel'];
    PictureModel dpm = PictureModel(
      imageUrl: dpmData['ImageUrl'],
      fullSizeImageUrl: dpmData['FullSizeImageUrl'],
      title: dpmData['Title'],
      alternateText: dpmData['AlternateText'],
    );

    // log(dpm.imageUrl);
    list.add(ProductMdl(
      name: productsData[i]['Name'],
      id: productsData[i]['Id'],
      defaultPictureModel: dpm,
    ));
  }
  return list;
}

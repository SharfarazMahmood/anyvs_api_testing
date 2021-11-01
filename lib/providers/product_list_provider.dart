import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:anyvas_api_testing/models/product_model.dart';

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
    // _items.forEach((element) {
    //   print(element.name);
    //   print(element.defaultPictureModel!.imageUrl);
    // });
  }
}

/////////// using http request to get products data from API
Future<String> fetchFromApi(int? id) async {
  var headers = {
    'NST':
        'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJOU1RfS0VZIjoidGVzdGFwaTEyM3Nha2hhdyJ9.l9txvKvpCrPsW78C9CFfUEVBbZcPpC7kBESRWBUthWjBG6dfP0YgrtoNKoe-PHExT_LGzYXoT1vvxGzWKxDGMA',
    'Token':
        'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJOU1RfS0VZIjoidGVzdGFwaTEyM3Nha2hhdyJ9.ca-7lHYgFnU_LXR_Q6_j3pIVb8oAkbn7kDonJn_4SepPhewJ6AHJyLUoITkAsIeOhakoePZ1bjq1rAb3f0GwrQ',
    'DeviceId': 'DeviceId',
    'Content-Type': 'application/json',
  };
  var request = http.Request(
      'GET', Uri.parse('http://incap.bssoln.com/api/category/$id'));
  request.body = json.encode({"Id": id});
  // print('http://incap.bssoln.com/api/category/$id');
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    return responseData;
  } else {
    print(response.reasonPhrase);
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

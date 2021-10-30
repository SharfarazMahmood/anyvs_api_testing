import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:anyvas_api_testing/models/product_model.dart';

class ProductListProvider with ChangeNotifier {
  List<ProductMdl> _items = [];

  ProductListProvider();

  List<ProductMdl> get items {
    return [..._items];
  }

  List<ProductMdl> categoryItems({int? id}) {
    return [..._items];
  }

  Future<void> getProducts({int? id}) async {
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
      // print(responseData);
      // log(responseData);

      final extractedData = json.decode(responseData) as Map<String, dynamic>;
      final productsData =
          extractedData['Data']['CatalogProductsModel']['Products'] as List;
      List<ProductMdl> productsList = [];
      productsList = createProductObject(productsData);
      _items = productsList;
      notifyListeners();
      // _items.forEach((element) {
      //   print(element.name);
      //   print(element.defaultPictureModel!.imageUrl);
      // });
    } else {
      print(response.reasonPhrase);
    }
  }

  List<ProductMdl> createProductObject(List<dynamic> productsData) {
    List<ProductMdl> list = [];

    for (var i = 0; i < productsData.length; i++) {
      var dpmData = productsData[i]['DefaultPictureModel'];
      PictureModel dpm = PictureModel(
        imageUrl: dpmData['ImageUrl'],
        // thumbImageUrl: dpmData['ThumbImageUrl'],
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
}

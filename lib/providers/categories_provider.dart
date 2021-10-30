import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoriesProvider with ChangeNotifier {
  List<Category> _items = [];

  CategoriesProvider() {
    // getCategories();
  }

  List<Category> get items {
    return [..._items];
  }

  Future<void> getCategories() async {
    var headers = {
      'NST':
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJOU1RfS0VZIjoidGVzdGFwaTEyM3Nha2hhdyJ9.l9txvKvpCrPsW78C9CFfUEVBbZcPpC7kBESRWBUthWjBG6dfP0YgrtoNKoe-PHExT_LGzYXoT1vvxGzWKxDGMA',
      'Token':
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJOU1RfS0VZIjoidGVzdGFwaTEyM3Nha2hhdyJ9.ca-7lHYgFnU_LXR_Q6_j3pIVb8oAkbn7kDonJn_4SepPhewJ6AHJyLUoITkAsIeOhakoePZ1bjq1rAb3f0GwrQ',
      'DeviceId': 'DeviceId',
    };
    var request = http.Request(
        'GET', Uri.parse('http://incap.bssoln.com/api/categories'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      // log(responseData);

      final extractedData = json.decode(responseData) as Map<String, dynamic>;
      final categoriesData = extractedData['Data']['Categories'] as List;
      List<Category> categoriesList = [];
      categoriesData.length;
      categoriesList = createCategoryObject(categoriesData);
      // for (var i = 0; i < categoriesData.length; i++) {
      //   categoriesList.add(Category(
      //     Name: categoriesData[i]['Name'],
      //     SeName: categoriesData[i]['SeName'],
      //     NumberOfProducts: categoriesData[i]['NumberOfProducts'],
      //     IncludeInTopMenu: categoriesData[i]['IncludeInTopMenu'],
      //     // SubCategories: categoriesData[i]['SubCategories'],
      //     HaveSubCategories: categoriesData[i]['HaveSubCategories'],
      //     Route: categoriesData[i]['Route'],
      //     IconUrl: categoriesData[i]['IconUrl'],
      //     Id: categoriesData[i]['Id'],
      //   ));
      // }
      _items = categoriesList;
      notifyListeners();
      // _items.forEach((element) {
      //   print(element.Name);
      //   print(element.Id);
      // });
    } else {
      print(response.reasonPhrase);
    }
  }

  List<Category> createCategoryObject(List<dynamic> categoriesData) {
    List<Category> list = [];
    for (var i = 0; i < categoriesData.length; i++) {
      list.add(Category(
        Name: categoriesData[i]['Name'],
        SeName: categoriesData[i]['SeName'],
        NumberOfProducts: categoriesData[i]['NumberOfProducts'],
        IncludeInTopMenu: categoriesData[i]['IncludeInTopMenu'],
        // SubCategories: categoriesData[i]['SubCategories'],
        HaveSubCategories: categoriesData[i]['HaveSubCategories'],
        Route: categoriesData[i]['Route'],
        IconUrl: categoriesData[i]['IconUrl'],
        Id: categoriesData[i]['Id'],
      ));
    }
    return list;
  }
}

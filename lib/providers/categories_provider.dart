import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';

class CategoriesProvider with ChangeNotifier {
  List<Category> _items = [];

  CategoriesProvider() {}

  List<Category> get items {
    return [..._items];
  }

  Future<void> getCategoriesFromAPI() async {
    print('no saved category, using HTTP requests');
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

      _items = categoriesList;
      notifyListeners();

      String toBeSaved;
      toBeSaved = Category.encode(_items);
      // print(toBeSaved);

      // Future<bool>? saved = null;
      try {
        await SharedPreferences.getInstance().then((prefs) {
          // saved = prefs.setString('categoryList', toBeSaved);
          prefs.setString('categoryList', toBeSaved);
        });
      } on Exception catch (e) {
        print(e);
      }
      // print(saved.toString());

      // _items.forEach((element) {
      //   print(element.Name);
      //   print(element.Id);
      // });
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> getCategories() async {
    await SharedPreferences.getInstance().then((prefs) {
      String? _savedData = prefs.getString('categoryList') ?? null;
      // print(_savedData);
      if (_savedData != null) {
        _items = Category.decode(_savedData);
        notifyListeners();
        // _items.forEach((element) {
        //   print("${element.Name}  ${element.Id}");
        // });
        print('loading saved category data');
      }
    });

    if (_items.length <= 0) {
      await getCategoriesFromAPI();
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

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:anyvas_api_testing/helpers/encryption.dart';
import 'package:anyvas_api_testing/helpers/http_helper.dart';
import 'package:anyvas_api_testing/helpers/storage_helper.dart';
import 'package:anyvas_api_testing/models/user.dart';
import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  bool _loggedIn = false;
  User? _userData;

  bool get loggedIn {
    return _loggedIn;
  }

  User? get user {
    return _userData;
  }

  Future<bool> _authenticate(String? email, String? password) async {
    try {
      var request =
          http.Request('POST', Uri.parse('http://incap.bssoln.com/api/login'));
      request.body = json.encode({"username": email, "password": password});
      request.headers.addAll(HttpHelper.headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        _userData = await createUserObject(
          responseData,
          EncryDecry.methods().toEncrypt(password!),
        );

        String toBeSaved;
        toBeSaved = User.encode(_userData);
        try {
          await StorageHelper.saveData(key: "anyvas_user", data: toBeSaved);
        } on Exception catch (e) {
          print(e);
        }

        print("${_userData!.username} ${_userData!.token.toString()}");
        _loggedIn = true;
        notifyListeners();
        print('LOGGED IN ');
        return true;
        // log(responseData);
      } else {
        print(" ${response.statusCode} - ${response.reasonPhrase} ");
        var responseData = await response.stream.bytesToString();
        List<String> errorList = await createHttpErrorList(responseData);
        errorList.forEach((errorMessage) {
          log(errorMessage);
          HttpException.errorList.forEach((error) {
            if (errorMessage.contains(error)) {
              throw HttpException(error);
            }
          });
          if (response.statusCode == 400) {
            throw HttpException(response.reasonPhrase.toString());
          }
        });
      }
    } catch (error) {
      // print(error);
      throw error;
    }
    return false;
  }

  Future<bool>? autoLogin() async {
    bool res = false;
    var result;
    String? _savedData = null;
    await StorageHelper.loadData(key: 'anyvas_user').then((String result) {
      _savedData = result;
    });
    if (_savedData != null &&
        !_savedData!.contains("no data found in storage.")) {
      _userData = User.decode(_savedData!);
      print('${_userData!.firstName}  ${_userData!.lastName}');
      res = true;
    }
    if (res) {
      result = _authenticate(
        _userData!.email,
        EncryDecry.methods().toDecrypt(_userData!.getCredential),
      );
      return result;
    }
    return false;
  }

  Future<bool> login(String? email, String? password) async {
    return _authenticate(
      email,
      password,
    );
  }

  Future<bool> logout() async {
    var request =
        http.Request('GET', Uri.parse('http://incap.bssoln.com/api/logout'));
    request.body = '''''';
    request.headers.addAll(HttpHelper.headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print("after logging out");
      var userDataDeleted = await StorageHelper.removeData(key: 'anyvas_user');
      if (userDataDeleted) {
        _loggedIn = false;
        _userData = null;
        notifyListeners();
        return userDataDeleted;
      }
    } else {
      print(response.reasonPhrase);
      print("after logging error ");
    }
    print(" logging out failed");
    notifyListeners();
    return false;
  }
}

Future<List<String>> createHttpErrorList(String responseData) async {
  List<String> errorList = [];
  final extractedData = json.decode(responseData) as Map<String, dynamic>;

  extractedData['ErrorList'].forEach((element) {
    errorList.add(element);
    // print(element);
  });
  return errorList;
}

Future<User> createUserObject(String responseData, String data) async {
  final extractedData = json.decode(responseData) as Map<String, dynamic>;
  final userData = User(
    email: extractedData['Data']['Info']['Email'],
    phone: extractedData['Data']['Info']['Phone'],
    username: extractedData['Data']['Info']['Username'],
    firstName: extractedData['Data']['Info']['FirstName'],
    lastName: extractedData['Data']['Info']['LastName'],
    token: extractedData['Data']['Token'],
    cred: data,
  );
  // print("${userData.email}, ${userData.phone} ${userData.username} ");

  return userData;
}

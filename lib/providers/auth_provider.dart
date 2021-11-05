import 'dart:convert';
import 'dart:developer';
import 'package:anyvas_api_testing/helpers/encryption.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:anyvas_api_testing/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      var headers = {
        'NST':
            'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJOU1RfS0VZIjoidGVzdGFwaTEyM3Nha2hhdyJ9.l9txvKvpCrPsW78C9CFfUEVBbZcPpC7kBESRWBUthWjBG6dfP0YgrtoNKoe-PHExT_LGzYXoT1vvxGzWKxDGMA',
        'Tocken':
            'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJOU1RfS0VZIjoidGVzdGFwaTEyM3Nha2hhdyJ9.ca-7lHYgFnU_LXR_Q6_j3pIVb8oAkbn7kDonJn_4SepPhewJ6AHJyLUoITkAsIeOhakoePZ1bjq1rAb3f0GwrQ',
        'DeviceId': 'DeviceId',
        'Content-Type': 'application/json',
      };
      var request =
          http.Request('POST', Uri.parse('http://incap.bssoln.com/api/login'));
      request.body = json.encode({"username": email, "password": password});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        _userData = await createUserObject(
            responseData, EncryDecry.methods().toEncrypt(password!));

        String toBeSaved;
        toBeSaved = User.encode(_userData);
        try {
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setString('anyvas_user', toBeSaved);
          });
        } on Exception catch (e) {
          print(e);
        }

        // print("${_userData!.username} ${_userData!.token.toString()}");
        _loggedIn = true;
        notifyListeners();
        // print('LOGGED IN ');
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
    await SharedPreferences.getInstance().then((prefs) {
      String? _savedData = prefs.getString('anyvas_user') ?? null;
      // print(_savedData);
      if (_savedData != null) {
        _userData = User.decode(_savedData);
        print('${_userData!.firstName}  ${_userData!.lastName}');
        // print('loading saved user data');
        res = true;
      }
    });
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
    var headers = {
      'NST':
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJOU1RfS0VZIjoidGVzdGFwaTEyM3Nha2hhdyJ9.l9txvKvpCrPsW78C9CFfUEVBbZcPpC7kBESRWBUthWjBG6dfP0YgrtoNKoe-PHExT_LGzYXoT1vvxGzWKxDGMA',
      'Tocken':
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJOU1RfS0VZIjoidGVzdGFwaTEyM3Nha2hhdyJ9.ca-7lHYgFnU_LXR_Q6_j3pIVb8oAkbn7kDonJn_4SepPhewJ6AHJyLUoITkAsIeOhakoePZ1bjq1rAb3f0GwrQ',
      'DeviceId': 'DeviceId',
    };
    var request =
        http.Request('GET', Uri.parse('http://incap.bssoln.com/api/logout'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var result = null;
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print("after logging out");
      var userDataDeleted = await SharedPreferences.getInstance().then((prefs) {
        return prefs.remove('anyvas_user');
      });
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
  // errorList = extractedData['ErrorList'];

  extractedData['ErrorList'].forEach((element) {
    errorList.add(element);
    print(element);
  });
  // print("${userData.email}, ${userData.phone} ${userData.username} ");

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

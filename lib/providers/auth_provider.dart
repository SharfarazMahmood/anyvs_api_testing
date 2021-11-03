import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:anyvas_api_testing/models/user.dart';
import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  bool _loggedIn = false;
  String _userId = "no_id";
  String get userId {
    return _userId;
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
        User userData = await createUserObject(responseData);
        print("${userData.email}, ${userData.phone} ${userData.username} ");
        _loggedIn = true;
        notifyListeners();
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

  Future<bool> login(String? email, String? password) async {
    return _authenticate(
      email,
      password,
    );
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

Future<User> createUserObject(String responseData) async {
  final extractedData = json.decode(responseData) as Map<String, dynamic>;
  final userData = User(
    email: extractedData['Data']['Info']['Email'],
    phone: extractedData['Data']['Info']['Phone'],
    username: extractedData['Data']['Info']['Username'],
    firstName: extractedData['Data']['Info']['FirstName'],
    lastName: extractedData['Data']['Info']['LastName'],
  );
  // print("${userData.email}, ${userData.phone} ${userData.username} ");

  return userData;
}

import 'package:flutter/material.dart';
import 'package:installatori_de/utils/api_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {


  Future<bool> login(String email, String password) async {

    final response = await ApiRequests.sendLoginRequest('login', email, password);

    if(response != null && response['error'] == false) {

      final sharedPref = await SharedPreferences.getInstance();
      sharedPref.setInt('id', response['data']['id']);
      sharedPref.setString('email', response['data']['mail']);
      sharedPref.setString('token', response['data']['token']);
      sharedPref.setString('role', response['data']['role']);
      sharedPref.setString('refreshToken', response['data']['refreshToken']);

      return true;
    }

    return false;
  }

}
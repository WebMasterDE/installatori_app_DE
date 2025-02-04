import 'package:flutter/material.dart';
import 'package:installatori_de/utils/api_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  Future<bool> login(String email, String password) async {
    final response =
        await ApiRequests.sendLoginRequest('login', email, password);

    if (response != null && response['error'] == false) {
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

  Future<bool> logout() async {
    final response = await ApiRequests.sendAuthRequest('logout', 'POST', {});

    if (response['error'] == false) {
      final sharedPref = await SharedPreferences.getInstance();
      sharedPref.remove('id');
      sharedPref.remove('email');
      sharedPref.remove('token');
      sharedPref.remove('role');

      return true;
    } else {
      return false;
    }
  }

  Future<bool> check_token() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    // prefs.remove('id');
    // prefs.remove('email');
    // prefs.remove('token');
    // prefs.remove('role');
    // prefs.remove('resfreshToken');


    if (token.isEmpty) {
      return false;
    }
    return true;
  }
}

// lib/screen/login_screen/provider/user_provider.dart
import 'package:e_commerce_flutter/screen/home_screen.dart';
import 'package:e_commerce_flutter/utility/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/api_response.dart';
import '../../../models/user.dart';
import '../../../services/http_services.dart';
import '../login_screen.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utility/constants.dart';

class UserProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final box = GetStorage();

  UserProvider();

  User? getLoginUsr() {
    Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
    if (userJson == null || userJson.isEmpty) return null;
    try {
      User? userLogged = User.fromJson(userJson);
      return userLogged;
    } catch (e) {
      return null;
    }
  }

  Future<void> loginUser(String name, String password) async {
    try {
      Map<String, dynamic> loginData = {
        'name': name.toLowerCase(),
        'password': password,
      };

      final response = await service.addItem(
        endpointUrl: 'users/login',
        itemData: loginData,
      );

      if (response.isOk) {
        final ApiResponse<User> apiResponse = ApiResponse<User>.fromJson(
          response.body,
          (json) => User.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.success == true) {
          User? user = apiResponse.data;
          await saveLoginInfo(user); // persist BEFORE navigating
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);

          Get.offAll(const HomeScreen());
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Login failed: ${response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Login failed: $e');
      rethrow;
    }
  }

  Future<void> registerUser(String name, String password) async {
    try {
      Map<String, dynamic> user = {
        "name": name.toLowerCase(),
        "password": password,
      };

      final response = await service.addItem(
        endpointUrl: 'users/register',
        itemData: user,
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          await loginUser(name, password);
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Registration failed: $e');
      rethrow;
    }
  }

  Future<void> saveLoginInfo(User? loginUser) async {
    // Defensive: only write non-null and ensure we don't wipe out user data
    if (loginUser == null) return;
    try {
      await box.write(USER_INFO_BOX, loginUser.toJson());
      notifyListeners();
    } catch (e) {
      print('Failed to save login info: $e');
    }
  }

  void logOutUser() {
    // Be explicit: remove only the user info — don't clear other app prefs
    box.remove(USER_INFO_BOX);
    Get.offAll(const LoginScreen());
    notifyListeners();
  }
}
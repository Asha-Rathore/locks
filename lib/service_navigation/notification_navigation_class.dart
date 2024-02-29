import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/services/shared_preference.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/static_data.dart';
import 'package:provider/provider.dart';

class NotificationNavigationClass {
  UserProvider? _userProvider;

  void notificationMethod(
      {required BuildContext context,
        Map<String, dynamic>? notificationData,
        String? pushNotificationType}) {
    _setUserSession(context: context);

    //log("Notification Data:${notificationData}");

    if (notificationData != null) {
      //Go To Main Screen
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.MAIN_SCREEN_ROUTE);
    } else {
      //Go To Main Screen
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.MAIN_SCREEN_ROUTE);
    }
  }

  void checkUserSessionMethod({required BuildContext context}) {


    if (SharedPreference().getUser() != null) {
      print("check");
      //assign reference to user provider
      _userProvider = Provider.of<UserProvider>(context, listen: false);

      //set login response to user provider method
      _userProvider?.setCurrentUser(
          user: jsonDecode(SharedPreference().getUser()!));

      print("check");

      //Go To Home Screen
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.MAIN_SCREEN_ROUTE);
    } else {
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.PRE_LOGIN_SCREEN_ROUTE);
    }
  }

  void _setUserSession({required BuildContext context}) {
    if (SharedPreference().getUser() != null) {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      if (_userProvider?.getCurrentUser == null) {
        //set login response to user provider method
        _userProvider?.setCurrentUser(
            user: jsonDecode(SharedPreference().getUser()!));
      }
    }
  }




}

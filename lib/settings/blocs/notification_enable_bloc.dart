import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/services/shared_preference.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class NotificationEnableBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  UserProvider? _userProvider;

  /// ------------- Notification Enable Bloc Method -------------- ///
  void notificationBlocMethod({
    required BuildContext context,
    required VoidCallback setProgressBar,
    bool? notificationEnable,
  }) async {
    setProgressBar();

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(endPoint: NetworkStrings.NOTIFICATION_ENABLE_ENDPOINT);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _notificationEnableResponseMethod(
          context: context, notificationEnable: notificationEnable);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _postRequest({required String endPoint}) async {
    //print("post request");
    _response = await Network().postRequest(
        baseUrl: NetworkStrings.API_BASE_URL,
        endPoint: endPoint,
        formData: _formData,
        onFailure: _onFailure,
        isHeaderRequire: true);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _notificationEnableResponseMethod(
      {required BuildContext context, bool? notificationEnable}) {
    try {
      //assign reference to user provider
      _userProvider = Provider.of<UserProvider>(context, listen: false);

      //set notification key enable or disable
      _userProvider?.getCurrentUser?.data?.notifications =
          notificationEnable == true
              ? NotificationType.enable.index
              : NotificationType.disable.index;


      _userProvider?.setCurrentUser(
          user: _userProvider?.getCurrentUser?.toJson());

      //set user data in shared preference
      SharedPreference()
          .setUser(user: jsonEncode(_userProvider?.getCurrentUser?.toJson()));
    } catch (error) {
      log("Error:${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/auth/routing_arguments/otp_arguments.dart';
import 'package:locks_hybrid/services/firebase_messaging_service.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/network_strings.dart';

class LoginBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _loginResponse;
  String? _deviceToken;

  /// ------------- Login Bloc Method -------------- ///
  void loginBlocMethod({
    required BuildContext context,
    String? userEmail,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();

    _deviceToken = await FirebaseMessagingService().getToken();
    print("Device Token:${_deviceToken}");


    //Form Data
    _formData = FormData.fromMap({
      "email": userEmail,
      "device_type": Platform.isIOS ? AppStrings.IOS : AppStrings.ANDROID,
      "device_token": _deviceToken
    });

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(endPoint: NetworkStrings.LOGIN_ENDPOINT);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _loginResponseMethod(context: context);
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
        isHeaderRequire: false);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _loginResponseMethod({required BuildContext context}) {
    try {
      _loginResponse = _response?.data;

      if (_loginResponse != null) {
        print("Login Response:${_loginResponse}");
        AppNavigation.navigateTo(
            context, AppRouteName.VERIFICATION_SCREEN_ROUTE,
            arguments: OtpArguments(
                otpType: OtpType.login.name,
                userId: _loginResponse["data"]["user_id"]));
      }
    } catch (error) {
      log("Error:${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}

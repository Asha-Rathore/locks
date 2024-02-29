import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/services/firebase_messaging_service.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/services/shared_preference.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class SocialLoginBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _socialLoginResponse;
  UserProvider? _userProvider;
  String? _deviceToken;

  /// ------------- Social Login Bloc Method -------------- ///
  void socialLoginBlocMethod({
    required BuildContext context,
    String? socialToken,
    String? socialType,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? phoneCode,
    String? countryCode,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();

    _deviceToken = await FirebaseMessagingService().getToken();
    print("Device Token:${_deviceToken}");

    //Form Data
    _formData = FormData.fromMap({
      "access_token": socialToken,
      "provider": socialType,
      "device_type": Platform.isIOS ? AppStrings.IOS : AppStrings.ANDROID,
      "device_token": _deviceToken,
      "phone_number": phoneNumber,
      "phone_code": phoneCode,
      "country_code": countryCode,
      "first_name": firstName,
      "last_name": lastName
    });

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(endPoint: NetworkStrings.SOCIAL_LOGIN_ENDPOINT);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _socialLoginResponseMethod(context: context);
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

  void _socialLoginResponseMethod({required BuildContext context}) {
    try {
      _socialLoginResponse = _response?.data;

      if (_socialLoginResponse != null) {
        print("Social Login Response:${_socialLoginResponse}");

        _checkCompleteProfile(context: context);
      }
    } catch (error) {
      log("Error:${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }

  //to check complete profile
  void _checkCompleteProfile({required BuildContext context}) {
    //Set Bearer Token
    SharedPreference().setBearerToken(token: _socialLoginResponse["token"]);

    //assign reference to user provider
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    //set verify otp response to user provider method
    _userProvider?.setCurrentUser(user: _socialLoginResponse);

    //if profile complete
    if (_socialLoginResponse["data"]["is_profile_complete"] ==
        NetworkStrings.PROFILE_COMPLETED) {
      //set user data in shared preference
      SharedPreference().setUser(user: jsonEncode(_socialLoginResponse));

      //Go To Home Screen
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.MAIN_SCREEN_ROUTE);
    }
    //if profile incomplete
    else {
      AppNavigation.navigateToRemovingAll(
        context,
        AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE,
      );
    }
  }
}

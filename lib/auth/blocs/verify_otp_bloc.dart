import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/services/shared_preference.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class VerifyOtpBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _verifyOtpResponse;
  UserProvider? _userProvider;

  /// ------------- Verify Otp Bloc Method -------------- ///
  void verifyOtpBlocMethod({
    required BuildContext context,
    int? userId,
    String? otp,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();

    //Form Data
    _formData = FormData.fromMap({"user_id": userId, "otp": otp});

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(endPoint: NetworkStrings.VERIFY_OTP_ENDPOINT);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _verifyOtpResponseMethod(context: context);
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

  void _verifyOtpResponseMethod({required BuildContext context}) {
    try {
      _verifyOtpResponse = _response?.data;

      if (_verifyOtpResponse != null) {
        print("Verify Otp Response:${_verifyOtpResponse}");

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
    SharedPreference().setBearerToken(token: _verifyOtpResponse["token"]);

    //assign reference to user provider
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    //set verify otp response to user provider method
    _userProvider?.setCurrentUser(user: _verifyOtpResponse);

    //agar profile complete ha to
    if (_verifyOtpResponse["data"]["is_profile_complete"] ==
        NetworkStrings.PROFILE_COMPLETED) {
      //set user data in shared preference
      SharedPreference().setUser(user: jsonEncode(_verifyOtpResponse));

      //Go To Home Screen
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.MAIN_SCREEN_ROUTE);
    }
    //agar profile in complete ha to
    else {
      AppNavigation.navigateToRemovingAll(
        context,
        AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE,
      );
    }
  }
}
